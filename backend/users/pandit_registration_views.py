from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from django.core.mail import send_mail
from django.conf import settings
from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.utils import timezone
from .models import PanditProfile, CustomUser
from core.google_sheets_service import append_to_google_sheet
from core.google_drive_service import upload_base64_to_drive
from datetime import datetime, timezone as dt_timezone
import logging

logger = logging.getLogger(__name__)


@api_view(['POST'])
@permission_classes([AllowAny])
def register_pandit(request):
    """
    Handle comprehensive pandit registration from landing page
    Saves to database AND Google Sheets with all fields
    """
    try:
        data = request.data
        
        # Validate required fields
        required_fields = ['name', 'phone', 'email', 'dob', 'gender', 'state', 'address',
                          'specialization', 'experience', 'languages', 
                          'working_days', 'availability', 'weekly_hours', 
                          'account_name', 'account_number', 'ifsc_code', 
                          'bank_name', 'pan_card', 'bio', 'technical_access', 'how_heard',
                          'id_proof', 'photo']
        
        missing_fields = [field for field in required_fields if not data.get(field)]
        if missing_fields:
            return Response(
                {'error': f'Missing required fields: {", ".join(missing_fields)}'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Check if phone or email already exists
        if CustomUser.objects.filter(phone=data['phone']).exists():
            return Response(
                {'error': 'Phone number already registered'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if CustomUser.objects.filter(email=data['email']).exists():
            return Response(
                {'error': 'Email already registered'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Calculate age from DOB
        dob = datetime.fromisoformat(data['dob'].replace('Z', '+00:00'))
        if dob.tzinfo is None:
            dob = dob.replace(tzinfo=dt_timezone.utc)
        now = timezone.now().astimezone(dt_timezone.utc)
        age = max(0, (now - dob).days // 365)
        
        # Create user account (inactive until approved)
        user = CustomUser.objects.create(
            username=data['phone'],  # Use phone as username
            phone=data['phone'],
            email=data['email'],
            first_name=data['name'].split()[0] if data['name'] else '',
            last_name=' '.join(data['name'].split()[1:]) if len(data['name'].split()) > 1 else '',
            is_pandit=True,
            is_active=False,  # Will be activated after admin approval
            bio=data.get('bio', ''),
        )
        
        # Save uploaded files
        import base64
        
        def decode_file(base64_string, filename):
            file_data = base64_string.split(',')[1] if ',' in base64_string else base64_string
            return ContentFile(base64.b64decode(file_data), name=filename)
        
        id_proof_file = decode_file(data['id_proof'], f"id_proof_{data['phone']}_{data['id_proof_filename']}")
        photo_file = decode_file(data['photo'], f"photo_{data['phone']}_{data['photo_filename']}")
        
        # Persist files to media storage
        id_proof_path = default_storage.save(f"pandit_uploads/id_proofs/{id_proof_file.name}", id_proof_file)
        photo_path = default_storage.save(f"pandit_uploads/photos/{photo_file.name}", photo_file)

        # Upload copies to Google Drive for sheet previews
        id_proof_drive = None
        photo_drive = None
        try:
            logger.info(f"Uploading ID proof to Google Drive: {id_proof_file.name}")
            id_proof_drive = upload_base64_to_drive(id_proof_file.name, data['id_proof'])
            if id_proof_drive:
                logger.info(f"ID proof uploaded successfully. Drive ID: {id_proof_drive.get('file_id')}")
            else:
                logger.warning("ID proof Drive upload returned None - check Drive API setup")
        except Exception as e:
            logger.error(f"Failed to upload ID proof to Drive: {str(e)}")
        
        try:
            logger.info(f"Uploading photo to Google Drive: {photo_file.name}")
            photo_drive = upload_base64_to_drive(photo_file.name, data['photo'])
            if photo_drive:
                logger.info(f"Photo uploaded successfully. Drive ID: {photo_drive.get('file_id')}")
            else:
                logger.warning("Photo Drive upload returned None - check Drive API setup")
        except Exception as e:
            logger.error(f"Failed to upload photo to Drive: {str(e)}")
        
        # Save photo to user profile for quick reference
        user.profile_pic = photo_path
        user.save(update_fields=['profile_pic'])
        
        # Prepare structured fields for PanditProfile
        specializations = [data['specialization'].strip()]
        if data.get('other_services'):
            specializations.extend([
                svc.strip() for svc in data['other_services'].split(',')
                if svc.strip()
            ])
        
        languages = [
            lang.strip() for lang in data['languages'].split(',')
            if lang.strip()
        ]
        
        working_days_list = [
            day.strip() for day in data['working_days'].split(',')
            if day.strip()
        ]
        availability_slots = [
            slot.strip() for slot in data['availability'].split(',')
            if slot.strip()
        ]
        working_hours = {
            'working_days': working_days_list,
            'availability': availability_slots,
            'weekly_hours': data.get('weekly_hours')
        }
        
        # Create PanditProfile with all fields
        pandit_profile = PanditProfile.objects.create(
            user=user,
            specializations=specializations,
            experience_years=int(data['experience']),
            languages=languages,
            working_hours=working_hours,
            is_verified=False,  # Will be verified by admin
            availability_status='offline',  # Default to unavailable until approved
            
            # Bank details
            bank_account_number=data['account_number'],
            bank_ifsc=data['ifsc_code'],
            bank_account_holder=data['account_name'],
            pan_number=data['pan_card'],
        )
        
        # Save files to media folder (you can implement actual file storage here)
        logger.info(f"ID Proof uploaded: {data['id_proof_filename']}")
        logger.info(f"Photo uploaded: {data['photo_filename']}")
        
        # Prepare comprehensive data for Google Sheets
        def sheet_file_value(drive_info, fallback_label):
            if not drive_info:
                return fallback_label
            if (drive_info.get('mime_type') or '').startswith('image/'):
                return f'=IMAGE("{drive_info["view_url"]}")'
            return f'=HYPERLINK("{drive_info["view_url"]}", "View File")'

        sheet_data = [
            data.get('registration_date', ''),
            data['name'],
            data['phone'],
            data['email'],
            data['dob'],
            str(age),
            data['gender'],
            data['state'],
            data['address'],
            data['specialization'],
            data.get('other_services', ''),
            str(data['experience']),
            data.get('education', ''),
            data['languages'],
            data.get('qualifications', ''),
            data['working_days'],
            data['availability'],
            data['weekly_hours'],
            data['account_name'],
            data['account_number'],
            data['ifsc_code'],
            data['bank_name'],
            data['pan_card'],
            data['bio'],
            data.get('achievements', ''),
            sheet_file_value(id_proof_drive, data.get('id_proof_filename', '')),
            sheet_file_value(photo_drive, data.get('photo_filename', '')),
            data['technical_access'],
            data['how_heard'],
            data.get('comments', ''),
            'Pending',  # Approval Status
            str(user.id),  # User ID for reference
            data.get('registration_source', 'Landing Page'),
        ]
        
        # Save to Google Sheets
        try:
            append_to_google_sheet('Pandit Registrations', sheet_data)
            logger.info(f"Pandit registration saved to Google Sheets: {data['name']}")
        except Exception as e:
            logger.error(f"Failed to save to Google Sheets: {str(e)}")
            # Continue even if Google Sheets fails
        
        # Send comprehensive notification email to admin
        try:
            admin_message = f"""
🙏 NEW PANDIT REGISTRATION RECEIVED!

═══════════════════════════════════════
PERSONAL INFORMATION
═══════════════════════════════════════
Name: {data['name']}
Phone: {data['phone']}
Email: {data['email']}
Date of Birth: {data['dob']} (Age: {age})
Gender: {data['gender']}
State: {data['state']}
Address: {data['address']}

═══════════════════════════════════════
PROFESSIONAL DETAILS
═══════════════════════════════════════
Main Specialization: {data['specialization']}
Other Services: {data.get('other_services', 'N/A')}
Experience: {data['experience']} years
Education: {data['education']}
Languages: {data['languages']}
Certifications: {data.get('qualifications', 'N/A')}

═══════════════════════════════════════
DOCUMENTS
═══════════════════════════════════════
ID Proof: {data.get('id_proof_filename', 'N/A')}
Photo: {data.get('photo_filename', 'N/A')}

═══════════════════════════════════════
AVAILABILITY
═══════════════════════════════════════
Working Days: {data['working_days']}
Working Hours: {data['availability']}
Expected Weekly Hours: {data['weekly_hours']}

═══════════════════════════════════════
BANK DETAILS
═══════════════════════════════════════
Account Holder: {data['account_name']}
Account Number: {data['account_number']}
IFSC Code: {data['ifsc_code']}
Bank Name: {data['bank_name']}
PAN Card: {data['pan_card']}

═══════════════════════════════════════
BIO & ACHIEVEMENTS
═══════════════════════════════════════
{data['bio']}

Achievements: {data.get('achievements', 'N/A')}

═══════════════════════════════════════
ADDITIONAL INFO
═══════════════════════════════════════
Technical Access: {data['technical_access']}
How They Heard: {data['how_heard']}
Comments: {data.get('comments', 'N/A')}

═══════════════════════════════════════
ACTION REQUIRED
═══════════════════════════════════════
Please review and approve in admin panel:
http://localhost:8000/admin/users/panditprofile/{pandit_profile.id}/change/

User ID: {user.id}
Registration Source: {data.get('registration_source', 'Landing Page')}
                """
            
            send_mail(
                subject=f'🙏 New Pandit Registration: {data["name"]} ({data["specialization"]})',
                message=admin_message,
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[settings.ADMIN_EMAIL],
                fail_silently=True,
            )
        except Exception as e:
            logger.error(f"Failed to send notification email: {str(e)}")
        
        # Send confirmation email to pandit
        try:
            pandit_message = f"""
Namaste {data['name']},

Your PanditTalk registration has been received successfully.
Our verification team will review your profile shortly and get back to you once it is approved.

You can reply to this email or WhatsApp us on +91 98765 43210 if you have any questions.

Registration ID: {user.id}
Phone: {data['phone']}

Thank you for joining PanditTalk!
PanditTalk Support
                """
            
            send_mail(
                subject='🙏 Welcome to PanditTalk - Registration Received',
                message=pandit_message,
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[data['email']],
                fail_silently=True,
            )
        except Exception as e:
            logger.error(f"Failed to send confirmation email: {str(e)}")
        
        return Response({
            'success': True,
            'message': 'Registration successful! We will contact you within 24 hours.',
            'registration_id': user.id,
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        logger.error(f"Error in pandit registration: {str(e)}")
        return Response(
            {'error': 'Registration failed. Please try again later.'}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


# Pandit Registration & Onboarding Flow - Implementation Plan

## Completed ✅

1. **Simplified Registration Screen** - Only asks for personal information:
   - Name, Phone, Email, DOB, Gender, State, Address
   - Redirects to Login screen after registration
   
2. **Backend Login Changes** - Removed verification check from verify_otp to allow unverified pandits to login

## Still Needed 🔄

### Backend Changes:

1. **Update `register_pandit` endpoint** (`backend/users/pandit_registration_views.py`):
   - Change required fields to only: name, phone, email, dob, gender, state, address
   - Create user with is_pandit=True, is_active=True (allow login)
   - Create minimal PanditProfile (no professional details yet)
   - Store personal info in user model
   - Return success response

2. **Create onboarding endpoint** (`backend/users/pandit_views.py` or new file):
   - Endpoint: POST `/api/pandit/onboarding/`
   - Accept: professional details, bank details, availability, ID proof, photo, etc.
   - Update PanditProfile with all this information
   - Mark profile as "onboarding_completed" (add field or use flag)
   - Return success

3. **Add profile status tracking**:
   - Option 1: Add `onboarding_completed` field to PanditProfile model (migration needed)
   - Option 2: Use existing fields (e.g., check if specializations is empty)
   - Option 3: Add a JSON field to track completion status

### Frontend Changes:

4. **Update Dashboard** (`pandit_app/lib/screens/dashboard/dashboard_screen.dart`):
   - Check if user is verified and onboarding completed
   - If NOT onboarding completed: Show 2 tabs (Onboarding, Profile)
   - If onboarding completed but NOT verified: Show 4 tabs with verification pending message
   - If verified: Show all 4 tabs normally

5. **Create Onboarding Screen** (`pandit_app/lib/screens/onboarding/onboarding_screen.dart`):
   - Form with remaining fields:
     - Professional Details (specialization, experience, languages, bio)
     - Availability (working days, hours, weekly hours)
     - Bank Details (account name, number, IFSC, bank name, PAN)
     - Identity Verification (ID proof upload, photo upload)
     - Technical Setup (technical access, how heard)
   - Submit button that calls onboarding endpoint
   - Show success message and refresh dashboard

6. **Update Profile Screen** (`pandit_app/lib/screens/profile/profile_screen.dart`):
   - Display personal information from user model
   - Show registration info (name, phone, email, DOB, gender, state, address)
   - Show verification status

7. **Update API Service** (`pandit_app/lib/services/api_service.dart`):
   - Add `completeOnboarding()` method
   - Add endpoint constant for onboarding

## Flow Summary:

1. User registers (personal info only) → Redirected to Login
2. User logs in → Dashboard shows 2 tabs (Onboarding, Profile)
3. User completes onboarding → Dashboard shows 4 tabs but verification pending
4. Admin verifies → User has full access

## Next Steps:

1. Update backend registration endpoint (highest priority)
2. Create onboarding endpoint
3. Update dashboard logic
4. Create onboarding screen
5. Update profile screen
6. Test the complete flow


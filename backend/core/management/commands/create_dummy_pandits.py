from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from core.models import PanditProfile
import random

User = get_user_model()

class Command(BaseCommand):
    help = 'Create dummy pandits for testing'

    def handle(self, *args, **kwargs):
        dummy_pandits = [
            {
                'username': 'arvinisha',
                'email': 'arvinisha@pandittalk.com',
                'password': 'pandit123',
                'first_name': 'Arvinisha',
                'expertise': 'Tarot, Life Coach',
                'languages': ['English', 'Hindi'],
                'experience_years': 3,
                'fee_per_minute': 25.00,
                'rating': 4.8,
                'is_online': True,
                'is_celebrity': False,
            },
            {
                'username': 'shritha',
                'email': 'shritha@pandittalk.com',
                'password': 'pandit123',
                'first_name': 'Shritha',
                'expertise': 'Vedic, Numerology, Vastu',
                'languages': ['English', 'Hindi'],
                'experience_years': 6,
                'fee_per_minute': 23.00,
                'rating': 4.9,
                'is_online': True,
                'is_celebrity': False,
            },
            {
                'username': 'marisha',
                'email': 'marisha@pandittalk.com',
                'password': 'pandit123',
                'first_name': 'Marisha',
                'expertise': 'Vedic, KP, Face Reading',
                'languages': ['English', 'Hindi'],
                'experience_years': 2,
                'fee_per_minute': 27.00,
                'rating': 4.7,
                'is_online': True,
                'is_celebrity': False,
            },
            {
                'username': 'pt_ramesh',
                'email': 'ramesh@pandittalk.com',
                'password': 'pandit123',
                'first_name': 'Pandit Ramesh',
                'expertise': 'Vedic, Kundali, Marriage Matching',
                'languages': ['English', 'Hindi', 'Sanskrit'],
                'experience_years': 15,
                'fee_per_minute': 45.00,
                'rating': 4.9,
                'is_online': True,
                'is_celebrity': True,
            },
            {
                'username': 'pt_sharma',
                'email': 'sharma@pandittalk.com',
                'password': 'pandit123',
                'first_name': 'Pandit Sharma',
                'expertise': 'Horoscope, Gemstone, Vastu',
                'languages': ['English', 'Hindi'],
                'experience_years': 10,
                'fee_per_minute': 35.00,
                'rating': 4.8,
                'is_online': False,
                'is_celebrity': True,
            },
            {
                'username': 'kavita_joshi',
                'email': 'kavita@pandittalk.com',
                'password': 'pandit123',
                'first_name': 'Kavita Joshi',
                'expertise': 'Tarot, Palmistry, Love Life',
                'languages': ['English', 'Hindi'],
                'experience_years': 8,
                'fee_per_minute': 30.00,
                'rating': 4.9,
                'is_online': True,
                'is_celebrity': True,
            },
        ]

        created_count = 0
        for pandit_data in dummy_pandits:
            username = pandit_data['username']
            email = pandit_data['email']
            password = pandit_data['password']
            first_name = pandit_data['first_name']
            
            # Create or get user
            user, user_created = User.objects.get_or_create(
                username=username,
                defaults={
                    'email': email,
                    'first_name': first_name,
                    'is_pandit': True,
                }
            )
            
            if user_created:
                user.set_password(password)
                user.save()
            
            # Create or update pandit profile
            profile, profile_created = PanditProfile.objects.update_or_create(
                user=user,
                defaults={
                    'expertise': pandit_data['expertise'],
                    'languages': pandit_data['languages'],
                    'experience_years': pandit_data['experience_years'],
                    'fee_per_minute': pandit_data['fee_per_minute'],
                    'rating': pandit_data['rating'],
                    'is_online': pandit_data['is_online'],
                }
            )
            
            if user_created or profile_created:
                self.stdout.write(
                    self.style.SUCCESS(f'✓ Created pandit: {first_name} ({username})')
                )
                created_count += 1
            else:
                self.stdout.write(
                    self.style.WARNING(f'⊘ Pandit already exists: {first_name}')
                )

        self.stdout.write(
            self.style.SUCCESS(f'\n✓ Created/Updated {created_count} pandit(s)')
        )
        self.stdout.write('\n📝 Dummy Pandits:')
        for p in dummy_pandits:
            status = '🟢 LIVE' if p['is_online'] else '⚫ Offline'
            celebrity = '⭐ Celebrity' if p.get('is_celebrity') else ''
            self.stdout.write(f"   {p['first_name']} - {p['expertise']} - ₹{p['fee_per_minute']}/min {status} {celebrity}")


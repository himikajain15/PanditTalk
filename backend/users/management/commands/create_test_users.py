from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model

User = get_user_model()

class Command(BaseCommand):
    help = 'Create test users for development'

    def handle(self, *args, **kwargs):
        test_users = [
            {
                'username': 'test',
                'email': 'test@test.com',
                'password': 'test123',
                'phone': '+919876543210',
                'first_name': 'Test',
                'last_name': 'User'
            },
            {
                'username': 'user',
                'email': 'user@test.com',
                'password': 'user123',
                'phone': '+919876543211',
                'first_name': 'Demo',
                'last_name': 'User'
            },
            {
                'username': 'demo',
                'email': 'demo@test.com',
                'password': 'demo123',
                'phone': '+919876543212',
                'first_name': 'Demo',
                'last_name': 'Account'
            },
        ]

        created_count = 0
        for user_data in test_users:
            username = user_data.pop('username')
            password = user_data.pop('password')
            
            if not User.objects.filter(username=username).exists():
                User.objects.create_user(username, password=password, **user_data)
                self.stdout.write(
                    self.style.SUCCESS(f'✓ Created user: {username} (password: {password})')
                )
                created_count += 1
            else:
                self.stdout.write(
                    self.style.WARNING(f'⊘ User already exists: {username}')
                )

        if created_count > 0:
            self.stdout.write(
                self.style.SUCCESS(f'\n✓ Created {created_count} test user(s)')
            )
        else:
            self.stdout.write(
                self.style.SUCCESS('\n✓ All test users already exist')
            )

        self.stdout.write('\n📝 Test Credentials:')
        self.stdout.write('   Username: test  | Password: test123')
        self.stdout.write('   Username: user  | Password: user123')
        self.stdout.write('   Username: demo  | Password: demo123')


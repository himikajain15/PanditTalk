# PostgreSQL Setup for Production

## Why PostgreSQL?
- ✅ Better for production & scaling
- ✅ Handles concurrent users
- ✅ Better performance for large data
- ✅ Industry standard for web apps

## Current Setup
- **Development**: SQLite (for easy testing)
- **Production**: PostgreSQL (when deployed)

## Option 1: Install PostgreSQL Locally (Windows)

### Download & Install:
1. Go to: https://www.postgresql.org/download/windows/
2. Download PostgreSQL 15 or 16 (recommended)
3. Run installer
4. Set password for `postgres` user (remember this!)
5. Default port: 5432

### After Installation:
```cmd
cd C:\PanditTalk\backend
venv\Scripts\activate

# Install psycopg2-binary (works with Python 3.12 and below)
pip install psycopg2-binary==2.9.9

# Or use Python 3.11/3.12 instead of 3.13
```

### Create Database:
```cmd
# Open pgAdmin (installed with PostgreSQL)
# Or use psql command:
psql -U postgres
CREATE DATABASE pandittalk;
\q
```

### Update .env file:
Create `C:\PanditTalk\backend\.env`:
```env
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/pandittalk
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

### Run Migrations:
```cmd
cd C:\PanditTalk\backend
venv\Scripts\activate
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

---

## Option 2: Use PostgreSQL with Python 3.12 (Recommended)

Since psycopg2 doesn't work with Python 3.13 yet:

### Install Python 3.12:
1. Download: https://www.python.org/downloads/release/python-3120/
2. Install Python 3.12 (alongside 3.13)
3. Check installation: `py -3.12 --version`

### Create New Virtual Environment:
```cmd
cd C:\PanditTalk\backend
py -3.12 -m venv venv_pg
venv_pg\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

---

## Option 3: Use Cloud PostgreSQL (Easiest for Production)

### Free Options:
1. **Neon.tech** (Free tier): https://neon.tech
2. **Supabase** (Free tier): https://supabase.com
3. **ElephantSQL** (Free 20MB): https://www.elephantsql.com
4. **Railway** (Free $5/month credit): https://railway.app

### Example with Neon.tech:
1. Sign up at https://neon.tech
2. Create new project
3. Copy connection string
4. Add to `.env`:
```env
DATABASE_URL=postgresql://user:password@ep-xxx.neon.tech/pandittalk
```

---

## Option 4: MySQL Instead (Alternative)

If you prefer MySQL:

### Install MySQL:
1. Download: https://dev.mysql.com/downloads/mysql/
2. Install MySQL 8.0
3. Set root password

### Install MySQL Driver:
```cmd
cd C:\PanditTalk\backend
venv\Scripts\activate
pip install mysqlclient
```

### Update settings.py:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'pandittalk',
        'USER': 'root',
        'PASSWORD': 'your_password',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

---

## Recommended Production Stack:

```
Development (Local):
   SQLite (quick testing) ✅
   
Staging (Testing):
   PostgreSQL (Cloud - Neon/Supabase) ✅
   
Production (Live):
   PostgreSQL (Cloud - AWS RDS/Heroku/Railway) ✅
```

---

## Current Configuration:

Your `settings.py` already supports both!

```python
# Automatically uses SQLite for dev, PostgreSQL for production
DATABASE_URL = os.getenv('DATABASE_URL', f"sqlite:///{BASE_DIR / 'db.sqlite3'}")
DATABASES = {'default': dj_database_url.parse(DATABASE_URL)}
```

To switch:
1. Set `DATABASE_URL` environment variable
2. Or add `.env` file with PostgreSQL connection
3. Run migrations
4. Done!

---

## Quick Start (For Now):

**For Development (Current Setup):**
- Keep using SQLite ✅
- Fast, easy, no setup needed
- Perfect for testing all features

**For Production (When Deploying):**
- Switch to PostgreSQL ✅
- Use cloud provider (Neon, Supabase, etc.)
- Update DATABASE_URL environment variable
- Run migrations
- Deploy!

---

## Google Sheets Integration (Pandits)

The backend already has Google Sheets integration:
- File: `backend/core/google_sheets_service.py`
- Endpoint: `/api/core/pandits/sync-sheets/`
- Setup guide: `backend/GOOGLE_SHEETS_SETUP.md`

Just need to:
1. Create Google Cloud project
2. Enable Sheets API
3. Add service account credentials
4. Share your sheet with service account email
5. Call sync endpoint

---

## Summary:

✅ **SQLite**: Use for now (development/testing)
✅ **PostgreSQL**: Use for production (better performance)
✅ **Switch anytime**: Just update DATABASE_URL
✅ **Google Sheets**: Already integrated, just needs credentials

Want me to help set up PostgreSQL now?


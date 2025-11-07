# Google Sheets Integration Setup Guide

## Your Sheet Details
- **Sheet ID**: `1L06nvUh8LT6yvDqrX1HGN6-a62KzrRBKzHoal-LdZqY`
- **Sheet URL**: https://docs.google.com/spreadsheets/d/1L06nvUh8LT6yvDqrX1HGN6-a62KzrRBKzHoal-LdZqY/edit

## Setup Instructions

### Step 1: Create Google Cloud Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the **Google Sheets API**:
   - Go to "APIs & Services" > "Library"
   - Search for "Google Sheets API"
   - Click "Enable"

4. Create a Service Account:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "Service Account"
   - Give it a name (e.g., "pandittalk-sheets-reader")
   - Click "Create and Continue"
   - Skip role assignment (click "Continue")
   - Click "Done"

5. Create a Key:
   - Click on the service account you just created
   - Go to "Keys" tab
   - Click "Add Key" > "Create new key"
   - Choose "JSON" format
   - Download the JSON file

### Step 2: Share Google Sheet with Service Account

1. Open your Google Sheet: https://docs.google.com/spreadsheets/d/1L06nvUh8LT6yvDqrX1HGN6-a62KzrRBKzHoal-LdZqY/edit
2. Click "Share" button
3. Get the email from the JSON file you downloaded (look for `client_email` field)
4. Share the sheet with that email address (give it "Viewer" access is enough)

### Step 3: Configure Backend

You have two options:

#### Option A: Environment Variables (Recommended for Production)

Create a `.env` file in the `backend/` directory:

```env
GOOGLE_SHEET_ID=1L06nvUh8LT6yvDqrX1HGN6-a62KzrRBKzHoal-LdZqY
GOOGLE_WORKSHEET_NAME=Sheet1
GOOGLE_CREDENTIALS_JSON=/path/to/your/service-account-key.json
```

Or if you want to paste the JSON directly:

```env
GOOGLE_SHEET_ID=1L06nvUh8LT6yvDqrX1HGN6-a62KzrRBKzHoal-LdZqY
GOOGLE_WORKSHEET_NAME=Sheet1
GOOGLE_CREDENTIALS_JSON={"type":"service_account","project_id":"your-project",...}
```

#### Option B: Hardcode (Quick Test)

The sheet ID is already set in the code as default. You just need to set `GOOGLE_CREDENTIALS_JSON`.

### Step 4: Expected Column Structure

The service will automatically match these column names (case-insensitive):
- **Name** / Full Name / Pandit Name
- **Phone** / Phone Number / Mobile / Contact
- **Email** / E-mail / Email Address
- **Languages** / Language / Known Languages
- **Expertise** / Specialization / Skills / Services
- **Experience Years** / Experience / Years of Experience / YOE
- **Fee Per Minute** / Fee/Min / Rate / Price Per Minute
- **Rating** / Star Rating / Stars
- **Is Online** / Online / Status

### Step 5: Install Dependencies

```bash
cd backend
pip install gspread google-auth
```

Or if using requirements.txt:
```bash
pip install -r requirements.txt
```

### Step 6: Test the Integration

1. Start your Django server:
```bash
python manage.py runserver
```

2. Test the sync endpoint:
```bash
# View data from sheet (GET)
curl http://localhost:8000/api/core/pandits/sync-sheets/

# Sync to database (POST)
curl -X POST http://localhost:8000/api/core/pandits/sync-sheets/
```

Or use the Flutter app - click the sync button (🔄) in the Pandits list screen.

## Troubleshooting

- **"Google Sheets integration not configured"**: Make sure `GOOGLE_CREDENTIALS_JSON` is set
- **"Permission denied"**: Make sure you shared the sheet with the service account email
- **"Worksheet not found"**: Check if `GOOGLE_WORKSHEET_NAME` matches your sheet tab name
- **Empty results**: Check if your sheet has the expected column headers in the first row


# Google Gemini API Setup Guide

## Step 1: Get Your Gemini API Key

1. Go to **Google AI Studio**: https://aistudio.google.com/app/apikey
2. Sign in with your Google account
3. Click **"Create API Key"**
4. Copy your API key (starts with `AIza...`)

## Step 2: Add API Key to Backend

Add the API key to your `backend/.env` file:

```bash
GEMINI_API_KEY=your-api-key-here
```

**Important**: Replace `your-api-key-here` with your actual API key from Step 1.

## Step 3: Restart Django Server

After adding the API key, restart your Django server:

```bash
cd backend
.\venv\Scripts\Activate.ps1
python manage.py runserver 0.0.0.0:8000
```

## Step 4: Test the Palmistry Feature

1. Open your Flutter app
2. Navigate to **Palmistry** in Quick Actions
3. Upload left and/or right hand photos
4. Click **"Analyze Palms"**
5. Wait for the analysis (usually 10-30 seconds)

## Pricing

**Google Gemini API** offers a **FREE tier**:
- **Free tier**: 15 requests per minute (RPM)
- **Free tier**: 1,500 requests per day (RPD)
- **Paid tier**: Starts at $0.00025 per 1K characters (very affordable)

For palmistry analysis:
- **Cost per analysis**: ~₹0.01-0.05 (almost free!)
- **Free tier**: ~1,500 analyses per day FREE

## Troubleshooting

### Error: "Gemini API key not configured"
- Make sure you added `GEMINI_API_KEY` to `backend/.env`
- Restart Django server after adding the key

### Error: "Invalid API key"
- Verify your API key is correct
- Make sure there are no extra spaces in `.env` file
- Check: https://aistudio.google.com/app/apikey

### Error: "Quota exceeded"
- You've hit the free tier limit (1,500/day)
- Wait 24 hours or upgrade to paid tier
- Check usage: https://aistudio.google.com/app/apikey

## Benefits of Gemini vs OpenAI

✅ **Free tier available** (1,500 requests/day)  
✅ **Much cheaper** (~₹0.01 vs ₹0.80 per analysis)  
✅ **Fast response times**  
✅ **Good quality palmistry analysis**  
✅ **No credit card required** for free tier


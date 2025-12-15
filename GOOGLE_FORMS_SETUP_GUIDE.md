# Google Forms Setup Guide - Pandit Onboarding Test

## Overview
This guide will help you create a professional MCQ test on Google Forms with auto-grading and result tracking.

## Test Specifications
- **Total Questions**: 20
- **Passing Score**: 17/20 (85%)  
- **Duration**: 25 minutes (recommended)
- **Format**: Multiple Choice (single correct answer)

---

## Step-by-Step Setup

### Step 1: Create New Form
1. Go to [Google Forms](https://forms.google.com)
2. Click **"+ Blank"** to create a new form
3. Click "Untitled form" and rename to: **"PanditTalk - Pandit Onboarding Professional Assessment"**

### Step 2: Enable Quiz Mode
1. Click the **Settings** icon (⚙️) at the top
2. Go to **"Quizzes"** tab
3. Toggle **"Make this a quiz"** to ON
4. Configure quiz settings:
   - ✅ Release grade: **Immediately after each submission**
   - ✅ Respondent can see: **Missed questions, Correct answers**
   - ❌ Uncheck "Point values"  (we'll manually set)

### Step 3: Add Questions
Copy all 20 questions from the test file (`PANDIT_ONBOARDING_TEST.txt`) into the form.

**For Each Question:**
1. Click **"+ Add Question"** (or click the floating + button)
2. Select **"Multiple choice"** as question type
3. Paste the question text
4. Add all 4 options (A, B, C, D)
5. Click **"Answer key"** at the bottom
6. Select the correct answer
7. Set points to **5** (so total = 100 points)
8. Toggle **"Required"** to ON

**Important Settings Per Question:**
- **Points**: 5 points each (20 × 5 = 100 total)
- **Required**: Yes (all questions mandatory)
- **Shuffle option order**: Yes (recommended to prevent pattern answers)

### Step 4: Add Candidate Information Section
At the **top of the form** (before questions), add these fields:

1. **Full Name** (Short answer, Required)
2. **Email Address** (Email, Required)  
3. **Phone Number** (Short answer, Required)
4. **State/Region** (Dropdown, Required) - Add all states
5. **Years of Experience in Astrology** (Short answer, Required)
6. **Specialization** (Checkboxes) - Vedic, Numerology, Tarot, Palmistry, etc.

### Step 5: Configure Form Settings
Click **Settings** (⚙️) → **General** tab:

**Collect email addresses:**
- ✅ Check "Collect email addresses"
- ✅ Check "Verified" (Requires Google sign-in)
- ✅ Check "Restrict to 1 response" (Prevents multiple attempts)

**Respondent options:**
- ❌ Uncheck "Edit after submit" (No changes allowed)
- ❌ Uncheck "See summary charts" (Keep results private)

### Step 6: Set Up Passing Criteria
1. After all questions are added, click **"Responses"** tab
2. Click the **Google Sheets** icon to create a linked spreadsheet
3. In the spreadsheet, add a formula column to calculate pass/fail:

```
=IF(B2>=85, "PASS", "FAIL")
```
(Assuming column B has the score)

### Step 7: Customize Thank You Message
1. Click **Settings** → **Presentation** tab
2. Edit **"Confirmation message"**:

**For Passing (manual - check scores):**
```
Thank you for completing the PanditTalk Pandit Onboarding Assessment!

Your Score: [Will be emailed]
Status: [Will be notified]

If you scored 85% or above, our team will contact you within 2-3 business days for the next onboarding steps.

For queries, email: support@pandittalk.com
```

3. **Show link to submit another response**: OFF

### Step 8: Design & Branding
1. Click **Customize theme** (🎨 palette icon)
2. **Header**: Upload PanditTalk logo
3. **Theme color**: Choose brand color
4. **Background color**: Professional (white/light)  
5. **Font style**: Professional (e.g., Basic, Formal)

### Step 9: Set Time Limit (Optional via Add-on)
1. Click the **3 dots** (⋮) → **"Add-ons"**
2. Install **"formLimiter"** or **"Timify"**
3. Set test to close after 25 minutes per response

### Step 10: Email Notifications
**For Admin:**
1. In linked Google Sheet, click **Tools** → **Notification rules**
2. Select: "Notify me when... A user submits a form"
3. Frequency: "Notify me right away"

**For Candidates** (via Add-on):
1. Install **"Email Notifications for Google Forms"** add-on
2. Set up auto-email with score

---

## Advanced Features

### Auto-Grading Email Template
Use **"Email Notifications for Forms"** add-on:

**Subject**: PanditTalk Assessment Result - {{Full Name}}

**Body**:
```
Dear {{Full Name}},

Thank you for taking the PanditTalk Pandit Onboarding Assessment.

Your Score: {{Score}}/100 ({{Percentage}}%)
Status: {{IF(Score >= 85, "PASS ✓", "FAIL ✗")}}

{{IF(Score >= 85, 
"Congratulations! You have successfully passed. Our team will contact you within 2-3 business days.",
"Unfortunately, you did not meet the passing criteria (85%). You may retake the test after 30 days.")}}

Best regards,
PanditTalk Onboarding Team
```

### Data Analysis
In Google Sheets (Response sheet):
- **Pass Rate**: `=COUNTIF(C:C,">=85")/COUNTA(C:C)`
- **Average Score**: `=AVERAGE(C:C)`
- **Question Analysis**: See which questions most failed

---

## Testing Before Launch
1. Click **Preview** (👁️ icon) to test
2. Submit a test response with known answers
3. Verify:
   - ✅ Correct answers marked properly
   - ✅ Score calculation accurate
   - ✅ Pass/fail threshold at 85%
   - ✅ Email notifications working
   - ✅ Data flowing to spreadsheet

---

## Share the Test
1. Click **Send** button
2. Get the link:
   - Check **"Shorten URL"**
   - Copy the link
3. Share via:
   - Pandit app registration flow
   - Email to candidates
   - SMS notifications

**Example Short URL Format:**
```
https://forms.gle/abc123xyz
```

---

## Security Recommendations
1. ✅ Require Google sign-in (prevents spam)
2. ✅ Limit to 1 response per user
3. ✅ Don't show correct answers immediately (consider hiding until after review)
4. ✅ Regularly check for suspicious patterns (same answers, timing)
5. ✅ Time limit to prevent cheating

---

## Alternative: Typeform
If you prefer a more premium experience:
1. Go to [Typeform.com](https://typeform.com)
2. Similar setup process
3. Better UI/UX
4. Built-in time limits
5. Advanced analytics
6. Cost: ~$25-$70/month

---

## Questions Bank Files Created
- English: `PANDIT_ONBOARDING_TEST.txt`
- Hindi: `PANDIT_TEST_HINDI.txt`
- Marathi: `PANDIT_TEST_MARATHI.txt`
- Telugu: `PANDIT_TEST_TELUGU.txt`
- Gujarati: `PANDIT_TEST_GUJARATI.txt`
- Kannada: `PANDIT_TEST_KANNADA.txt`

**Create one form per language for best candidate experience!**

---

## Support
For technical issues with Google Forms:
- [Google Forms Help Center](https://support.google.com/docs/answer/6281888)
- [Form Add-ons](https://workspace.google.com/marketplace/category/works-with-forms)

---

**Good luck with your Pandit onboarding! 🎯**

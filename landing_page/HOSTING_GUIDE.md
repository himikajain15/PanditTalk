# Landing Page - Separate Hosting Guide

## Your Landing Page Location
```
C:\PanditTalk\landing_page\
├── index.html      ← Main page (upload this)
├── styles.css      ← Styling (upload this)
├── script.js       ← JavaScript (upload this)
└── README.md       ← Documentation
```

---

## How to Host Landing Page Separately

### Method 1: GitHub Pages (FREE & Easy) ✅

**Step 1: Create GitHub Repository**
```bash
cd C:\PanditTalk\landing_page
git init
git add index.html styles.css script.js
git commit -m "Landing page"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/pandittalk-landing.git
git push -u origin main
```

**Step 2: Enable GitHub Pages**
1. Go to your GitHub repository
2. Settings → Pages
3. Source: `main` branch
4. Save

**Your site will be live at:**
```
https://YOUR_USERNAME.github.io/pandittalk-landing/
```

---

### Method 2: Netlify (FREE - Recommended!) ✅

**Super Easy - Drag & Drop:**

1. Go to: https://app.netlify.com/drop
2. Drag the `landing_page` folder
3. Site is live instantly!
4. Free custom domain support

**OR with CLI:**
```bash
npm install -g netlify-cli
cd C:\PanditTalk\landing_page
netlify deploy --prod
```

**Your site:** `https://random-name.netlify.app`
(Can connect your own domain)

---

### Method 3: Vercel (FREE) ✅

1. Go to: https://vercel.com
2. Sign up (GitHub account)
3. New Project → Import
4. Select `landing_page` folder
5. Deploy

**Your site:** `https://pandittalk.vercel.app`

---

### Method 4: Your Domain with cPanel (Most Common)

**If you already purchased a domain:**

**Step 1: Login to cPanel**
- URL: Usually `yourdomain.com/cpanel`
- Or through your hosting provider

**Step 2: Upload Files**
1. Open **File Manager**
2. Go to `public_html` folder (root directory)
3. Click **Upload**
4. Upload these 3 files:
   - `index.html`
   - `styles.css`
   - `script.js`

**Step 3: Visit Your Domain**
```
https://yourdomain.com
```
Your landing page is live! ✅

---

### Method 5: Cloudflare Pages (FREE) ✅

1. Go to: https://pages.cloudflare.com
2. Sign up
3. Create new project
4. Connect GitHub or upload directly
5. Deploy

**Benefits:**
- Fast CDN
- Free SSL
- Custom domain
- Analytics

---

## Best Option for You:

### For Quick Testing:
```
Netlify Drop (https://app.netlify.com/drop)
└─ Drag & drop folder
└─ Live in 30 seconds!
```

### For Your Purchased Domain:
```
cPanel File Manager
└─ Upload to public_html/
└─ Access at yourdomain.com
```

### For Professional Setup:
```
Cloudflare Pages or Vercel
└─ Git-based deployment
└─ Auto-updates when you push
└─ Free SSL & CDN
```

---

## After Uploading - Important!

### Update These in Your Files:

**1. Launch Date** (`script.js` line 2):
```javascript
const launchDate = new Date('2025-02-15T00:00:00').getTime();
// Change to your actual launch date!
```

**2. Social Media Links** (`index.html`):
```html
<a href="https://facebook.com/yourpage" class="social-link">
<a href="https://twitter.com/yourhandle" class="social-link">
<a href="https://instagram.com/yourprofile" class="social-link">
```

**3. Contact Email** (`index.html` footer):
```html
<a href="mailto:support@yourdomain.com">Contact Us</a>
```

---

## Where to See Landing Page Locally:

**Option A: Run start_all.bat**
```
1. Double-click: C:\PanditTalk\start_all.bat
2. Opens automatically at: http://localhost:8080
```

**Option B: Direct File**
```
1. Go to: C:\PanditTalk\landing_page\
2. Double-click: index.html
3. Opens in your browser
```

**Option C: Python Server (Manual)**
```cmd
cd C:\PanditTalk\landing_page
python -m http.server 8080
```
Then open: http://localhost:8080

---

## Connecting Your Domain:

### If Using Netlify/Vercel:
1. Go to Site Settings
2. Add Custom Domain
3. Update DNS records (they'll guide you)
4. SSL certificate auto-generated

### If Using cPanel:
1. Files already in public_html = works automatically
2. Visit yourdomain.com
3. SSL: In cPanel → SSL/TLS → Install Let's Encrypt (free)

---

## Your Landing Page Shows:

✅ Coming Soon countdown
✅ Email signup form
✅ 6 feature cards
✅ Services list
✅ Social media links
✅ Professional yellow/white/black design
✅ Fully responsive (mobile-friendly)

---

## Quick Deploy NOW:

### Fastest Way (2 minutes):

1. Go to: https://app.netlify.com/drop
2. Open folder: `C:\PanditTalk\landing_page\`
3. Select all 3 files:
   - index.html
   - styles.css
   - script.js
4. Drag into Netlify Drop zone
5. DONE! Site is live! 🎉

You'll get a URL like: `https://wonderful-name-123456.netlify.app`

Later, connect your own domain in Netlify settings.

---

## Landing Page is SEPARATE from Main App:

```
Landing Page (Static HTML):
├─ Just 3 files
├─ Host anywhere
├─ No backend needed
├─ Fast & simple
└─ Your "Coming Soon" website

Main App (Flutter + Django):
├─ Full application
├─ Backend required
├─ Deploy separately later
└─ Mobile app + API
```

You host them separately - perfect! ✅

---

## Summary:

**Where is landing page:**
- Local: `C:\PanditTalk\landing_page\`
- View locally: http://localhost:8080 (via start_all.bat)

**How to host separately:**
- Easiest: Netlify Drop (drag & drop)
- With domain: cPanel upload to public_html
- Professional: Vercel or Cloudflare Pages

**Files to upload:**
- index.html
- styles.css
- script.js

Want me to help you deploy it right now?


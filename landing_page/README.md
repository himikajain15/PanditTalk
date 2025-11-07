# PanditTalk Landing Page

A professional "Coming Soon" landing page for PanditTalk app.

## Features

- ✨ Modern, responsive design with yellow/white/black theme
- ⏱️ Live countdown timer to launch date
- 📧 Email notification signup form
- 🎯 Feature showcase with animations
- 📱 Mobile-friendly responsive layout
- 🔗 Social media links
- 🌟 Smooth animations and transitions

## Structure

```
landing_page/
├── index.html      # Main HTML file
├── styles.css      # Styling and responsive design
├── script.js       # Countdown timer and interactions
└── README.md       # This file
```

## Setup

1. Update the launch date in `script.js`:
   ```javascript
   const launchDate = new Date('2025-02-15T00:00:00').getTime();
   ```

2. Deploy to your domain:
   - Upload all files to your web hosting
   - Ensure files are in the root directory
   - Test on different devices

3. Connect email signup (optional):
   - Update the `notifyMe()` function in `script.js`
   - Integrate with your backend API or email service

## Customization

### Colors
Edit CSS variables in `styles.css`:
```css
:root {
    --primary-yellow: #FFC107;
    --dark-yellow: #FFB300;
    --light-yellow: #FFF9C4;
    --black: #212121;
    --gray: #757575;
}
```

### Social Links
Update social media URLs in `index.html`:
```html
<a href="YOUR_FACEBOOK_URL" class="social-link">...</a>
<a href="YOUR_TWITTER_URL" class="social-link">...</a>
```

### Services & Features
Modify the feature cards and service items in `index.html` to match your offerings.

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers

## Performance

- Optimized for fast loading
- No external dependencies except Google Fonts
- Minimal JavaScript
- Responsive images

## License

© 2025 PanditTalk. All rights reserved.



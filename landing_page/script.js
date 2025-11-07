// Rotating Horoscope Icons (Zodiac & Dharma Chakra)
const icons = [
    // Sudarshan Chakra / Dharma Wheel
    `<svg width="80" height="80" viewBox="0 0 100 100" fill="#FFC107">
        <circle cx="50" cy="50" r="48" fill="none" stroke="#FFC107" stroke-width="2"/>
        <circle cx="50" cy="50" r="12" fill="#FFC107"/>
        ${Array.from({length: 8}, (_, i) => {
            const angle = (i * 45 - 90) * Math.PI / 180;
            const x1 = 50 + 12 * Math.cos(angle);
            const y1 = 50 + 12 * Math.sin(angle);
            const x2 = 50 + 45 * Math.cos(angle);
            const y2 = 50 + 45 * Math.sin(angle);
            return `<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="#FFC107" stroke-width="3"/>`;
        }).join('')}
    </svg>`,
    // Om Symbol
    `<svg width="80" height="80" viewBox="0 0 100 100" fill="#FFC107">
        <text x="50" y="65" font-size="60" text-anchor="middle" font-family="Arial, sans-serif" font-weight="bold">ॐ</text>
    </svg>`,
    // Sun / Surya
    `<svg width="80" height="80" viewBox="0 0 100 100" fill="#FFC107">
        <circle cx="50" cy="50" r="25" fill="#FFC107"/>
        ${Array.from({length: 12}, (_, i) => {
            const angle = (i * 30) * Math.PI / 180;
            const x1 = 50 + 30 * Math.cos(angle);
            const y1 = 50 + 30 * Math.sin(angle);
            const x2 = 50 + 45 * Math.cos(angle);
            const y2 = 50 + 45 * Math.sin(angle);
            return `<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="#FFC107" stroke-width="4" stroke-linecap="round"/>`;
        }).join('')}
    </svg>`,
    // Moon / Chandra
    `<svg width="80" height="80" viewBox="0 0 100 100" fill="#FFC107">
        <path d="M50 10 A40 40 0 1 1 50 90 A35 35 0 0 0 50 10" fill="#FFC107"/>
    </svg>`,
    // Lotus
    `<svg width="80" height="80" viewBox="0 0 100 100" fill="#FFC107">
        <path d="M50 20 Q30 40 20 60 L30 70 L50 65 L70 70 L80 60 Q70 40 50 20 Z" fill="#FFC107"/>
        <circle cx="50" cy="55" r="12" fill="#FFB300"/>
    </svg>`,
    // Trishul
    `<svg width="80" height="80" viewBox="0 0 100 100" fill="#FFC107">
        <rect x="47" y="30" width="6" height="60" fill="#FFC107"/>
        <path d="M35 15 L35 35 L47 35 L47 15 Z" fill="#FFC107"/>
        <path d="M53 15 L53 35 L65 35 L65 15 Z" fill="#FFC107"/>
        <path d="M47 15 L53 15 L53 45 L47 45 Z" fill="#FFC107"/>
    </svg>`,
];

let currentIconIndex = 0;

function rotateIcon() {
    const iconElement = document.getElementById('rotatingIcon');
    if (iconElement) {
        iconElement.innerHTML = icons[currentIconIndex];
        currentIconIndex = (currentIconIndex + 1) % icons.length;
    }
}

// Rotate icon every 2 seconds
setInterval(rotateIcon, 2000);
rotateIcon(); // Initial icon

// Countdown Timer
const launchDate = new Date('2025-02-15T00:00:00').getTime();

function updateCountdown() {
    const now = new Date().getTime();
    const distance = launchDate - now;

    if (distance < 0) {
        document.getElementById('countdown').innerHTML = '<p style="font-size: 24px; font-weight: 600; color: var(--primary-yellow);">We\'re Live! 🎉</p>';
        return;
    }

    const days = Math.floor(distance / (1000 * 60 * 60 * 24));
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((distance % (1000 * 60)) / 1000);

    document.getElementById('days').textContent = String(days).padStart(2, '0');
    document.getElementById('hours').textContent = String(hours).padStart(2, '0');
    document.getElementById('minutes').textContent = String(minutes).padStart(2, '0');
    document.getElementById('seconds').textContent = String(seconds).padStart(2, '0');
}

// Update countdown every second
setInterval(updateCountdown, 1000);
updateCountdown();

// Email Notification
function notifyMe() {
    const emailInput = document.getElementById('email');
    const email = emailInput.value.trim();

    if (!email) {
        alert('Please enter your email address');
        return;
    }

    if (!isValidEmail(email)) {
        alert('Please enter a valid email address');
        return;
    }

    // TODO: Send email to backend
    console.log('Email submitted:', email);
    
    // Show success message
    alert('🎉 Thank you! We\'ll notify you when PanditTalk launches!');
    emailInput.value = '';
}

function isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

// Allow Enter key to submit
document.getElementById('email').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        notifyMe();
    }
});

// Smooth scroll animation for links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Intersection Observer for animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.animation = 'fadeIn 0.8s ease-in forwards';
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe all feature cards and service items
document.querySelectorAll('.feature-card, .service-item').forEach(el => {
    el.style.opacity = '0';
    observer.observe(el);
});

// Modal Functions
function showModal(title, content) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = `<h2>${title}</h2>${content}`;
    modal.style.display = 'block';
}

function closeModal() {
    document.getElementById('modal').style.display = 'none';
}

function showPrivacyPolicy(e) {
    e.preventDefault();
    const content = `
        <p><strong>Effective Date:</strong> January 1, 2025</p>
        
        <h3>1. Information We Collect</h3>
        <p>We collect information you provide directly to us, including:</p>
        <ul>
            <li>Name, email address, and phone number</li>
            <li>Birth details for horoscope readings</li>
            <li>Payment information for consultations</li>
            <li>Communication preferences and chat history</li>
        </ul>
        
        <h3>2. How We Use Your Information</h3>
        <ul>
            <li>To provide astrology consultations and services</li>
            <li>To process payments and manage your account</li>
            <li>To send you updates, horoscopes, and notifications</li>
            <li>To improve our services and user experience</li>
        </ul>
        
        <h3>3. Data Security</h3>
        <p>We implement industry-standard security measures to protect your personal information. Your data is encrypted and stored securely.</p>
        
        <h3>4. Data Sharing</h3>
        <p>We do not sell or share your personal information with third parties except as necessary to provide our services (payment processors, etc.).</p>
        
        <h3>5. Your Rights</h3>
        <p>You have the right to access, update, or delete your personal information at any time through your account settings.</p>
        
        <h3>6. Contact Us</h3>
        <p>For privacy concerns, contact us at: <a href="mailto:privacy@pandittalk.com">privacy@pandittalk.com</a></p>
    `;
    showModal('Privacy Policy', content);
}

function showTerms(e) {
    e.preventDefault();
    const content = `
        <p><strong>Last Updated:</strong> January 1, 2025</p>
        
        <h3>1. Acceptance of Terms</h3>
        <p>By accessing and using PanditTalk, you accept and agree to be bound by these Terms of Service.</p>
        
        <h3>2. Service Description</h3>
        <p>PanditTalk connects users with verified astrologers and pandits for consultations, horoscope readings, and spiritual guidance.</p>
        
        <h3>3. User Responsibilities</h3>
        <ul>
            <li>Provide accurate information when registering</li>
            <li>Maintain the confidentiality of your account</li>
            <li>Use the service in accordance with applicable laws</li>
            <li>Treat astrologers and other users with respect</li>
        </ul>
        
        <h3>4. Consultations</h3>
        <ul>
            <li>All consultations are for guidance purposes only</li>
            <li>Results are not guaranteed</li>
            <li>Consult professionals for medical, legal, or financial decisions</li>
        </ul>
        
        <h3>5. Payments</h3>
        <ul>
            <li>Payment is required before consultations</li>
            <li>Cancellation policy: 24 hours notice for full refund</li>
            <li>Wallet credits are non-refundable unless required by law</li>
        </ul>
        
        <h3>6. Intellectual Property</h3>
        <p>All content on PanditTalk is protected by copyright. You may not reproduce or distribute without permission.</p>
        
        <h3>7. Limitation of Liability</h3>
        <p>PanditTalk is not liable for any decisions made based on consultations or for any indirect damages.</p>
        
        <h3>8. Contact</h3>
        <p>Questions? Email us at: <a href="mailto:legal@pandittalk.com">legal@pandittalk.com</a></p>
    `;
    showModal('Terms of Service', content);
}

function showContact(e) {
    e.preventDefault();
    const content = `
        <h3>Get In Touch</h3>
        <p>We'd love to hear from you! Reach out to us through any of the following channels:</p>
        
        <h3>📧 Email</h3>
        <p><a href="mailto:support@pandittalk.com">support@pandittalk.com</a></p>
        <p><a href="mailto:info@pandittalk.com">info@pandittalk.com</a></p>
        
        <h3>📱 Phone / WhatsApp</h3>
        <p><a href="tel:+919876543210">+91 98765 43210</a></p>
        <p><a href="https://wa.me/919876543210">Chat on WhatsApp</a></p>
        
        <h3>🏢 Office Address</h3>
        <p>PanditTalk Headquarters<br>
        123 Spiritual Street<br>
        New Delhi, India - 110001</p>
        
        <h3>⏰ Business Hours</h3>
        <p>Monday - Sunday: 9:00 AM - 9:00 PM IST<br>
        24/7 Online Support Available</p>
        
        <h3>🌐 Social Media</h3>
        <p>
            <a href="https://facebook.com/pandittalk" target="_blank">Facebook</a> | 
            <a href="https://twitter.com/pandittalk" target="_blank">Twitter</a> | 
            <a href="https://instagram.com/pandittalk" target="_blank">Instagram</a>
        </p>
        
        <p style="margin-top: 20px; padding: 15px; background: #FFF9C4; border-radius: 8px;">
            <strong>For urgent matters:</strong> WhatsApp us at +91 98765 43210
        </p>
    `;
    showModal('Contact Us', content);
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('modal');
    if (event.target == modal) {
        closeModal();
    }
}



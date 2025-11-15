// ===========================
// BACKGROUND MUSIC (AUTO-PLAY)
// ===========================

window.addEventListener('load', function() {
    const bgMusic = document.getElementById('bgMusic');
    
    if (!bgMusic) return;
    
    // Set to 15% volume (very subtle background ambiance)
    bgMusic.volume = 0.15;
    
    function playMusic() {
        bgMusic.play().catch(e => {
            // Silently catch autoplay errors
        });
    }
    
    // Aggressive auto-play attempts
    playMusic();
    setTimeout(playMusic, 100);
    setTimeout(playMusic, 300);
    setTimeout(playMusic, 500);
    setTimeout(playMusic, 1000);
    setTimeout(playMusic, 2000);
    
    // Play on ANY interaction
    let started = false;
    function tryPlay() {
        if (!started) {
            playMusic();
            started = true;
        }
    }
    
    document.addEventListener('click', tryPlay);
    document.addEventListener('scroll', tryPlay);
    document.addEventListener('mousemove', tryPlay, { once: true });
    document.addEventListener('touchstart', tryPlay);
    document.addEventListener('keydown', tryPlay);
    
    // Play when page becomes visible
    document.addEventListener('visibilitychange', function() {
        if (!document.hidden) {
            playMusic();
        }
    });
});

// ===========================
// ROTATING ICONS
// ===========================
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
const countdownWrapper = document.getElementById('countdown');
const daysEl = document.getElementById('days');
const hoursEl = document.getElementById('hours');
const minutesEl = document.getElementById('minutes');
const secondsEl = document.getElementById('seconds');

if (countdownWrapper && daysEl && hoursEl && minutesEl && secondsEl) {
    const launchDate = new Date('2025-02-15T00:00:00').getTime();

    function updateCountdown() {
        const now = new Date().getTime();
        const distance = launchDate - now;

        if (distance < 0) {
            countdownWrapper.innerHTML = '<p style="font-size: 24px; font-weight: 600; color: var(--primary-yellow);">We\'re Live! 🎉</p>';
            return;
        }

        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        daysEl.textContent = String(days).padStart(2, '0');
        hoursEl.textContent = String(hours).padStart(2, '0');
        minutesEl.textContent = String(minutes).padStart(2, '0');
        secondsEl.textContent = String(seconds).padStart(2, '0');
    }

    setInterval(updateCountdown, 1000);
    updateCountdown();
}

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
const notifyEmailInput = document.getElementById('email');
if (notifyEmailInput) {
    notifyEmailInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            notifyMe();
        }
    });
}

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
    const panditModal = document.getElementById('panditModal');
    
    if (event.target == modal) {
        closeModal();
    }
    if (event.target == panditModal) {
        closePanditModal();
    }
}

// ===========================
// PANDIT REGISTRATION
// ===========================

function openPanditRegistration() {
    window.location.href = 'pandit_registration.html';
}

function closePanditModal() {
    const panditModal = document.getElementById('panditModal');
    if (panditModal) {
        panditModal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
    const form = document.getElementById('panditRegistrationForm');
    if (form) {
        form.reset();
    }
    hideFormMessage();
}

function showFormMessage(message, type) {
    const messageDiv = document.getElementById('formMessage');
    if (!messageDiv) return;
    messageDiv.textContent = message;
    messageDiv.className = `form-message ${type}`;
}

function hideFormMessage() {
    const messageDiv = document.getElementById('formMessage');
    if (!messageDiv) return;
    messageDiv.className = 'form-message';
    messageDiv.textContent = '';
}

async function submitPanditRegistration(event) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new FormData(form);
    
    // Get all checkbox values
    const availability = Array.from(form.querySelectorAll('input[name="availability"]:checked'))
        .map(cb => cb.value);
    const workingDays = Array.from(form.querySelectorAll('input[name="working_days"]:checked'))
        .map(cb => cb.value);
    const technicalAccess = Array.from(form.querySelectorAll('input[name="technical_access"]:checked'))
        .map(cb => cb.value);
    
    // Get file uploads
    const idProofFile = document.getElementById('panditIdProof').files[0];
    const photoFile = document.getElementById('panditPhoto').files[0];
    
    // Validation
    if (availability.length === 0) {
        showFormMessage('Please select at least one availability slot', 'error');
        return;
    }
    
    if (workingDays.length === 0) {
        showFormMessage('Please select at least one working day', 'error');
        return;
    }
    
    if (technicalAccess.length === 0) {
        showFormMessage('Please confirm your technical access requirements', 'error');
        return;
    }
    
    // Validate file uploads
    if (!idProofFile) {
        showFormMessage('Please upload your Government ID proof', 'error');
        return;
    }
    
    if (!photoFile) {
        showFormMessage('Please upload your recent photo', 'error');
        return;
    }
    
    // Validate file sizes (5MB max)
    if (idProofFile.size > 5 * 1024 * 1024) {
        showFormMessage('ID proof file size must be less than 5MB', 'error');
        return;
    }
    
    if (photoFile.size > 5 * 1024 * 1024) {
        showFormMessage('Photo file size must be less than 5MB', 'error');
        return;
    }
    
    // Convert files to base64 for submission
    const idProofBase64 = await fileToBase64(idProofFile);
    const photoBase64 = await fileToBase64(photoFile);
    
    // Build comprehensive data object
    const data = {
        // Personal Information
        name: formData.get('name'),
        phone: formData.get('phone'),
        email: formData.get('email'),
        dob: formData.get('dob'),
        gender: formData.get('gender'),
        state: formData.get('state'),
        address: formData.get('address'),
        
        // Professional Details
        specialization: formData.get('specialization'),
        other_services: formData.get('other_services') || '',
        experience: parseInt(formData.get('experience')),
        education: formData.get('education'),
        languages: formData.get('languages'),
        qualifications: formData.get('qualifications') || '',
        
        // Availability
        working_days: workingDays.join(', '),
        availability: availability.join(', '),
        weekly_hours: formData.get('weekly_hours'),
        
        // Bank Details
        account_name: formData.get('account_name'),
        account_number: formData.get('account_number'),
        ifsc_code: formData.get('ifsc_code'),
        bank_name: formData.get('bank_name'),
        pan_card: formData.get('pan_card'),
        
        // About
        bio: formData.get('bio'),
        achievements: formData.get('achievements') || '',
        
        // File uploads
        id_proof: idProofBase64,
        id_proof_filename: idProofFile.name,
        photo: photoBase64,
        photo_filename: photoFile.name,
        
        // Technical & Other
        technical_access: technicalAccess.join(', '),
        how_heard: formData.get('how_heard'),
        comments: formData.get('comments') || '',
        
        // Metadata
        registration_date: new Date().toISOString(),
        registration_source: 'Landing Page',
    };
    
    showFormMessage('⏳ Submitting your registration...', 'loading');
    
    try {
        // Send to backend API
        const response = await fetch('http://localhost:8000/api/pandit/register/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        });
        
        const result = await response.json();
        
        if (response.ok) {
            showFormMessage('✅ Registration successful. Once we verify your profile we will get back to you.', 'success');
            
            // Reset form after 4 seconds
            setTimeout(() => {
                if (document.getElementById('panditModal')) {
                    closePanditModal();
                } else {
                    form.reset();
                    hideFormMessage();
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                }
            }, 4000);
        } else {
            showFormMessage(`❌ ${result.error || 'Registration failed. Please try again.'}`, 'error');
        }
    } catch (error) {
        console.error('Error submitting form:', error);
        showFormMessage('❌ Unable to submit. Please check your connection and try again.', 'error');
    }
}

// Helper function to convert file to base64
function fileToBase64(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => resolve(reader.result);
        reader.onerror = error => reject(error);
    });
}



// ===========================
// MULTI-LANGUAGE SUPPORT (English, Hindi, Marathi, Telugu, Gujarati, Kannada)
// ===========================

let currentLanguage = localStorage.getItem('panditFormLanguage') || 'en';
const supportedLanguages = ['en', 'hi', 'mr', 'te', 'gu', 'kn'];

const translations = {
    en: {
        // Header
        'PanditTalk Network': 'PanditTalk Network',
        'Join India\'s Fastest Growing Astrologer Community': 'Join India\'s Fastest Growing Astrologer Community',
        'Complete this verified onboarding form to get listed on PanditTalk, access thousands of seekers, and grow your spiritual practice with guaranteed payments.': 'Complete this verified onboarding form to get listed on PanditTalk, access thousands of seekers, and grow your spiritual practice with guaranteed payments.',
        '← Back to Landing Page': '← Back to Landing Page',
        'English': 'English',
        'Hindi': 'हिंदी (Hindi)',
        'Marathi': 'मराठी (Marathi)',
        'Telugu': 'తెలుగు (Telugu)',
        'Gujarati': 'ગુજરાતી (Gujarati)',
        'Kannada': 'ಕನ್ನಡ (Kannada)',
        // Form Headers
        'Official Onboarding Form': 'Official Onboarding Form',
        'Pandit / Astrologer Registration': 'Pandit / Astrologer Registration',
        'Only approved profiles go live on the PanditTalk app.': 'Only approved profiles go live on the PanditTalk app.',
        'Personal Information': 'Personal Information',
        'Professional Details': 'Professional Details',
        'Availability & Preference': 'Availability & Preference',
        'Bank Details (For Payments)': 'Bank Details (For Payments)',
        'About You': 'About You',
        'Identity Verification': 'Identity Verification',
        'Technical Setup': 'Technical Setup',
        'Additional Information': 'Additional Information',
        // Labels
        'Full Name *': 'Full Name *',
        'Phone Number *': 'Phone Number *',
        'Email Address *': 'Email Address *',
        'Date of Birth *': 'Date of Birth *',
        'Gender *': 'Gender *',
        'State *': 'State *',
        'Full Address *': 'Full Address *',
        'Main Specialization *': 'Main Specialization *',
        'Other Services Offered': 'Other Services Offered',
        'Total Experience (Years) *': 'Total Experience (Years) *',
        'Educational Qualification (Optional)': 'Educational Qualification (Optional)',
        'Languages Known *': 'Languages Known *',
        'Professional Certifications/Awards': 'Professional Certifications/Awards',
        'Preferred Working Days *': 'Preferred Working Days *',
        'Preferred Working Hours *': 'Preferred Working Hours *',
        'Expected Weekly Hours *': 'Expected Weekly Hours *',
        'Account Holder Name *': 'Account Holder Name *',
        'Bank Account Number *': 'Bank Account Number *',
        'IFSC Code *': 'IFSC Code *',
        'Bank Name *': 'Bank Name *',
        'PAN Card Number *': 'PAN Card Number *',
        'Professional Bio (max 1000 characters) *': 'Professional Bio (max 1000 characters) *',
        'Notable Achievements/Recognition': 'Notable Achievements/Recognition',
        'Upload Government ID Proof (Aadhaar / PAN / Voter ID) *': 'Upload Government ID Proof (Aadhaar / PAN / Voter ID) *',
        'Upload Your Recent Photo *': 'Upload Your Recent Photo *',
        'Do you have access to the following? *': 'Do you have access to the following? *',
        'How did you hear about PanditTalk? *': 'How did you hear about PanditTalk? *',
        'Additional Comments/Questions': 'Additional Comments/Questions',
        // Placeholders
        'Enter your full legal name': 'Enter your full legal name',
        '10-digit mobile number': '10-digit mobile number',
        'your.email@example.com': 'your.email@example.com',
        'e.g., Maharashtra': 'e.g., Maharashtra',
        'Complete address with pin code': 'Complete address with pin code',
        'Select Your Main Expertise': 'Select Your Main Expertise',
        'e.g., Marriage Counseling, Career Guidance': 'e.g., Marriage Counseling, Career Guidance',
        'Years of practice': 'Years of practice',
        'e.g., B.A., M.A., Ph.D.': 'e.g., B.A., M.A., Ph.D.',
        'e.g., Hindi, English, Marathi, Sanskrit': 'e.g., Hindi, English, Marathi, Sanskrit',
        'Select Hours per Week': 'Select Hours per Week',
        'As per bank records': 'As per bank records',
        'Account number': 'Account number',
        'e.g., SBIN0001234': 'e.g., SBIN0001234',
        'e.g., State Bank of India': 'e.g., State Bank of India',
        'e.g., ABCDE1234F': 'e.g., ABCDE1234F',
        'Tell us about your expertise, specialties, approach to consultations, and what makes you unique...': 'Tell us about your expertise, specialties, approach to consultations, and what makes you unique...',
        'Awards, media features, notable clients (optional)': 'Awards, media features, notable clients (optional)',
        'Any specific requirements, questions, or information you\'d like to share...': 'Any specific requirements, questions, or information you\'d like to share...',
        // Options
        'Select Gender': 'Select Gender',
        'Male': 'Male',
        'Female': 'Female',
        'Other': 'Other',
        'Select Option': 'Select Option',
        'Monday': 'Monday',
        'Tuesday': 'Tuesday',
        'Wednesday': 'Wednesday',
        'Thursday': 'Thursday',
        'Friday': 'Friday',
        'Saturday': 'Saturday',
        'Sunday': 'Sunday',
        'Morning (6AM-12PM)': 'Morning (6AM-12PM)',
        'Afternoon (12PM-6PM)': 'Afternoon (12PM-6PM)',
        'Evening (6PM-12AM)': 'Evening (6PM-12AM)',
        'Night (12AM-6AM)': 'Night (12AM-6AM)',
        'Less than 10 hours': 'Less than 10 hours',
        '10-20 hours': '10-20 hours',
        '20-30 hours': '20-30 hours',
        '30-40 hours': '30-40 hours',
        '40+ hours (Full-time)': '40+ hours (Full-time)',
        'Google Search': 'Google Search',
        'Social Media (Facebook/Instagram)': 'Social Media (Facebook/Instagram)',
        'Friend/Family Referral': 'Friend/Family Referral',
        'Advertisement': 'Advertisement',
        'Another Pandit': 'Another Pandit',
        // Buttons
        'Cancel': 'Cancel',
        'Submit Registration': 'Submit Registration',
        // Helper text
        'Skip if you don\'t have a formal degree': 'Skip if you don\'t have a formal degree',
        'This will be shown to users on your profile': 'This will be shown to users on your profile',
        'Accepted formats: JPG, PNG, PDF (Max 5MB)': 'Accepted formats: JPG, PNG, PDF (Max 5MB)',
        'Document must be clear and readable': 'Document must be clear and readable',
        'Clear, front-facing photo': 'Clear, front-facing photo',
        'Professional attire preferred': 'Professional attire preferred',
        'Smartphone (Android/iOS)': 'Smartphone (Android/iOS)',
        'Stable Internet Connection': 'Stable Internet Connection',
        'Quiet Space for Consultations': 'Quiet Space for Consultations',
        'PC / Desktop Setup for Professional Calls': 'PC / Desktop Setup for Professional Calls',
        'I agree to the': 'I agree to the',
        'Terms & Conditions': 'Terms & Conditions',
        'and': 'and',
        'Privacy Policy': 'Privacy Policy',
        'I agree to the <a href=\'#\' onclick=\'showTerms(event)\'>Terms & Conditions</a> and <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>Privacy Policy</a>': 'I agree to the <a href=\'#\' onclick=\'showTerms(event)\'>Terms & Conditions</a> and <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>Privacy Policy</a>',
    },
    hi: {
        // Header
        'PanditTalk Network': 'पंडितटॉक नेटवर्क',
        'Join India\'s Fastest Growing Astrologer Community': 'भारत के सबसे तेजी से बढ़ते ज्योतिषी समुदाय में शामिल हों',
        'Complete this verified onboarding form to get listed on PanditTalk, access thousands of seekers, and grow your spiritual practice with guaranteed payments.': 'पंडितटॉक पर सूचीबद्ध होने, हजारों साधकों तक पहुंचने और गारंटीकृत भुगतान के साथ अपने आध्यात्मिक अभ्यास को बढ़ाने के लिए इस सत्यापित ऑनबोर्डिंग फॉर्म को पूरा करें।',
        '← Back to Landing Page': '← लैंडिंग पेज पर वापस जाएं',
        'English': 'अंग्रेज़ी (English)',
        'Hindi': 'हिंदी (Hindi)',
        'Marathi': 'मराठी (Marathi)',
        'Telugu': 'तेलुगु (Telugu)',
        'Gujarati': 'गुजराती (Gujarati)',
        'Kannada': 'कन्नड़ (Kannada)',
        // Form Headers
        'Official Onboarding Form': 'आधिकारिक ऑनबोर्डिंग फॉर्म',
        'Pandit / Astrologer Registration': 'पंडित / ज्योतिषी पंजीकरण',
        'Only approved profiles go live on the PanditTalk app.': 'केवल अनुमोदित प्रोफाइल पंडितटॉक ऐप पर लाइव होती हैं।',
        'Personal Information': 'व्यक्तिगत जानकारी',
        'Professional Details': 'पेशेवर विवरण',
        'Availability & Preference': 'उपलब्धता और प्राथमिकता',
        'Bank Details (For Payments)': 'बैंक विवरण (भुगतान के लिए)',
        'About You': 'आपके बारे में',
        'Identity Verification': 'पहचान सत्यापन',
        'Technical Setup': 'तकनीकी सेटअप',
        'Additional Information': 'अतिरिक्त जानकारी',
        // Labels
        'Full Name *': 'पूरा नाम *',
        'Phone Number *': 'फोन नंबर *',
        'Email Address *': 'ईमेल पता *',
        'Date of Birth *': 'जन्म तिथि *',
        'Gender *': 'लिंग *',
        'State *': 'राज्य *',
        'Full Address *': 'पूरा पता *',
        'Main Specialization *': 'मुख्य विशेषज्ञता *',
        'Other Services Offered': 'अन्य सेवाएं',
        'Total Experience (Years) *': 'कुल अनुभव (वर्ष) *',
        'Educational Qualification (Optional)': 'शैक्षणिक योग्यता (वैकल्पिक)',
        'Languages Known *': 'ज्ञात भाषाएं *',
        'Professional Certifications/Awards': 'पेशेवर प्रमाणपत्र/पुरस्कार',
        'Preferred Working Days *': 'पसंदीदा कार्य दिवस *',
        'Preferred Working Hours *': 'पसंदीदा कार्य घंटे *',
        'Expected Weekly Hours *': 'अपेक्षित साप्ताहिक घंटे *',
        'Account Holder Name *': 'खाताधारक का नाम *',
        'Bank Account Number *': 'बैंक खाता संख्या *',
        'IFSC Code *': 'IFSC कोड *',
        'Bank Name *': 'बैंक का नाम *',
        'PAN Card Number *': 'PAN कार्ड नंबर *',
        'Professional Bio (max 1000 characters) *': 'पेशेवर जीवनी (अधिकतम 1000 वर्ण) *',
        'Notable Achievements/Recognition': 'उल्लेखनीय उपलब्धियां/मान्यता',
        'Upload Government ID Proof (Aadhaar / PAN / Voter ID) *': 'सरकारी आईडी प्रमाण अपलोड करें (आधार / PAN / मतदाता आईडी) *',
        'Upload Your Recent Photo *': 'अपना हाल का फोटो अपलोड करें *',
        'Do you have access to the following? *': 'क्या आपके पास निम्नलिखित तक पहुंच है? *',
        'How did you hear about PanditTalk? *': 'आपने पंडितटॉक के बारे में कैसे सुना? *',
        'Additional Comments/Questions': 'अतिरिक्त टिप्पणियां/प्रश्न',
        // Placeholders
        'Enter your full legal name': 'अपना पूरा कानूनी नाम दर्ज करें',
        '10-digit mobile number': '10 अंकों का मोबाइल नंबर',
        'your.email@example.com': 'आपका.ईमेल@उदाहरण.com',
        'e.g., Maharashtra': 'उदाहरण: महाराष्ट्र',
        'Complete address with pin code': 'पिन कोड के साथ पूरा पता',
        'Select Your Main Expertise': 'अपनी मुख्य विशेषज्ञता चुनें',
        'e.g., Marriage Counseling, Career Guidance': 'उदाहरण: विवाह परामर्श, करियर मार्गदर्शन',
        'Years of practice': 'अभ्यास के वर्ष',
        'e.g., B.A., M.A., Ph.D.': 'उदाहरण: B.A., M.A., Ph.D.',
        'e.g., Hindi, English, Marathi, Sanskrit': 'उदाहरण: हिंदी, अंग्रेजी, मराठी, संस्कृत',
        'Select Hours per Week': 'प्रति सप्ताह घंटे चुनें',
        'As per bank records': 'बैंक रिकॉर्ड के अनुसार',
        'Account number': 'खाता संख्या',
        'e.g., SBIN0001234': 'उदाहरण: SBIN0001234',
        'e.g., State Bank of India': 'उदाहरण: भारतीय स्टेट बैंक',
        'e.g., ABCDE1234F': 'उदाहरण: ABCDE1234F',
        'Tell us about your expertise, specialties, approach to consultations, and what makes you unique...': 'हमें अपनी विशेषज्ञता, विशेषताओं, परामर्श के दृष्टिकोण और आपको क्या विशिष्ट बनाता है के बारे में बताएं...',
        'Awards, media features, notable clients (optional)': 'पुरस्कार, मीडिया फीचर्स, उल्लेखनीय ग्राहक (वैकल्पिक)',
        'Any specific requirements, questions, or information you\'d like to share...': 'कोई विशिष्ट आवश्यकताएं, प्रश्न या जानकारी जो आप साझा करना चाहेंगे...',
        // Options
        'Select Gender': 'लिंग चुनें',
        'Male': 'पुरुष',
        'Female': 'महिला',
        'Other': 'अन्य',
        'Select Option': 'विकल्प चुनें',
        'Monday': 'सोमवार',
        'Tuesday': 'मंगलवार',
        'Wednesday': 'बुधवार',
        'Thursday': 'गुरुवार',
        'Friday': 'शुक्रवार',
        'Saturday': 'शनिवार',
        'Sunday': 'रविवार',
        'Morning (6AM-12PM)': 'सुबह (6AM-12PM)',
        'Afternoon (12PM-6PM)': 'दोपहर (12PM-6PM)',
        'Evening (6PM-12AM)': 'शाम (6PM-12AM)',
        'Night (12AM-6AM)': 'रात (12AM-6AM)',
        'Less than 10 hours': '10 घंटे से कम',
        '10-20 hours': '10-20 घंटे',
        '20-30 hours': '20-30 घंटे',
        '30-40 hours': '30-40 घंटे',
        '40+ hours (Full-time)': '40+ घंटे (पूर्णकालिक)',
        'Google Search': 'Google खोज',
        'Social Media (Facebook/Instagram)': 'सोशल मीडिया (Facebook/Instagram)',
        'Friend/Family Referral': 'मित्र/परिवार संदर्भ',
        'Advertisement': 'विज्ञापन',
        'Another Pandit': 'एक अन्य पंडित',
        // Buttons
        'Cancel': 'रद्द करें',
        'Submit Registration': 'पंजीकरण सबमिट करें',
        // Helper text
        'Skip if you don\'t have a formal degree': 'यदि आपके पास औपचारिक डिग्री नहीं है तो छोड़ दें',
        'This will be shown to users on your profile': 'यह आपकी प्रोफ़ाइल पर उपयोगकर्ताओं को दिखाया जाएगा',
        'Accepted formats: JPG, PNG, PDF (Max 5MB)': 'स्वीकृत प्रारूप: JPG, PNG, PDF (अधिकतम 5MB)',
        'Document must be clear and readable': 'दस्तावेज़ स्पष्ट और पठनीय होना चाहिए',
        'Clear, front-facing photo': 'स्पष्ट, सामने की ओर फोटो',
        'Professional attire preferred': 'पेशेवर पोशाक पसंदीदा',
        'Smartphone (Android/iOS)': 'स्मार्टफोन (Android/iOS)',
        'Stable Internet Connection': 'स्थिर इंटरनेट कनेक्शन',
        'Quiet Space for Consultations': 'परामर्श के लिए शांत स्थान',
        'PC / Desktop Setup for Professional Calls': 'पेशेवर कॉल के लिए PC / डेस्कटॉप सेटअप',
        'I agree to the': 'मैं सहमत हूं',
        'Terms & Conditions': 'नियम और शर्तें',
        'and': 'और',
        'Privacy Policy': 'गोपनीयता नीति',
        'I agree to the <a href=\'#\' onclick=\'showTerms(event)\'>Terms & Conditions</a> and <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>Privacy Policy</a>': 'मैं <a href=\'#\' onclick=\'showTerms(event)\'>नियम और शर्तें</a> और <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>गोपनीयता नीति</a> से सहमत हूं',
    },
    mr: {
        // Header
        'PanditTalk Network': 'पंडितटॉक नेटवर्क',
        'Join India\'s Fastest Growing Astrologer Community': 'भारतातील सर्वात वेगाने वाढत असलेल्या ज्योतिषी समुदायात सामील व्हा',
        'Complete this verified onboarding form to get listed on PanditTalk, access thousands of seekers, and grow your spiritual practice with guaranteed payments.': 'पंडितटॉक वर सूचीबद्ध होण्यासाठी, हजारो शोधकांपर्यंत पोहोचण्यासाठी आणि हमी भुगतानासह आपल्या आध्यात्मिक सराव वाढवण्यासाठी हा सत्यापित ऑनबोर्डिंग फॉर्म पूर्ण करा.',
        '← Back to Landing Page': '← लँडिंग पृष्ठावर परत जा',
        'English': 'इंग्रजी (English)',
        'Hindi': 'हिंदी (Hindi)',
        'Marathi': 'मराठी (Marathi)',
        'Telugu': 'तेलुगु (Telugu)',
        'Gujarati': 'गुजराती (Gujarati)',
        'Kannada': 'कन्नड (Kannada)',
        // Form Headers
        'Official Onboarding Form': 'अधिकृत ऑनबोर्डिंग फॉर्म',
        'Pandit / Astrologer Registration': 'पंडित / ज्योतिषी नोंदणी',
        'Only approved profiles go live on the PanditTalk app.': 'केवळ मंजूर प्रोफाइल पंडितटॉक अॅपवर लाइव्ह होतात.',
        'Personal Information': 'वैयक्तिक माहिती',
        'Professional Details': 'व्यावसायिक तपशील',
        'Availability & Preference': 'उपलब्धता आणि प्राधान्य',
        'Bank Details (For Payments)': 'बैंक तपशील (पेमेंटसाठी)',
        'About You': 'तुमच्याबद्दल',
        'Identity Verification': 'ओळख सत्यापन',
        'Technical Setup': 'तांत्रिक सेटअप',
        'Additional Information': 'अतिरिक्त माहिती',
        // Labels
        'Full Name *': 'पूर्ण नाव *',
        'Phone Number *': 'फोन नंबर *',
        'Email Address *': 'ईमेल पत्ता *',
        'Date of Birth *': 'जन्मतारीख *',
        'Gender *': 'लिंग *',
        'State *': 'राज्य *',
        'Full Address *': 'पूर्ण पत्ता *',
        'Main Specialization *': 'मुख्य विशेषज्ञता *',
        'Other Services Offered': 'इतर सेवा',
        'Total Experience (Years) *': 'एकूण अनुभव (वर्षे) *',
        'Educational Qualification (Optional)': 'शैक्षणिक पात्रता (पर्यायी)',
        'Languages Known *': 'ज्ञात भाषा *',
        'Professional Certifications/Awards': 'व्यावसायिक प्रमाणपत्रे/पुरस्कार',
        'Preferred Working Days *': 'पसंतीचे कामाचे दिवस *',
        'Preferred Working Hours *': 'पसंतीचे कामाचे तास *',
        'Expected Weekly Hours *': 'अपेक्षित साप्ताहिक तास *',
        'Account Holder Name *': 'खातेदाराचे नाव *',
        'Bank Account Number *': 'बैंक खाता क्रमांक *',
        'IFSC Code *': 'IFSC कोड *',
        'Bank Name *': 'बैंकचे नाव *',
        'PAN Card Number *': 'PAN कार्ड क्रमांक *',
        'Professional Bio (max 1000 characters) *': 'व्यावसायिक जीवनचरित्र (कमाल 1000 वर्ण) *',
        'Notable Achievements/Recognition': 'उल्लेखनीय यशोगाथा/मान्यता',
        'Upload Government ID Proof (Aadhaar / PAN / Voter ID) *': 'सरकारी ओळख पुरावा अपलोड करा (आधार / PAN / मतदार ओळख) *',
        'Upload Your Recent Photo *': 'तुमचे अलीकडील फोटो अपलोड करा *',
        'Do you have access to the following? *': 'तुमच्याकडे खालील गोष्टींची प्रवेश आहे का? *',
        'How did you hear about PanditTalk? *': 'तुम्ही पंडितटॉक बद्दल कसे ऐकले? *',
        'Additional Comments/Questions': 'अतिरिक्त टिप्पण्या/प्रश्न',
        // Placeholders
        'Enter your full legal name': 'तुमचे पूर्ण कायदेशीर नाव प्रविष्ट करा',
        '10-digit mobile number': '10 अंकांचा मोबाइल नंबर',
        'your.email@example.com': 'तुमचा.ईमेल@उदाहरण.com',
        'e.g., Maharashtra': 'उदा: महाराष्ट्र',
        'Complete address with pin code': 'पिन कोडसह पूर्ण पत्ता',
        'Select Your Main Expertise': 'तुमची मुख्य विशेषज्ञता निवडा',
        'e.g., Marriage Counseling, Career Guidance': 'उदा: लग्न सल्लागार, करिअर मार्गदर्शन',
        'Years of practice': 'सरावाची वर्षे',
        'e.g., B.A., M.A., Ph.D.': 'उदा: B.A., M.A., Ph.D.',
        'e.g., Hindi, English, Marathi, Sanskrit': 'उदा: हिंदी, इंग्रजी, मराठी, संस्कृत',
        'Select Hours per Week': 'प्रति आठवडा तास निवडा',
        'As per bank records': 'बैंक रेकॉर्डनुसार',
        'Account number': 'खाता क्रमांक',
        'e.g., SBIN0001234': 'उदा: SBIN0001234',
        'e.g., State Bank of India': 'उदा: भारतीय स्टेट बैंक',
        'e.g., ABCDE1234F': 'उदा: ABCDE1234F',
        'Tell us about your expertise, specialties, approach to consultations, and what makes you unique...': 'तुमच्या विशेषज्ञतेबद्दल, विशेषतांबद्दल, सल्लामसलतीच्या दृष्टिकोणाबद्दल आणि तुम्हाला काय विशेष बनवते याबद्दल सांगा...',
        'Awards, media features, notable clients (optional)': 'पुरस्कार, मीडिया फीचर्स, उल्लेखनीय क्लायंट (पर्यायी)',
        'Any specific requirements, questions, or information you\'d like to share...': 'कोणतीही विशिष्ट आवश्यकता, प्रश्न किंवा माहिती जी तुम्ही सामायिक करू इच्छिता...',
        // Options
        'Select Gender': 'लिंग निवडा',
        'Male': 'पुरुष',
        'Female': 'स्त्री',
        'Other': 'इतर',
        'Select Option': 'पर्याय निवडा',
        'Monday': 'सोमवार',
        'Tuesday': 'मंगळवार',
        'Wednesday': 'बुधवार',
        'Thursday': 'गुरुवार',
        'Friday': 'शुक्रवार',
        'Saturday': 'शनिवार',
        'Sunday': 'रविवार',
        'Morning (6AM-12PM)': 'सकाळ (6AM-12PM)',
        'Afternoon (12PM-6PM)': 'दुपार (12PM-6PM)',
        'Evening (6PM-12AM)': 'संध्याकाळ (6PM-12AM)',
        'Night (12AM-6AM)': 'रात्र (12AM-6AM)',
        'Less than 10 hours': '10 तासांपेक्षा कमी',
        '10-20 hours': '10-20 तास',
        '20-30 hours': '20-30 तास',
        '30-40 hours': '30-40 तास',
        '40+ hours (Full-time)': '40+ तास (पूर्णवेळ)',
        'Google Search': 'Google शोध',
        'Social Media (Facebook/Instagram)': 'सोशल मीडिया (Facebook/Instagram)',
        'Friend/Family Referral': 'मित्र/कुटुंब संदर्भ',
        'Advertisement': 'जाहिरात',
        'Another Pandit': 'दुसरा पंडित',
        // Buttons
        'Cancel': 'रद्द करा',
        'Submit Registration': 'नोंदणी सबमिट करा',
        // Helper text
        'Skip if you don\'t have a formal degree': 'जर तुमच्याकडे औपचारिक पदवी नसेल तर वगळा',
        'This will be shown to users on your profile': 'हे तुमच्या प्रोफाइलवर वापरकर्त्यांना दाखवले जाईल',
        'Accepted formats: JPG, PNG, PDF (Max 5MB)': 'स्वीकृत स्वरूपे: JPG, PNG, PDF (कमाल 5MB)',
        'Document must be clear and readable': 'दस्तऐवज स्पष्ट आणि वाचनीय असावा',
        'Clear, front-facing photo': 'स्पष्ट, समोरचे फोटो',
        'Professional attire preferred': 'व्यावसायिक पोशाक प्राधान्य',
        'Smartphone (Android/iOS)': 'स्मार्टफोन (Android/iOS)',
        'Stable Internet Connection': 'स्थिर इंटरनेट कनेक्शन',
        'Quiet Space for Consultations': 'सल्लामसलतीसाठी शांत जागा',
        'PC / Desktop Setup for Professional Calls': 'व्यावसायिक कॉलसाठी PC / डेस्कटॉप सेटअप',
        'I agree to the': 'मी सहमत आहे',
        'Terms & Conditions': 'अटी आणि नियम',
        'and': 'आणि',
        'Privacy Policy': 'गोपनीयता धोरण',
        'I agree to the <a href=\'#\' onclick=\'showTerms(event)\'>Terms & Conditions</a> and <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>Privacy Policy</a>': 'मी <a href=\'#\' onclick=\'showTerms(event)\'>अटी आणि नियम</a> आणि <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>गोपनीयता धोरण</a> यांना सहमती देतो/देते',
    },
    te: {
        // Header
        'PanditTalk Network': 'పండిత్ టాక్ నెట్‌వర్క్',
        'Join India\'s Fastest Growing Astrologer Community': 'భారతదేశంలోని అత్యంత వేగంగా వృద్ధి చెందుతున్న జ్యోతిష్య సమాజంలో చేరండి',
        'Complete this verified onboarding form to get listed on PanditTalk, access thousands of seekers, and grow your spiritual practice with guaranteed payments.': 'పండిత్ టాక్‌లో జాబితా చేయడానికి, వేలాది అన్వేషకులకు ప్రాప్యత పొందడానికి మరియు హామీ చెల్లింపులతో మీ ఆధ్యాత్మిక అభ్యాసాన్ని పెంచడానికి ఈ ధృవీకరించబడిన ఆన్‌బోర్డింగ్ ఫారమ్‌ను పూర్తి చేయండి.',
        '← Back to Landing Page': '← ల్యాండింగ్ పేజీకి తిరిగి వెళ్లండి',
        'English': 'ఇంగ్లీష్ (English)',
        'Hindi': 'హిందీ (Hindi)',
        'Marathi': 'మరాఠీ (Marathi)',
        'Telugu': 'తెలుగు (Telugu)',
        'Gujarati': 'గుజరాతీ (Gujarati)',
        'Kannada': 'కన్నడ (Kannada)',
        // Form Headers
        'Official Onboarding Form': 'అధికారిక ఆన్‌బోర్డింగ్ ఫారమ్',
        'Pandit / Astrologer Registration': 'పండిత్ / జ్యోతిష్యుడు నమోదు',
        'Only approved profiles go live on the PanditTalk app.': 'అనుమోదించబడిన ప్రొఫైళ్ళు మాత్రమే పండిత్ టాక్ అనువర్తనంలో ప్రత్యక్షంగా ఉంటాయి.',
        'Personal Information': 'వ్యక్తిగత సమాచారం',
        'Professional Details': 'వృత్తిపరమైన వివరాలు',
        'Availability & Preference': 'లభ్యత మరియు ప్రాధాన్యత',
        'Bank Details (For Payments)': 'బ్యాంక్ వివరాలు (చెల్లింపుల కోసం)',
        'About You': 'మీ గురించి',
        'Identity Verification': 'గుర్తింపు ధృవీకరణ',
        'Technical Setup': 'సాంకేతిక సెటప్',
        'Additional Information': 'అదనపు సమాచారం',
        // Labels
        'Full Name *': 'పూర్తి పేరు *',
        'Phone Number *': 'ఫోన్ నంబర్ *',
        'Email Address *': 'ఇమెయిల్ చిరునామా *',
        'Date of Birth *': 'పుట్టిన తేదీ *',
        'Gender *': 'లింగం *',
        'State *': 'రాష్ట్రం *',
        'Full Address *': 'పూర్తి చిరునామా *',
        'Main Specialization *': 'ప్రధాన నైపుణ్యం *',
        'Other Services Offered': 'ఇతర సేవలు',
        'Total Experience (Years) *': 'మొత్తం అనుభవం (సంవత్సరాలు) *',
        'Educational Qualification (Optional)': 'విద్యా అర్హత (ఐచ్ఛికం)',
        'Languages Known *': 'తెలిసిన భాషలు *',
        'Professional Certifications/Awards': 'వృత్తిపరమైన ధృవీకరణలు/పురస్కారాలు',
        'Preferred Working Days *': 'ఇష్టపడే పని రోజులు *',
        'Preferred Working Hours *': 'ఇష్టపడే పని గంటలు *',
        'Expected Weekly Hours *': 'అంచనా వార్షిక గంటలు *',
        'Account Holder Name *': 'ఖాతా హోల్డర్ పేరు *',
        'Bank Account Number *': 'బ్యాంక్ ఖాతా నంబర్ *',
        'IFSC Code *': 'IFSC కోడ్ *',
        'Bank Name *': 'బ్యాంక్ పేరు *',
        'PAN Card Number *': 'PAN కార్డ్ నంబర్ *',
        'Professional Bio (max 1000 characters) *': 'వృత్తిపరమైన జీవిత చరిత్ర (గరిష్ట 1000 అక్షరాలు) *',
        'Notable Achievements/Recognition': 'గుర్తించదగిన సాధనలు/గుర్తింపు',
        'Upload Government ID Proof (Aadhaar / PAN / Voter ID) *': 'ప్రభుత్వ ID రుజువు అప్‌లోడ్ చేయండి (ఆధార్ / PAN / ఓటర్ ID) *',
        'Upload Your Recent Photo *': 'మీ ఇటీవలి ఫోటోను అప్‌లోడ్ చేయండి *',
        'Do you have access to the following? *': 'మీకు క్రింది వాటికి ప్రాప్యత ఉందా? *',
        'How did you hear about PanditTalk? *': 'మీరు పండిత్ టాక్ గురించి ఎలా విన్నారు? *',
        'Additional Comments/Questions': 'అదనపు వ్యాఖ్యలు/ప్రశ్నలు',
        // Placeholders
        'Enter your full legal name': 'మీ పూర్తి చట్టపరమైన పేరును నమోదు చేయండి',
        '10-digit mobile number': '10 అంకెల మొబైల్ నంబర్',
        'your.email@example.com': 'మీ.ఇమెయిల్@ఉదాహరణ.com',
        'e.g., Maharashtra': 'ఉదా: మహారాష్ట్ర',
        'Complete address with pin code': 'పిన్ కోడ్‌తో పూర్తి చిరునామా',
        'Select Your Main Expertise': 'మీ ప్రధాన నైపుణ్యాన్ని ఎంచుకోండి',
        'e.g., Marriage Counseling, Career Guidance': 'ఉదా: వివాహ సలహా, కెరీర్ మార్గదర్శకత్వం',
        'Years of practice': 'అభ్యాస సంవత్సరాలు',
        'e.g., B.A., M.A., Ph.D.': 'ఉదా: B.A., M.A., Ph.D.',
        'e.g., Hindi, English, Marathi, Sanskrit': 'ఉదా: హిందీ, ఇంగ్లీష్, మరాఠీ, సంస్కృతం',
        'Select Hours per Week': 'వారానికి గంటలు ఎంచుకోండి',
        'As per bank records': 'బ్యాంక్ రికార్డుల ప్రకారం',
        'Account number': 'ఖాతా నంబర్',
        'e.g., SBIN0001234': 'ఉదా: SBIN0001234',
        'e.g., State Bank of India': 'ఉదా: భారతీయ స్టేట్ బ్యాంక్',
        'e.g., ABCDE1234F': 'ఉదా: ABCDE1234F',
        'Tell us about your expertise, specialties, approach to consultations, and what makes you unique...': 'మీ నైపుణ్యం, ప్రత్యేకతలు, సలహాలకు విధానం మరియు మిమ్మల్ని ప్రత్యేకంగా చేసేది గురించి మాకు చెప్పండి...',
        'Awards, media features, notable clients (optional)': 'పురస్కారాలు, మీడియా ఫీచర్‌లు, గుర్తించదగిన క్లయింట్‌లు (ఐచ్ఛికం)',
        'Any specific requirements, questions, or information you\'d like to share...': 'మీరు భాగస్వామ్యం చేయాలనుకునే ఏదైనా నిర్దిష్ట అవసరాలు, ప్రశ్నలు లేదా సమాచారం...',
        // Options
        'Select Gender': 'లింగాన్ని ఎంచుకోండి',
        'Male': 'పురుషుడు',
        'Female': 'స్త్రీ',
        'Other': 'ఇతర',
        'Select Option': 'ఎంపికను ఎంచుకోండి',
        'Monday': 'సోమవారం',
        'Tuesday': 'మంగళవారం',
        'Wednesday': 'బుధవారం',
        'Thursday': 'గురువారం',
        'Friday': 'శుక్రవారం',
        'Saturday': 'శనివారం',
        'Sunday': 'ఆదివారం',
        'Morning (6AM-12PM)': 'ఉదయం (6AM-12PM)',
        'Afternoon (12PM-6PM)': 'మధ్యాహ్నం (12PM-6PM)',
        'Evening (6PM-12AM)': 'సాయంత్రం (6PM-12AM)',
        'Night (12AM-6AM)': 'రాత్రి (12AM-6AM)',
        'Less than 10 hours': '10 గంటల కంటే తక్కువ',
        '10-20 hours': '10-20 గంటలు',
        '20-30 hours': '20-30 గంటలు',
        '30-40 hours': '30-40 గంటలు',
        '40+ hours (Full-time)': '40+ గంటలు (పూర్తి సమయం)',
        'Google Search': 'Google శోధన',
        'Social Media (Facebook/Instagram)': 'సోషల్ మీడియా (Facebook/Instagram)',
        'Friend/Family Referral': 'స్నేహితుడు/కుటుంబ సూచన',
        'Advertisement': 'విజ్ఞాపనం',
        'Another Pandit': 'మరొక పండిత్',
        // Buttons
        'Cancel': 'రద్దు చేయండి',
        'Submit Registration': 'నమోదును సమర్పించండి',
        // Helper text
        'Skip if you don\'t have a formal degree': 'మీకు అధికారిక డిగ్రీ లేకపోతే దాటవేయండి',
        'This will be shown to users on your profile': 'ఇది మీ ప్రొఫైల్‌లో వినియోగదారులకు చూపబడుతుంది',
        'Accepted formats: JPG, PNG, PDF (Max 5MB)': 'అంగీకరించబడిన ఫార్మాట్‌లు: JPG, PNG, PDF (గరిష్ట 5MB)',
        'Document must be clear and readable': 'పత్రం స్పష్టంగా మరియు చదవగలిగేదిగా ఉండాలి',
        'Clear, front-facing photo': 'స్పష్టమైన, ముందు భాగం ఫోటో',
        'Professional attire preferred': 'వృత్తిపరమైన దుస్తులు ప్రాధాన్యత',
        'Smartphone (Android/iOS)': 'స్మార్ట్‌ఫోన్ (Android/iOS)',
        'Stable Internet Connection': 'స్థిరమైన ఇంటర్నెట్ కనెక్షన్',
        'Quiet Space for Consultations': 'సలహాల కోసం నిశ్శబ్ద ప్రదేశం',
        'PC / Desktop Setup for Professional Calls': 'వృత్తిపరమైన కాల్‌ల కోసం PC / డెస్క్‌టాప్ సెటప్',
        'I agree to the': 'నేను అంగీకరిస్తున్నాను',
        'Terms & Conditions': 'నిబంధనలు మరియు షరతులు',
        'and': 'మరియు',
        'Privacy Policy': 'గోప్యతా విధానం',
        'I agree to the <a href=\'#\' onclick=\'showTerms(event)\'>Terms & Conditions</a> and <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>Privacy Policy</a>': 'నేను <a href=\'#\' onclick=\'showTerms(event)\'>నిబంధనలు మరియు షరతులు</a> మరియు <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>గోప్యతా విధానం</a> కి అంగీకరిస్తున్నాను',
    },
    gu: {
        // Header
        'PanditTalk Network': 'પંડિતટોક નેટવર્ક',
        'Join India\'s Fastest Growing Astrologer Community': 'ભારતના સૌથી ઝડપથી વધતા જ્યોતિષી સમુદાયમાં જોડાઓ',
        'Complete this verified onboarding form to get listed on PanditTalk, access thousands of seekers, and grow your spiritual practice with guaranteed payments.': 'પંડિતટોક પર સૂચિબદ્ધ થવા, હજારો શોધકો સુધી પહોંચવા અને ગેરંટીડ ચુકવણી સાથે તમારી આધ્યાત્મિક પ્રેક્ટિસ વધારવા માટે આ ચકાસાયેલ ઓનબોર્ડિંગ ફોર્મ પૂર્ણ કરો.',
        '← Back to Landing Page': '← લેન્ડિંગ પૃષ્ઠ પર પાછા જાઓ',
        'English': 'અંગ્રેજી (English)',
        'Hindi': 'હિન્દી (Hindi)',
        'Marathi': 'મરાઠી (Marathi)',
        'Telugu': 'ટેલુગુ (Telugu)',
        'Gujarati': 'ગુજરાતી (Gujarati)',
        'Kannada': 'કન્નડ (Kannada)',
        // Form Headers
        'Official Onboarding Form': 'અધિકૃત ઓનબોર્ડિંગ ફોર્મ',
        'Pandit / Astrologer Registration': 'પંડિત / જ્યોતિષી નોંધણી',
        'Only approved profiles go live on the PanditTalk app.': 'મંજૂરી મળેલા પ્રોફાઇલ્સ જ પંડિતટોક એપ્લિકેશન પર લાઇવ થાય છે.',
        'Personal Information': 'વ્યક્તિગત માહિતી',
        'Professional Details': 'વ્યાવસાયિક વિગતો',
        'Availability & Preference': 'ઉપલબ્ધતા અને પ્રાથમિકતા',
        'Bank Details (For Payments)': 'બેંક વિગતો (ચુકવણી માટે)',
        'About You': 'તમારા વિશે',
        'Identity Verification': 'ઓળખ ચકાસણી',
        'Technical Setup': 'ટેકનિકલ સેટઅપ',
        'Additional Information': 'અતિરિક્ત માહિતી',
        // Labels
        'Full Name *': 'પૂર્ણ નામ *',
        'Phone Number *': 'ફોન નંબર *',
        'Email Address *': 'ઇમેઇલ સરનામું *',
        'Date of Birth *': 'જન્મ તારીખ *',
        'Gender *': 'લિંગ *',
        'State *': 'રાજ્ય *',
        'Full Address *': 'પૂર્ણ સરનામું *',
        'Main Specialization *': 'મુખ્ય વિશેષતા *',
        'Other Services Offered': 'અન્ય સેવાઓ',
        'Total Experience (Years) *': 'કુલ અનુભવ (વર્ષ) *',
        'Educational Qualification (Optional)': 'શૈક્ષણિક લાયકાત (વૈકલ્પિક)',
        'Languages Known *': 'જાણીતી ભાષાઓ *',
        'Professional Certifications/Awards': 'વ્યાવસાયિક પ્રમાણપત્રો/પુરસ્કારો',
        'Preferred Working Days *': 'પ્રિય કામના દિવસો *',
        'Preferred Working Hours *': 'પ્રિય કામના કલાકો *',
        'Expected Weekly Hours *': 'અપેક્ષિત સાપ્તાહિક કલાકો *',
        'Account Holder Name *': 'એકાઉન્ટ હોલ્ડરનું નામ *',
        'Bank Account Number *': 'બેંક એકાઉન્ટ નંબર *',
        'IFSC Code *': 'IFSC કોડ *',
        'Bank Name *': 'બેંકનું નામ *',
        'PAN Card Number *': 'PAN કાર્ડ નંબર *',
        'Professional Bio (max 1000 characters) *': 'વ્યાવસાયિક જીવનચરિત્ર (મહત્તમ 1000 અક્ષરો) *',
        'Notable Achievements/Recognition': 'નોંધપાત્ર સિદ્ધિઓ/માન્યતા',
        'Upload Government ID Proof (Aadhaar / PAN / Voter ID) *': 'સરકારી ID પુરાવો અપલોડ કરો (આધાર / PAN / મતદાતા ID) *',
        'Upload Your Recent Photo *': 'તમારું તાજેતરનું ફોટો અપલોડ કરો *',
        'Do you have access to the following? *': 'શું તમારી પાસે નીચેની વસ્તુઓની પહોંચ છે? *',
        'How did you hear about PanditTalk? *': 'તમે પંડિતટોક વિશે કેવી રીતે સાંભળ્યું? *',
        'Additional Comments/Questions': 'અતિરિક્ત ટિપ્પણીઓ/પ્રશ્નો',
        // Placeholders
        'Enter your full legal name': 'તમારું પૂર્ણ કાનૂની નામ દાખલ કરો',
        '10-digit mobile number': '10 અંકનો મોબાઇલ નંબર',
        'your.email@example.com': 'તમારું.ઇમેઇલ@ઉદાહરણ.com',
        'e.g., Maharashtra': 'ઉદા: મહારાષ્ટ્ર',
        'Complete address with pin code': 'પિન કોડ સાથે પૂર્ણ સરનામું',
        'Select Your Main Expertise': 'તમારી મુખ્ય નિપુણતા પસંદ કરો',
        'e.g., Marriage Counseling, Career Guidance': 'ઉદા: લગ્ન સલાહ, કારકિર્દી માર્ગદર્શન',
        'Years of practice': 'પ્રેક્ટિસના વર્ષો',
        'e.g., B.A., M.A., Ph.D.': 'ઉદા: B.A., M.A., Ph.D.',
        'e.g., Hindi, English, Marathi, Sanskrit': 'ઉદા: હિન્દી, અંગ્રેજી, મરાઠી, સંસ્કૃત',
        'Select Hours per Week': 'પ્રતિ સપ્તાહ કલાકો પસંદ કરો',
        'As per bank records': 'બેંક રેકોર્ડ મુજબ',
        'Account number': 'એકાઉન્ટ નંબર',
        'e.g., SBIN0001234': 'ઉદા: SBIN0001234',
        'e.g., State Bank of India': 'ઉદા: ભારતીય સ્ટેટ બેંક',
        'e.g., ABCDE1234F': 'ઉદા: ABCDE1234F',
        'Tell us about your expertise, specialties, approach to consultations, and what makes you unique...': 'તમારી નિપુણતા, વિશેષતાઓ, સલાહ માટેનો અભિગમ અને તમને શું વિશિષ્ટ બનાવે છે તે વિશે અમને કહો...',
        'Awards, media features, notable clients (optional)': 'પુરસ્કારો, મીડિયા ફીચર્સ, નોંધપાત્ર ક્લાયન્ટ્સ (વૈકલ્પિક)',
        'Any specific requirements, questions, or information you\'d like to share...': 'કોઈપણ ચોક્કસ જરૂરિયાતો, પ્રશ્નો અથવા માહિતી જે તમે શેર કરવા માંગો છો...',
        // Options
        'Select Gender': 'લિંગ પસંદ કરો',
        'Male': 'પુરુષ',
        'Female': 'સ્ત્રી',
        'Other': 'અન્ય',
        'Select Option': 'વિકલ્પ પસંદ કરો',
        'Monday': 'સોમવાર',
        'Tuesday': 'મંગળવાર',
        'Wednesday': 'બુધવાર',
        'Thursday': 'ગુરુવાર',
        'Friday': 'શુક્રવાર',
        'Saturday': 'શનિવાર',
        'Sunday': 'રવિવાર',
        'Morning (6AM-12PM)': 'સવાર (6AM-12PM)',
        'Afternoon (12PM-6PM)': 'બપોરે (12PM-6PM)',
        'Evening (6PM-12AM)': 'સાંજે (6PM-12AM)',
        'Night (12AM-6AM)': 'રાત્રે (12AM-6AM)',
        'Less than 10 hours': '10 કલાકથી ઓછા',
        '10-20 hours': '10-20 કલાક',
        '20-30 hours': '20-30 કલાક',
        '30-40 hours': '30-40 કલાક',
        '40+ hours (Full-time)': '40+ કલાક (પૂર્ણ સમય)',
        'Google Search': 'Google શોધ',
        'Social Media (Facebook/Instagram)': 'સોશિયલ મીડિયા (Facebook/Instagram)',
        'Friend/Family Referral': 'મિત્ર/કુટુંબ સંદર્ભ',
        'Advertisement': 'જાહેરાત',
        'Another Pandit': 'બીજો પંડિત',
        // Buttons
        'Cancel': 'રદ કરો',
        'Submit Registration': 'નોંધણી સબમિટ કરો',
        // Helper text
        'Skip if you don\'t have a formal degree': 'જો તમારી પાસે ઔપચારિક ડિગ્રી ન હોય તો છોડી દો',
        'This will be shown to users on your profile': 'આ તમારી પ્રોફાઇલ પર વપરાશકર્તાઓને બતાવવામાં આવશે',
        'Accepted formats: JPG, PNG, PDF (Max 5MB)': 'સ્વીકૃત ફોર્મેટ્સ: JPG, PNG, PDF (મહત્તમ 5MB)',
        'Document must be clear and readable': 'દસ્તાવેજ સ્પષ્ટ અને વાંચી શકાય તેવો હોવો જોઈએ',
        'Clear, front-facing photo': 'સ્પષ્ટ, આગળની તરફનું ફોટો',
        'Professional attire preferred': 'વ્યાવસાયિક પોશાક પ્રાધાન્ય',
        'Smartphone (Android/iOS)': 'સ્માર્ટફોન (Android/iOS)',
        'Stable Internet Connection': 'સ્થિર ઇન્ટરનેટ કનેક્શન',
        'Quiet Space for Consultations': 'સલાહ માટે શાંત જગ્યા',
        'PC / Desktop Setup for Professional Calls': 'વ્યાવસાયિક કોલ્સ માટે PC / ડેસ્કટોપ સેટઅપ',
        'I agree to the': 'હું સંમત છું',
        'Terms & Conditions': 'નિયમો અને શરતો',
        'and': 'અને',
        'Privacy Policy': 'ગોપનીયતા નીતિ',
        'I agree to the <a href=\'#\' onclick=\'showTerms(event)\'>Terms & Conditions</a> and <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>Privacy Policy</a>': 'હું <a href=\'#\' onclick=\'showTerms(event)\'>નિયમો અને શરતો</a> અને <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>ગોપનીયતા નીતિ</a>ને સ્વીકારું છું',
    },
    kn: {
        // Header
        'PanditTalk Network': 'ಪಂಡಿತ್ ಟಾಕ್ ನೆಟ್‌ವರ್ಕ್',
        'Join India\'s Fastest Growing Astrologer Community': 'ಭಾರತದ ಅತ್ಯಂತ ವೇಗವಾಗಿ ಬೆಳೆಯುತ್ತಿರುವ ಜ್ಯೋತಿಷ್ಯ ಸಮುದಾಯಕ್ಕೆ ಸೇರಿ',
        'Complete this verified onboarding form to get listed on PanditTalk, access thousands of seekers, and grow your spiritual practice with guaranteed payments.': 'ಪಂಡಿತ್ ಟಾಕ್‌ನಲ್ಲಿ ಪಟ್ಟಿ ಮಾಡಲು, ಸಾವಿರಾರು ಅನ್ವೇಷಕರಿಗೆ ಪ್ರವೇಶ ಪಡೆಯಲು ಮತ್ತು ಖಾತರಿ ಪಾವತಿಗಳೊಂದಿಗೆ ನಿಮ್ಮ ಆಧ್ಯಾತ್ಮಿಕ ಅಭ್ಯಾಸವನ್ನು ಬೆಳೆಸಲು ಈ ಪರಿಶೀಲಿಸಿದ ಆನ್‌ಬೋರ್ಡಿಂಗ್ ಫಾರ್ಮ್ ಅನ್ನು ಪೂರ್ಣಗೊಳಿಸಿ.',
        '← Back to Landing Page': '← ಲ್ಯಾಂಡಿಂಗ್ ಪುಟಕ್ಕೆ ಹಿಂದಿರುಗಿ',
        'English': 'ಇಂಗ್ಲಿಷ್ (English)',
        'Hindi': 'ಹಿಂದಿ (Hindi)',
        'Marathi': 'ಮರಾಠಿ (Marathi)',
        'Telugu': 'ತೆಲುಗು (Telugu)',
        'Gujarati': 'ಗುಜರಾತಿ (Gujarati)',
        'Kannada': 'ಕನ್ನಡ (Kannada)',
        // Form Headers
        'Official Onboarding Form': 'ಅಧಿಕೃತ ಆನ್‌ಬೋರ್ಡಿಂಗ್ ಫಾರ್ಮ್',
        'Pandit / Astrologer Registration': 'ಪಂಡಿತ್ / ಜ್ಯೋತಿಷ್ಯ ನೋಂದಣಿ',
        'Only approved profiles go live on the PanditTalk app.': 'ಅನುಮೋದಿಸಿದ ಪ್ರೊಫೈಲ್‌ಗಳು ಮಾತ್ರ ಪಂಡಿತ್ ಟಾಕ್ ಅಪ್ಲಿಕೇಶನ್‌ನಲ್ಲಿ ಲೈವ್ ಆಗುತ್ತವೆ.',
        'Personal Information': 'ವೈಯಕ್ತಿಕ ಮಾಹಿತಿ',
        'Professional Details': 'ವೃತ್ತಿಪರ ವಿವರಗಳು',
        'Availability & Preference': 'ಲಭ್ಯತೆ ಮತ್ತು ಆದ್ಯತೆ',
        'Bank Details (For Payments)': 'ಬ್ಯಾಂಕ್ ವಿವರಗಳು (ಪಾವತಿಗಳಿಗಾಗಿ)',
        'About You': 'ನಿಮ್ಮ ಬಗ್ಗೆ',
        'Identity Verification': 'ಗುರುತಿನ ಪರಿಶೀಲನೆ',
        'Technical Setup': 'ತಾಂತ್ರಿಕ ಸೆಟಪ್',
        'Additional Information': 'ಹೆಚ್ಚುವರಿ ಮಾಹಿತಿ',
        // Labels
        'Full Name *': 'ಪೂರ್ಣ ಹೆಸರು *',
        'Phone Number *': 'ಫೋನ್ ಸಂಖ್ಯೆ *',
        'Email Address *': 'ಇಮೇಲ್ ವಿಳಾಸ *',
        'Date of Birth *': 'ಜನ್ಮ ದಿನಾಂಕ *',
        'Gender *': 'ಲಿಂಗ *',
        'State *': 'ರಾಜ್ಯ *',
        'Full Address *': 'ಪೂರ್ಣ ವಿಳಾಸ *',
        'Main Specialization *': 'ಮುಖ್ಯ ಪರಿಣತಿ *',
        'Other Services Offered': 'ಇತರೆ ಸೇವೆಗಳು',
        'Total Experience (Years) *': 'ಒಟ್ಟು ಅನುಭವ (ವರ್ಷಗಳು) *',
        'Educational Qualification (Optional)': 'ಶೈಕ್ಷಣಿಕ ಅರ್ಹತೆ (ಐಚ್ಛಿಕ)',
        'Languages Known *': 'ತಿಳಿದಿರುವ ಭಾಷೆಗಳು *',
        'Professional Certifications/Awards': 'ವೃತ್ತಿಪರ ಪ್ರಮಾಣಪತ್ರಗಳು/ಪುರಸ್ಕಾರಗಳು',
        'Preferred Working Days *': 'ಆದ್ಯತೆಯ ಕೆಲಸದ ದಿನಗಳು *',
        'Preferred Working Hours *': 'ಆದ್ಯತೆಯ ಕೆಲಸದ ಗಂಟೆಗಳು *',
        'Expected Weekly Hours *': 'ನಿರೀಕ್ಷಿತ ವಾರಕ್ಕೆ ಗಂಟೆಗಳು *',
        'Account Holder Name *': 'ಖಾತೆ ಹೊಂದಿರುವವರ ಹೆಸರು *',
        'Bank Account Number *': 'ಬ್ಯಾಂಕ್ ಖಾತೆ ಸಂಖ್ಯೆ *',
        'IFSC Code *': 'IFSC ಕೋಡ್ *',
        'Bank Name *': 'ಬ್ಯಾಂಕ್ ಹೆಸರು *',
        'PAN Card Number *': 'PAN ಕಾರ್ಡ್ ಸಂಖ್ಯೆ *',
        'Professional Bio (max 1000 characters) *': 'ವೃತ್ತಿಪರ ಜೀವನಚರಿತ್ರೆ (ಗರಿಷ್ಠ 1000 ಅಕ್ಷರಗಳು) *',
        'Notable Achievements/Recognition': 'ಗಮನಾರ್ಹ ಸಾಧನೆಗಳು/ಗುರುತಿಸುವಿಕೆ',
        'Upload Government ID Proof (Aadhaar / PAN / Voter ID) *': 'ಸರ್ಕಾರಿ ID ಪುರಾವೆ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ (ಆಧಾರ್ / PAN / ಮತದಾರ ID) *',
        'Upload Your Recent Photo *': 'ನಿಮ್ಮ ಇತ್ತೀಚಿನ ಫೋಟೋವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ *',
        'Do you have access to the following? *': 'ನಿಮಗೆ ಈ ಕೆಳಗಿನವುಗಳಿಗೆ ಪ್ರವೇಶವಿದೆಯೇ? *',
        'How did you hear about PanditTalk? *': 'ನೀವು ಪಂಡಿತ್ ಟಾಕ್ ಬಗ್ಗೆ ಹೇಗೆ ಕೇಳಿದಿರಿ? *',
        'Additional Comments/Questions': 'ಹೆಚ್ಚುವರಿ ಕಾಮೆಂಟ್‌ಗಳು/ಪ್ರಶ್ನೆಗಳು',
        // Placeholders
        'Enter your full legal name': 'ನಿಮ್ಮ ಪೂರ್ಣ ಕಾನೂನುಬದ್ಧ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
        '10-digit mobile number': '10 ಅಂಕಿಯ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ',
        'your.email@example.com': 'ನಿಮ್ಮ.ಇಮೇಲ್@ಉದಾಹರಣೆ.com',
        'e.g., Maharashtra': 'ಉದಾ: ಮಹಾರಾಷ್ಟ್ರ',
        'Complete address with pin code': 'ಪಿನ್ ಕೋಡ್‌ನೊಂದಿಗೆ ಪೂರ್ಣ ವಿಳಾಸ',
        'Select Your Main Expertise': 'ನಿಮ್ಮ ಮುಖ್ಯ ಪರಿಣತಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
        'e.g., Marriage Counseling, Career Guidance': 'ಉದಾ: ವಿವಾಹ ಸಲಹೆ, ವೃತ್ತಿ ಮಾರ್ಗದರ್ಶನ',
        'Years of practice': 'ಅಭ್ಯಾಸದ ವರ್ಷಗಳು',
        'e.g., B.A., M.A., Ph.D.': 'ಉದಾ: B.A., M.A., Ph.D.',
        'e.g., Hindi, English, Marathi, Sanskrit': 'ಉದಾ: ಹಿಂದಿ, ಇಂಗ್ಲೀಷ್, ಮರಾಠಿ, ಸಂಸ್ಕೃತ',
        'Select Hours per Week': 'ವಾರಕ್ಕೆ ಗಂಟೆಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ',
        'As per bank records': 'ಬ್ಯಾಂಕ್ ದಾಖಲೆಗಳ ಪ್ರಕಾರ',
        'Account number': 'ಖಾತೆ ಸಂಖ್ಯೆ',
        'e.g., SBIN0001234': 'ಉದಾ: SBIN0001234',
        'e.g., State Bank of India': 'ಉದಾ: ಭಾರತೀಯ ಸ್ಟೇಟ್ ಬ್ಯಾಂಕ್',
        'e.g., ABCDE1234F': 'ಉದಾ: ABCDE1234F',
        'Tell us about your expertise, specialties, approach to consultations, and what makes you unique...': 'ನಿಮ್ಮ ಪರಿಣತಿ, ವಿಶೇಷತೆಗಳು, ಸಲಹೆಗಳಿಗೆ ವಿಧಾನ ಮತ್ತು ನಿಮ್ಮನ್ನು ವಿಶಿಷ್ಟವಾಗಿ ಮಾಡುವುದು ಬಗ್ಗೆ ನಮಗೆ ತಿಳಿಸಿ...',
        'Awards, media features, notable clients (optional)': 'ಪುರಸ್ಕಾರಗಳು, ಮೀಡಿಯಾ ಲಕ್ಷಣಗಳು, ಗಮನಾರ್ಹ ಗ್ರಾಹಕರು (ಐಚ್ಛಿಕ)',
        'Any specific requirements, questions, or information you\'d like to share...': 'ನೀವು ಹಂಚಿಕೊಳ್ಳಲು ಬಯಸುವ ಯಾವುದೇ ನಿರ್ದಿಷ್ಟ ಅವಶ್ಯಕತೆಗಳು, ಪ್ರಶ್ನೆಗಳು ಅಥವಾ ಮಾಹಿತಿ...',
        // Options
        'Select Gender': 'ಲಿಂಗವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
        'Male': 'ಪುರುಷ',
        'Female': 'ಸ್ತ್ರೀ',
        'Other': 'ಇತರೆ',
        'Select Option': 'ಆಯ್ಕೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
        'Monday': 'ಸೋಮವಾರ',
        'Tuesday': 'ಮಂಗಳವಾರ',
        'Wednesday': 'ಬುಧವಾರ',
        'Thursday': 'ಗುರುವಾರ',
        'Friday': 'ಶುಕ್ರವಾರ',
        'Saturday': 'ಶನಿವಾರ',
        'Sunday': 'ಭಾನುವಾರ',
        'Morning (6AM-12PM)': 'ಬೆಳಿಗ್ಗೆ (6AM-12PM)',
        'Afternoon (12PM-6PM)': 'ಮಧ್ಯಾಹ್ನ (12PM-6PM)',
        'Evening (6PM-12AM)': 'ಸಂಜೆ (6PM-12AM)',
        'Night (12AM-6AM)': 'ರಾತ್ರಿ (12AM-6AM)',
        'Less than 10 hours': '10 ಗಂಟೆಗಳಿಗಿಂತ ಕಡಿಮೆ',
        '10-20 hours': '10-20 ಗಂಟೆಗಳು',
        '20-30 hours': '20-30 ಗಂಟೆಗಳು',
        '30-40 hours': '30-40 ಗಂಟೆಗಳು',
        '40+ hours (Full-time)': '40+ ಗಂಟೆಗಳು (ಪೂರ್ಣ ಸಮಯ)',
        'Google Search': 'Google ಹುಡುಕಾಟ',
        'Social Media (Facebook/Instagram)': 'ಸಾಮಾಜಿಕ ಮಾಧ್ಯಮ (Facebook/Instagram)',
        'Friend/Family Referral': 'ಸ್ನೇಹಿತ/ಕುಟುಂಬ ಉಲ್ಲೇಖ',
        'Advertisement': 'ಜಾಹೀರಾತು',
        'Another Pandit': 'ಮತ್ತೊಂದು ಪಂಡಿತ್',
        // Buttons
        'Cancel': 'ರದ್ದುಮಾಡಿ',
        'Submit Registration': 'ನೋಂದಣಿಯನ್ನು ಸಲ್ಲಿಸಿ',
        // Helper text
        'Skip if you don\'t have a formal degree': 'ನೀವು ಔಪಚಾರಿಕ ಪದವಿ ಹೊಂದಿಲ್ಲದಿದ್ದರೆ ಬಿಟ್ಟುಬಿಡಿ',
        'This will be shown to users on your profile': 'ಇದು ನಿಮ್ಮ ಪ್ರೊಫೈಲ್‌ನಲ್ಲಿ ಬಳಕೆದಾರರಿಗೆ ತೋರಿಸಲಾಗುತ್ತದೆ',
        'Accepted formats: JPG, PNG, PDF (Max 5MB)': 'ಸ್ವೀಕರಿಸಿದ ಸ್ವರೂಪಗಳು: JPG, PNG, PDF (ಗರಿಷ್ಠ 5MB)',
        'Document must be clear and readable': 'ದಾಖಲೆಯು ಸ್ಪಷ್ಟ ಮತ್ತು ಓದಬಲ್ಲದಾಗಿರಬೇಕು',
        'Clear, front-facing photo': 'ಸ್ಪಷ್ಟ, ಮುಂಭಾಗದ ಫೋಟೋ',
        'Professional attire preferred': 'ವೃತ್ತಿಪರ ಉಡುಗೆ ಆದ್ಯತೆ',
        'Smartphone (Android/iOS)': 'ಸ್ಮಾರ್ಟ್‌ಫೋನ್ (Android/iOS)',
        'Stable Internet Connection': 'ಸ್ಥಿರ ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕ',
        'Quiet Space for Consultations': 'ಸಲಹೆಗಳಿಗಾಗಿ ಶಾಂತ ಸ್ಥಳ',
        'PC / Desktop Setup for Professional Calls': 'ವೃತ್ತಿಪರ ಕರೆಗಳಿಗಾಗಿ PC / ಡೆಸ್ಕ್‌ಟಾಪ್ ಸೆಟಪ್',
        'I agree to the': 'ನಾನು ಒಪ್ಪುತ್ತೇನೆ',
        'Terms & Conditions': 'ನಿಯಮಗಳು ಮತ್ತು ಷರತ್ತುಗಳು',
        'and': 'ಮತ್ತು',
        'Privacy Policy': 'ಗೌಪ್ಯತೆ ನೀತಿ',
        'I agree to the <a href=\'#\' onclick=\'showTerms(event)\'>Terms & Conditions</a> and <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>Privacy Policy</a>': 'ನಾನು <a href=\'#\' onclick=\'showTerms(event)\'>ನಿಯಮಗಳು ಮತ್ತು ಷರತ್ತುಗಳು</a> ಮತ್ತು <a href=\'#\' onclick=\'showPrivacyPolicy(event)\'>ಗೌಪ್ಯತೆ ನೀತಿ</a> ಗೆ ಒಪ್ಪುತ್ತೇನೆ',
    }
};

function changeLanguage(lang) {
    if (!supportedLanguages.includes(lang)) {
        console.warn('Unsupported language:', lang);
        return;
    }
    currentLanguage = lang;
    localStorage.setItem('panditFormLanguage', currentLanguage);
    
    // Update language selector
    const langSelect = document.getElementById('languageSelect');
    if (langSelect) {
        langSelect.value = lang;
    }
    
    updateLanguage();
}

function translate(key) {
    if (!key) return '';
    return translations[currentLanguage]?.[key] 
        || translations['en']?.[key] 
        || key;
}

function updateLanguage() {
    // Update text-only elements
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        const translated = translate(key);
        if (el.tagName === 'LABEL') {
            const hasAsterisk = key.trim().endsWith('*');
            el.textContent = translated + (hasAsterisk && !translated.trim().endsWith('*') ? ' *' : '');
        } else if (el.tagName === 'OPTION' || el.tagName === 'BUTTON' || el.tagName === 'H1' || el.tagName === 'H2' || el.tagName === 'H3' || el.tagName === 'P' || el.tagName === 'SPAN' || el.tagName === 'DIV') {
            el.textContent = translated;
        } else {
            el.textContent = translated;
        }
    });
    
    // Update HTML content elements
    document.querySelectorAll('[data-i18n-html]').forEach(el => {
        const key = el.getAttribute('data-i18n-html');
        el.innerHTML = translate(key);
    });
    
    // Update placeholders
    document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
        const key = el.getAttribute('data-i18n-placeholder');
        const translated = translate(key);
        if (translated) {
            el.placeholder = translated;
        }
    });
    
    // Update checkbox labels using translations
    document.querySelectorAll('.checkbox-group label').forEach(label => {
        const checkbox = label.querySelector('input[type="checkbox"]');
        if (checkbox) {
            const value = checkbox.value;
            const translation = translations[currentLanguage] && translations[currentLanguage][value] 
                ? translations[currentLanguage][value] 
                : value;
            label.innerHTML = checkbox.outerHTML + ' ' + translation;
        }
    });
    
    // Update helper text (including HTML content)
    document.querySelectorAll('.helper-text').forEach(el => {
        const text = el.getAttribute(dataAttr) || el.getAttribute('data-en');
        if (text) {
            el.innerHTML = text;
        } else {
            const originalText = el.textContent.trim();
            if (translations[currentLanguage] && translations[currentLanguage][originalText]) {
                el.textContent = translations[currentLanguage][originalText];
            }
        }
    });
    
    // Update terms text
    const termsText = document.getElementById('termsText');
    if (termsText) {
        const termsLabel = termsText.closest('.checkbox-label');
        if (termsLabel) {
            const text = termsLabel.getAttribute(dataAttr) || termsLabel.getAttribute('data-en');
            if (text) {
                termsText.innerHTML = text;
            }
        }
    }
    
    // Update buttons
    document.querySelectorAll('button[data-en]').forEach(btn => {
        const text = btn.getAttribute(dataAttr) || btn.getAttribute('data-en');
        if (text) {
            btn.textContent = text;
        }
    });
    
    // Apply appropriate font based on language
    const fontMap = {
        'en': '"Poppins", sans-serif',
        'hi': '"Noto Sans Devanagari", "Poppins", sans-serif',
        'mr': '"Noto Sans Devanagari", "Poppins", sans-serif',
        'te': '"Noto Sans Telugu", "Poppins", sans-serif',
        'gu': '"Noto Sans Gujarati", "Poppins", sans-serif',
        'kn': '"Noto Sans Kannada", "Poppins", sans-serif'
    };
    document.body.style.fontFamily = fontMap[currentLanguage] || fontMap['en'];
}

// Initialize language on page load
document.addEventListener('DOMContentLoaded', function() {
    // Set language selector to current language
    const langSelect = document.getElementById('languageSelect');
    if (langSelect) {
        langSelect.value = currentLanguage;
    }
    updateLanguage();
});

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



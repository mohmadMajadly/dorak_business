class LocalizationService {
  static Map<String, Map<String, String>> translations = {
    "en": {
      "step_label": "Step {step}/3",
      "create_account": "Create Account",
      "basic_info_desc": "Let's start with your basic information",
      "password_desc": "Create a secure password",
      "details_desc": "Just a few more details",
      "continue": "Continue",
      "back": "Back",
      "full_name": "Full Name",
      "email": "Email (Optional)",
      "password": "Password",
      "confirm_password": "Confirm Password",
      "date_of_birth": "Date of Birth",
      "gender": "Gender",
      "male": "Male",
      "female": "Female",
      "terms_intro": "I agree to the",
      "terms_and_conditions": "Terms & Conditions",
      "name_required": "Please enter your full name",
      "email_invalid": "Please enter a valid email address",
      "password_required": "Please enter a password",
      "password_length": "Password must be at least 6 characters",
      "passwords_mismatch": "Passwords do not match",
      "registration_success": "Registration Successful!",
      "account_created": "Your account has been created successfully.",
      "select_year": "Please select your birth",
      "select_gender": "Please select your gender",
      "select_date": "Please chose your birth day",
      "accept_terms": "Please accept the terms and conditions",
      "username": "Username",
      "username_required": "Please enter a username",
      "username_taken": "This username is already taken",
      "checking_username": "Checking username availability...",
      'registration_failed': 'Registration Failed',
      'try_again_later': 'Please try again later.',
      'ok': 'OK',
      'no_internet': 'No Internet Connection',
      'server_error': 'Server Error',
      'connection_timeout': 'Connection Timeout',
      'connection_error': 'Connection Error',
      'try_again': 'Try Again',
      'cancel': 'Cancel',
    },
    'ar': {
      'step_label': 'الخطوة {step}/3',
      'create_account': 'إنشاء حساب',
      'basic_info_desc': 'لنبدأ بمعلوماتك الأساسية',
      'password_desc': 'قم بإنشاء كلمة مرور آمنة',
      'details_desc': 'بعض التفاصيل الإضافية',
      'continue': 'متابعة',
      'back': 'رجوع',
      'full_name': 'الاسم الكامل',
      'email': 'البريد الإلكتروني (اختياري)',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'date_of_birth': 'تاريخ الميلاد',
      'gender': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'terms_intro': 'أوافق على',
      'terms_and_conditions': 'الشروط والأحكام',
      'name_required': 'الرجاء إدخال الاسم الكامل',
      'email_invalid': 'الرجاء إدخال بريد إلكتروني صحيح',
      'password_required': 'الرجاء إدخال كلمة المرور',
      'password_length': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      'passwords_mismatch': 'كلمات المرور غير متطابقة',
      'registration_success': 'تم التسجيل بنجاح!',
      'account_created': 'تم إنشاء حسابك بنجاح.',
      "select_year": "يرجى تحديد سنة ميلادك",
      'select_date': 'الرجاء اختيار تاريخ الميلاد',
      'select_gender': 'الرجاء اختيار الجنس',
      'accept_terms': 'الرجاء الموافقة على الشروط والأحكام',
      'username': 'اسم المستخدم',
      'username_required': 'الرجاء إدخال اسم المستخدم',
      'username_taken': 'اسم المستخدم مستخدم بالفعل',
      'checking_username': 'جاري التحقق من توفر اسم المستخدم...',
      'january': 'يناير',
      'february': 'فبراير',
      'march': 'مارس',
      'april': 'أبريل',
      'may': 'مايو',
      'june': 'يونيو',
      'july': 'يوليو',
      'august': 'أغسطس',
      'september': 'سبتمبر',
      'october': 'أكتوبر',
      'november': 'نوفمبر',
      'december': 'ديسمبر',
      'registration_failed': 'فشل التسجيل',
      'try_again_later': 'يرجى المحاولة مرة أخرى لاحقًا',
      'ok': 'موافق',
      'no_internet': 'لا يوجد اتصال بالإنترنت',
      'server_error': 'خطأ في الخادم',
      'connection_timeout': 'انتهت مهلة الاتصال',
      'connection_error': 'خطأ في الاتصال',
      'try_again': 'حاول مرة أخرى',
      'cancel': 'إلغاء',
    },
    'he': {
      'step_label': 'שלב {step}/3',
      'create_account': 'צור חשבון',
      'basic_info_desc': 'בוא נתחיל עם המידע הבסיסי שלך',
      'password_desc': 'צור סיסמה מאובטחת',
      'details_desc': 'עוד כמה פרטים',
      'continue': 'המשך',
      'back': 'חזור',
      'full_name': 'שם מלא',
      'email': 'אימייל (אופציונלי)',
      'password': 'סיסמה',
      'confirm_password': 'אשר סיסמה',
      'date_of_birth': 'תאריך לידה',
      'gender': 'מגדר',
      'male': 'זכר',
      'female': 'נקבה',
      'terms_intro': 'אני מסכים ל',
      'terms_and_conditions': 'תנאים והגבלות',
      'name_required': 'אנא הכנס שם מלא',
      'email_invalid': 'אנא הכנס כתובת אימייל תקינה',
      'password_required': 'אנא הכנס סיסמה',
      'password_length': 'הסיסמה חייבת להכיל לפחות 6 תווים',
      'passwords_mismatch': 'הסיסמאות אינן תואמות',
      'registration_success': 'ההרשמה הושלמה בהצלחה!',
      'account_created': 'החשבון שלך נוצר בהצלחה.',
      'select_date': 'אנא בחר תאריך לידה',
      'select_year': 'אנא בחר את שנת הלידה שלך',
      'select_gender': 'אנא בחר מגדר',
      'accept_terms': 'אנא אשר את התנאים וההגבלות',
      'username': 'שם משתמש',
      'username_required': 'אנא הכנס שם משתמש',
      'username_taken': 'שם משתמש זה כבר תפוס',
      'checking_username': 'בודק זמינות שם משתמש...',
      'january': 'ינואר',
      'february': 'פברואר',
      'march': 'מרץ',
      'april': 'אפריל',
      'may': 'מאי',
      'june': 'יוני',
      'july': 'יולי',
      'august': 'אוגוסט',
      'september': 'ספטמבר',
      'october': 'אוקטובר',
      'november': 'נובמבר',
      'december': 'דצמבר',
      'registration_failed': 'ההרשמה נכשלה',
      'try_again_later': 'אנא נסה שוב מאוחר יותר',
      'ok': 'אישור',
      'no_internet': 'אין חיבור לאינטרנט',
      'server_error': 'שגיאת שרת',
      'connection_timeout': 'פסק זמן חיבור',
      'connection_error': 'שגיאת חיבור',
      'try_again': 'נסה שוב',
      'cancel': 'ביטול',
    },
  };

  /// Gets the localized text for a given key and language code
  static String getLocalizedText(String key, String languageCode) {
    return translations[languageCode]?[key] ?? key;
  }
}
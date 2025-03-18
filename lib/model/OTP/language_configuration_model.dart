class LanguageConfigurationModel {
  final String languageCode;
  final bool isRightToLeft;
  final Map<String, String> translations;

  const LanguageConfigurationModel({
    required this.languageCode,
    required this.isRightToLeft,
    required this.translations,
  });

  static const Map<String, LanguageConfigurationModel> supportedLanguages = {
    'en': LanguageConfigurationModel(
      languageCode: 'en',
      isRightToLeft: false,
      translations: {
        'verifyPhoneNumber': 'Verify your\nphone number',
        'enterOneTimePassword': 'Enter OTP',
        'willSendVerificationCode': "We'll send you a verification code",
        'enterVerificationCode': 'Please enter the verification code',
        'phoneNumberLabel': 'Phone number',
        'sendVerificationCode': 'Send Code',
        'noCodeReceived': "Didn't receive the code?",
        'resendCode': 'Resend',
        'successMessage': 'Success!',
        'verificationSuccessMessage': 'Your phone number has been verified successfully',
        'continueButton': 'Continue',
        'selectCountryLabel': 'Select Country',
        'changePhoneNumber': 'Change Number',
        'codeResentMessage': 'Code resent successfully',
        'invalidPhoneNumber': 'Please enter a valid phone number',
        'verificationFailed': 'Verification failed. Please try again.',
        'retryButton': 'Retry',
        'verificationFailedRetryMessage':
        'Verification failed. Please try again or resend the code.',
      },
    ),
    'ar': LanguageConfigurationModel(
      languageCode: 'ar',
      isRightToLeft: true,
      translations: {
        'verifyPhoneNumber': 'تحقق من\nرقم هاتفك',
        'enterOneTimePassword': 'أدخل رمز التحقق',
        'willSendVerificationCode': 'سنرسل لك رمز التحقق',
        'enterVerificationCode': 'الرجاء إدخال رمز التحقق',
        'phoneNumberLabel': 'رقم الهاتف',
        'sendVerificationCode': 'إرسال الرمز',
        'noCodeReceived': 'لم تتلق الرمز؟',
        'resendCode': 'إعادة الإرسال',
        'successMessage': 'تم بنجاح!',
        'verificationSuccessMessage': 'تم التحقق من رقم هاتفك بنجاح',
        'continueButton': 'متابعة',
        'selectCountryLabel': 'اختر الدولة',
        'changePhoneNumber': 'تغيير الرقم',
        'codeResentMessage': 'تم إعادة إرسال الرمز بنجاح',
        'invalidPhoneNumber': 'الرجاء إدخال رقم هاتف صحيح',
        'verificationFailed': 'فشل التحقق. حاول مرة اخرى.',
        'retryButton': 'إعادة المحاولة',
        'verificationFailedRetryMessage':
        'فشل التحقق. يرجى المحاولة مرة أخرى أو إعادة إرسال الرمز.',
      },
    ),
    'he': LanguageConfigurationModel(
      languageCode: 'he',
      isRightToLeft: true,
      translations: {
        'verifyPhoneNumber': 'אמת את\nמספר הטלפון שלך',
        'enterOneTimePassword': 'הזן קוד חד פעמי',
        'willSendVerificationCode': "נשלח לך קוד אימות",
        'enterVerificationCode': 'אנא הזן את קוד האימות',
        'phoneNumberLabel': 'מספר טלפון',
        'sendVerificationCode': 'שלח קוד',
        'noCodeReceived': "לא קיבלת את הקוד?",
        'resendCode': 'שלח שוב',
        'successMessage': 'הצלחה!',
        'verificationSuccessMessage': 'מספר הטלפון שלך אומת בהצלחה',
        'continueButton': 'המשך',
        'selectCountryLabel': 'בחר מדינה',
        'changePhoneNumber': 'שנה מספר',
        'codeResentMessage': 'הקוד נשלח שוב בהצלחה',
        'invalidPhoneNumber': 'אנא הזן מספר טלפון תקין',
        'verificationFailed': 'האימות נכשל. אנא נסה שוב.',
        'retryButton': 'נסה שוב',
        'verificationFailedRetryMessage':
        'האימות נכשל. אנא נסה שוב או שלח את הקוד מחדש.',
      },
    ),
  };
}
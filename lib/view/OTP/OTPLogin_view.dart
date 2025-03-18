import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Phone Number Formatter
class PhoneNumberFormatter extends TextInputFormatter {
  final String format;

  PhoneNumberFormatter({required this.format});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final formattedValue = _formatPhoneNumber(digitsOnly);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatPhoneNumber(String digits) {
    var formatted = '';
    var index = 0;
    for (var i = 0; i < format.length && index < digits.length; i++) {
      if (format[i] == 'X') {
        formatted += digits[index];
        index++;
      } else {
        formatted += format[i];
      }
    }
    return formatted;
  }
}

// Language Configuration
class LanguageConfig {
  final String languageCode;
  final bool isRTL;
  final Map<String, String> translations;

  const LanguageConfig({
    required this.languageCode,
    required this.isRTL,
    required this.translations,
  });

  static const Map<String, LanguageConfig> supportedLanguages = {
    'en': LanguageConfig(
      languageCode: 'en',
      isRTL: false,
      translations: {
        'verifyPhone': 'Verify your\nphone number',
        'enterOTP': 'Enter OTP',
        'willSendCode': "We'll send you a verification code",
        'enterVerificationCode': 'Please enter the verification code',
        'phoneNumber': 'Phone number',
        'sendCode': 'Send Code',
        'didntReceiveCode': "Didn't receive the code?",
        'resend': 'Resend',
        'success': 'Success!',
        'verificationSuccess':
            'Your phone number has been verified successfully',
        'continue': 'Continue',
        'selectCountry': 'Select Country',
        'changeNumber': 'Change Number',
        'codeResent': 'Code resent successfully',
        'invalidPhone': 'Please enter a valid phone number',
        'verificationFailed': 'Verification failed. Please try again.',
        'retry': 'Retry',
        'verificationFailedRetry':
            'Verification failed. Please try again or resend the code.',
      },
    ),
    'ar': LanguageConfig(
      languageCode: 'ar',
      isRTL: true,
      translations: {
        'verifyPhone': 'تحقق من\nرقم هاتفك',
        'enterOTP': 'أدخل رمز التحقق',
        'willSendCode': 'سنرسل لك رمز التحقق',
        'enterVerificationCode': 'الرجاء إدخال رمز التحقق',
        'phoneNumber': 'رقم الهاتف',
        'sendCode': 'إرسال الرمز',
        'didntReceiveCode': 'لم تتلق الرمز؟',
        'resend': 'إعادة الإرسال',
        'success': 'تم بنجاح!',
        'verificationSuccess': 'تم التحقق من رقم هاتفك بنجاح',
        'continue': 'متابعة',
        'selectCountry': 'اختر الدولة',
        'changeNumber': 'تغيير الرقم',
        'codeResent': 'تم إعادة إرسال الرمز بنجاح',
        'invalidPhone': 'الرجاء إدخال رقم هاتف صحيح',
        'verificationFailed': 'فشل التحقق. حاول مرة اخرى.',
        'retry': 'إعادة المحاولة',
        'verificationFailedRetry':
            'فشل التحقق. يرجى المحاولة مرة أخرى أو إعادة إرسال الرمز.',
      },
    ),
    'he': LanguageConfig(
      languageCode: 'he',
      isRTL: true,
      translations: {
        'verifyPhone': 'אמת את\nמספר הטלפון שלך',
        'enterOTP': 'הזן קוד אימות',
        'willSendCode': 'נשלח לך קוד אימות',
        'enterVerificationCode': 'אנא הזן את קוד האימות',
        'phoneNumber': 'מספר טלפון',
        'sendCode': 'שלח קוד',
        'didntReceiveCode': 'לא קיבלת את הקוד?',
        'resend': 'שלח שוב',
        'success': 'הצלחה!',
        'verificationSuccess': 'מספר הטלפון שלך אומת בהצלחה',
        'continue': 'המשך',
        'selectCountry': 'בחר מדינה',
        'changeNumber': 'שנה מספר',
        'codeResent': 'הקוד נשלח מחדש בהצלחה',
        'invalidPhone': 'אנא הזן מספר טלפון תקין',
        'verificationFailed': 'האימות נכשל. בבקשה נסה שוב.',
        'retry': 'נסה שוב',
        'verificationFailedRetry':
            'האימות נכשל. אנא נסה שוב או שלח מחדש את הקוד.',
      },
    ),
  };
}

// Country Code Model
class CountryCode {
  final String name;
  final String dialCode;
  final String format;

  const CountryCode({
    required this.name,
    required this.dialCode,
    required this.format,
  });
}

// Main Widget
class PhoneVerificationPage extends StatefulWidget {
  final String languageCode;

  const PhoneVerificationPage({
    super.key,
    required this.languageCode,
  });

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late LanguageConfig _languageConfig;

  bool _isPhoneValid = false;
  bool _showOTP = false;
  String? _errorText;

  final List<CountryCode> _countryCodes = const [
    CountryCode(
      name: 'United States',
      dialCode: '+1',
      format: 'XXX-XXX-XXXX',
    ),
    CountryCode(
      name: 'United Kingdom',
      dialCode: '+44',
      format: 'XXXX-XXX-XXX',
    ),
    CountryCode(
      name: 'India',
      dialCode: '+91',
      format: 'XXXXX-XXXXX',
    ),
    CountryCode(
      name: 'Canada',
      dialCode: '+1',
      format: 'XXX-XXX-XXXX',
    ),
    CountryCode(
      name: 'Australia',
      dialCode: '+61',
      format: 'XXX-XXX-XXX',
    ),
    CountryCode(
      name: 'Israel',
      dialCode: '+972',
      format: 'XXX-XXX-XXXX',
    ),
    CountryCode(
      name: 'Saudi Arabia',
      dialCode: '+966',
      format: 'XXX-XXX-XXXX',
    ),
    CountryCode(
      name: 'UAE',
      dialCode: '+971',
      format: 'XXX-XXX-XXXX',
    ),
  ];

  late CountryCode _selectedCountry;

  @override
  void initState() {
    super.initState();
    _languageConfig = LanguageConfig.supportedLanguages[widget.languageCode] ??
        LanguageConfig.supportedLanguages['en']!;
    _selectedCountry = _countryCodes[0];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    final phoneNumber = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    setState(() {
      _isPhoneValid = phoneNumber.length >= 10;
      _errorText =
          _isPhoneValid ? null : _languageConfig.translations['invalidPhone'];
    });
  }

  // Find the last filled node
  int _findLastFilledNodeIndex() {
    for (int i = _otpControllers.length - 1; i >= 0; i--) {
      if (_otpControllers[i].text.isNotEmpty) {
        return i + 1;
      }
    }
    return 0;
  }

  // Handle focus changes
  void _handleFocusChange(int index) {
    if (_otpControllers[index].text.isEmpty) {
      final lastFilledIndex = _findLastFilledNodeIndex();
      if (lastFilledIndex < _otpControllers.length) {
        _otpFocusNodes[lastFilledIndex].requestFocus();
      } else {
        _otpFocusNodes[0].requestFocus();
      }
    }
  }

  // Verify OTP
  Future<bool> _verifyOTP(String otp) async {
    // TODO: Replace with actual API call
    // For now, always return true as specified
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return true;
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Directionality(
        textDirection:
            _languageConfig.isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _languageConfig.translations['selectCountry']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1F71),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _countryCodes.length,
                  itemBuilder: (context, index) {
                    final country = _countryCodes[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCountry = country;
                          _phoneController.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedCountry == country
                              ? Colors.blue.shade50
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              country.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              country.dialCode,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmitPhone() {
    setState(() {
      _showOTP = true;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Directionality(
        textDirection:
            _languageConfig.isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red.shade600,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  _languageConfig.translations['verificationFailedRetry']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Clear OTP fields
                          for (var controller in _otpControllers) {
                            controller.clear();
                          }
                          // Focus on first field
                          _otpFocusNodes[0].requestFocus();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _languageConfig.translations['retry']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Clear OTP fields
                          for (var controller in _otpControllers) {
                            controller.clear();
                          }
                          // Show resend confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(_languageConfig
                                        .translations['codeResent']!),
                                  ],
                                ),
                              ),
                              backgroundColor: Colors.green.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: Colors.blue.shade200,
                        ),
                        child: Text(
                          _languageConfig.translations['resend']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Verify OTP
    final success = await _verifyOTP(otp);

    // Remove loading indicator
    Navigator.of(context).pop();

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Directionality(
          textDirection:
              _languageConfig.isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _languageConfig.translations['success']!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1F71),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _languageConfig.translations['verificationSuccess']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _showOTP = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: Colors.green.shade200,
                      ),
                      child: Text(
                        _languageConfig.translations['continue']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      _showFailureDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          _languageConfig.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    if (!_showOTP)
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back_ios),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    if (_showOTP)
                      Align(
                        alignment: _languageConfig.isRTL
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showOTP = false;
                              for (var controller in _otpControllers) {
                                controller.clear();
                              }
                            });
                          },
                          icon: const Icon(Icons.edit),
                          label: Text(
                              _languageConfig.translations['changeNumber']!),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 36),
                    Center(
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade400,
                                Colors.blue.shade700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            _showOTP
                                ? Icons.lock_outline_rounded
                                : Icons.phone_android,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      _showOTP
                          ? _languageConfig.translations['enterOTP']!
                          : _languageConfig.translations['verifyPhone']!,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1F71),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _showOTP
                          ? _languageConfig
                              .translations['enterVerificationCode']!
                          : _languageConfig.translations['willSendCode']!,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (!_showOTP) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => _validatePhone(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                _languageConfig.translations['phoneNumber'],
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 20,
                            ),
                            errorText: _errorText,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: InkWell(
                              onTap: _showCountryPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedCountry.dialCode,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(24),
                          ),
                          inputFormatters: [
                            PhoneNumberFormatter(
                                format: _selectedCountry.format),
                          ],
                          textDirection:
                              TextDirection.ltr, // Always LTR for phone numbers
                        ),
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => Container(
                            width: 50,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade100.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  _otpFocusNodes[index + 1].requestFocus();
                                }
                                if (value.isEmpty && index > 0) {
                                  _otpFocusNodes[index - 1].requestFocus();
                                }
                                if (index == 5 && value.isNotEmpty) {
                                  _onSubmitOTP();
                                }
                              },
                              onTap: () => _handleFocusChange(index),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                    if (!_showOTP)
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isPhoneValid ? _onSubmitPhone : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: _isPhoneValid ? 8 : 0,
                            shadowColor: Colors.blue.shade200,
                          ),
                          child: Text(
                            _languageConfig.translations['sendCode']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isPhoneValid
                                  ? Colors.white
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                    if (_showOTP) ...[
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _languageConfig.translations['didntReceiveCode']!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(_languageConfig
                                            .translations['codeResent']!),
                                      ],
                                    ),
                                  ),
                                  backgroundColor: Colors.green.shade600,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue.shade700,
                            ),
                            child: Text(
                              _languageConfig.translations['resend']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

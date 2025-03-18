import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dorak_business/view/registration/registration_view.dart';

enum LoginMethod {
  phone,
  username,
}

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

enum AppLanguage {
  english('en', TextDirection.ltr),
  arabic('ar', TextDirection.rtl),
  hebrew('he', TextDirection.rtl);

  final String code;
  final TextDirection direction;

  const AppLanguage(this.code, this.direction);

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

class LoginScreen extends StatefulWidget {
  final String languageCode;

  const LoginScreen({
    super.key,
    required this.languageCode,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isFormValid = false;
  LoginMethod _loginMethod = LoginMethod.phone;
  late AppLanguage _currentLanguage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final List<CountryCode> _countryCodes = const [
    CountryCode(name: 'United States', dialCode: '+1', format: 'XXX-XXX-XXXX'),
    CountryCode(
        name: 'United Kingdom', dialCode: '+44', format: 'XXXX-XXX-XXX'),
    CountryCode(name: 'India', dialCode: '+91', format: 'XXXXX-XXXXX'),
  ];

  late CountryCode _selectedCountry;

  final List<Color> _gradientColors = [
    Colors.white,
    Colors.grey[50]!,
    Colors.grey[100]!,
  ];

  final Color _primaryColor = Colors.blue[700]!;

  Map<String, Map<String, String>> get translations => {
        'en': {
          'login': 'Login',
          'welcome_back': 'Welcome\nback',
          'login_desc': 'Sign in to continue',
          'phone': 'Phone number',
          'username': 'Username',
          'password': 'Password',
          'phone_required': 'Please enter your phone number',
          'phone_invalid': 'Please enter a valid phone number',
          'username_required': 'Please enter your username',
          'password_required': 'Please enter your password',
          'login_with_phone': 'Phone',
          'login_with_username': 'Username',
          'forgot_password': 'Forgot Password?',
          'login_button': 'Login',
          'dont_have_account': 'Don\'t have an account?',
          'create_account': 'Create Account',
          'or': 'OR',
        },
        'ar': {
          'login': 'تسجيل الدخول',
          'welcome_back': 'مرحباً\nبعودتك',
          'login_desc': 'سجل دخولك للمتابعة',
          'phone': 'رقم الهاتف',
          'username': 'اسم المستخدم',
          'password': 'كلمة المرور',
          'phone_required': 'الرجاء إدخال رقم الهاتف',
          'phone_invalid': 'الرجاء إدخال رقم هاتف صحيح',
          'username_required': 'الرجاء إدخال اسم المستخدم',
          'password_required': 'الرجاء إدخال كلمة المرور',
          'login_with_phone': 'الهاتف',
          'login_with_username': 'اسم المستخدم',
          'forgot_password': 'نسيت كلمة المرور؟',
          'login_button': 'تسجيل الدخول',
          'dont_have_account': 'ليس لديك حساب؟',
          'create_account': 'إنشاء حساب',
          'or': 'أو',
        },
        'he': {
          'login': 'התחברות',
          'welcome_back': 'ברוכים\nהשבים',
          'login_desc': 'התחבר כדי להמשיך',
          'phone': 'מספר טלפון',
          'username': 'שם משתמש',
          'password': 'סיסמה',
          'phone_required': 'נא להזין מספר טלפון',
          'phone_invalid': 'נא להזין מספר טלפון תקין',
          'username_required': 'נא להזין שם משתמש',
          'password_required': 'נא להזין סיסמה',
          'login_with_phone': 'טלפון',
          'login_with_username': 'שם משתמש',
          'forgot_password': 'שכחת סיסמה?',
          'login_button': 'התחברות',
          'dont_have_account': 'אין לך חשבון?',
          'create_account': 'צור חשבון',
          'or': 'או',
        },
      };

  @override
  void initState() {
    super.initState();
    _setupLanguage();
    _setupAnimations();
    _setupValidation();
    _selectedCountry = _countryCodes[0];
  }

  void _setupLanguage() {
    _currentLanguage = AppLanguage.fromCode(widget.languageCode);
  }

  void _setupAnimations() {
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

  void _setupValidation() {
    _phoneController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      if (_loginMethod == LoginMethod.phone) {
        _isFormValid = _phoneController.text.isNotEmpty &&
            _passwordController.text.length >= 6;
      } else {
        _isFormValid = _usernameController.text.isNotEmpty &&
            _passwordController.text.length >= 6;
      }

      // Reset validation when switching methods
      if (_loginMethod == LoginMethod.phone &&
          _usernameController.text.isNotEmpty) {
        _usernameController.clear();
      } else if (_loginMethod == LoginMethod.username &&
          _phoneController.text.isNotEmpty) {
        _phoneController.clear();
      }
    });
  }

  String _getLocalizedText(String key) {
    return translations[_currentLanguage.code]?[key] ?? key;
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
            Expanded(
              child: ListView.builder(
                itemCount: _countryCodes.length,
                itemBuilder: (context, index) {
                  final country = _countryCodes[index];
                  return ListTile(
                    selected: _selectedCountry == country,
                    onTap: () {
                      setState(() {
                        _selectedCountry = country;
                        _phoneController.clear();
                      });
                      Navigator.pop(context);
                    },
                    title: Text(country.name),
                    trailing: Text(country.dialCode),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _currentLanguage.direction,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: _gradientColors,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: _currentLanguage.direction ==
                                      TextDirection.ltr
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: 60),
                                _buildHeader(),
                                const SizedBox(height: 40),
                                _buildLoginMethodToggle(),
                                const SizedBox(height: 30),
                                if (_loginMethod == LoginMethod.phone)
                                  _buildPhoneInput()
                                else
                                  _buildUsernameInput(),
                                const SizedBox(height: 20),
                                _buildPasswordInput(),
                                const SizedBox(height: 20),
                                _buildForgotPassword(),
                                const SizedBox(height: 40),
                                _buildLoginButton(),
                                const SizedBox(height: 20),
                                _buildCreateAccountButton(),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getLocalizedText('welcome_back'),
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getLocalizedText('login_desc'),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginMethodToggle() {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              text: _getLocalizedText('login_with_phone'),
              isSelected: _loginMethod == LoginMethod.phone,
              onTap: () => setState(() => _loginMethod = LoginMethod.phone),
              icon: Icons.phone_android,
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              text: _getLocalizedText('login_with_username'),
              isSelected: _loginMethod == LoginMethod.username,
              onTap: () => setState(() => _loginMethod = LoginMethod.username),
              icon: Icons.person_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          PhoneNumberFormatter(format: _selectedCountry.format),
          LengthLimitingTextInputFormatter(_selectedCountry.format.length),
        ],
        decoration: InputDecoration(
          hintText: _getLocalizedText('phone'),
          prefixIcon: InkWell(
            onTap: _showCountryPicker,
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _selectedCountry.dialCode,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return _getLocalizedText('phone_required');
          }
          // Check if the phone number matches the expected format length (excluding formatting characters)
          final digitsOnly = value!.replaceAll(RegExp(r'[^\d]'), '');
          final expectedLength =
              _selectedCountry.format.replaceAll(RegExp(r'[^X]'), '').length;
          if (digitsOnly.length != expectedLength) {
            return _getLocalizedText('phone_invalid');
          }
          return null;
        },
      ),
    );
  }

  Widget _buildUsernameInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          hintText: _getLocalizedText('username'),
          prefixIcon: const Icon(Icons.person_outline),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return _getLocalizedText('username_required');
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: _getLocalizedText('password'),
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return _getLocalizedText('password_required');
          }
          return null;
        },
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: _currentLanguage.direction == TextDirection.ltr
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          print(_currentLanguage.direction);
          print(TextDirection.ltr);
          // Add forgot password functionality
        },
        child: Text(
          _getLocalizedText('forgot_password'),
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _isFormValid
            ? LinearGradient(
                colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: _isFormValid ? null : Colors.grey[300],
      ),
      child: ElevatedButton(
        onPressed: _isFormValid
            ? () {
                if (_formKey.currentState?.validate() ?? false) {
                  _handleLogin();
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          _getLocalizedText('login_button'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isFormValid ? Colors.white : Colors.grey[500],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _getLocalizedText('dont_have_account'),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to registration page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationView(
                  languageCode: _currentLanguage.code,
                ),
              ),
            );
          },
          child: Text(
            _getLocalizedText('create_account'),
            style: TextStyle(
              color: _primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
                const SizedBox(height: 16),
                Text(
                  _getLocalizedText('login'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      // Add your login success navigation here
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

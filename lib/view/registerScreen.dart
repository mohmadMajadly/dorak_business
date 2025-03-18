import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

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

class RegistrationScreen extends StatefulWidget {
  final String languageCode;

  const RegistrationScreen({
    super.key,
    required this.languageCode,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _securityFormKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isUsernameValid = true;


  late AppLanguage _currentLanguage;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonSlideAnimation;

  int _currentStep = 0;
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFormValid = false;

  final List<Color> _gradientColors = [
    Colors.blue[500]!,
    Colors.blue[400]!,
    Colors.blue[300]!,
  ];

  @override
  void initState() {
    super.initState();
    _setupLanguage();
    _setupAnimations();
    _setupFormValidation();
  }

  void _setupLanguage() {
    _currentLanguage = AppLanguage.fromCode(widget.languageCode);
  }

  void _setupFormValidation() {
    _fullNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      if (_currentStep == 0) {
        _isFormValid = _usernameController.text.isNotEmpty && _fullNameController.text.isNotEmpty && _isUsernameValid;
      } else if (_currentStep == 1) {
        _isFormValid = _passwordController.text.length >= 6 &&
            _confirmPasswordController.text == _passwordController.text;
      } else {
        _isFormValid =
            _selectedDate != null && _selectedGender != null && _acceptedTerms;
      }
    });
  }

  void _setupAnimations() {
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Map<String, Map<String, String>> get translations => {
        'en': {
          'step_label': 'Step ${_currentStep + 1}/3',
          'create_account': 'Create Account',
          'basic_info_desc': 'Let\'s start with your basic information',
          'password_desc': 'Create a secure password',
          'details_desc': 'Just a few more details',
          'continue': 'Continue',
          'back': 'Back',
          'full_name': 'Full Name',
          'email': 'Email (Optional)',
          'password': 'Password',
          'confirm_password': 'Confirm Password',
          'date_of_birth': 'Date of Birth',
          'gender': 'Gender',
          'male': 'Male',
          'female': 'Female',
          'terms_intro': 'I agree to the',
          'terms_and_conditions': 'Terms & Conditions',
          'name_required': 'Please enter your full name',
          'email_invalid': 'Please enter a valid email address',
          'password_required': 'Please enter a password',
          'password_length': 'Password must be at least 6 characters',
          'passwords_mismatch': 'Passwords do not match',
          'registration_success': 'Registration Successful!',
          'account_created': 'Your account has been created successfully.',
          'select_dob': 'Please select your date of birth',
          'select_gender': 'Please select your gender',
          'accept_terms': 'Please accept the terms and conditions',
          'username': 'Username',
          'username_required': 'Please enter a username',
          'username_taken': 'This username is already taken',
          'checking_username': 'Checking username availability...',
          'january': 'January',
          'february': 'February',
          'march': 'March',
          'april': 'April',
          'may': 'May',
          'june': 'June',
          'july': 'July',
          'august': 'August',
          'september': 'September',
          'october': 'October',
          'november': 'November',
          'december': 'December',
        },
        'ar': {
          'step_label': 'الخطوة ${_currentStep + 1}/3',
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
          'select_dob': 'الرجاء اختيار تاريخ الميلاد',
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
        },
        'he': {
          'step_label': 'שלב ${_currentStep + 1}/3',
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
          'select_dob': 'אנא בחר תאריך לידה',
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
        },
      };

  String _getLocalizedText(String key) {
    return translations[_currentLanguage.code]?[key] ?? key;
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
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildStepIndicator(),
                          _buildCurrentStep(),
                        ],
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
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity, // Ensure container takes full width
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: _currentLanguage.direction == TextDirection.ltr
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            // Full width container for consistent alignment
            child: Text(
              _getLocalizedText('step_label'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: _currentLanguage.direction == TextDirection.ltr
                  ? TextAlign.left
                  : TextAlign.right,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            // Full width container for consistent alignment
            child: Text(
              _getLocalizedText('create_account'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: _currentLanguage.direction == TextDirection.ltr
                  ? TextAlign.left
                  : TextAlign.right,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            // Full width container for consistent alignment
            child: Text(
              _getLocalizedText(_getStepDescription()),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
              textAlign: _currentLanguage.direction == TextDirection.ltr
                  ? TextAlign.left
                  : TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 0:
        return 'basic_info_desc';
      case 1:
        return 'password_desc';
      case 2:
        return 'details_desc';
      default:
        return '';
    }
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(
          3,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: _currentStep >= index
                    ? _gradientColors[0]
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildSecurityStep();
      case 2:
        return _buildPersonalDetailsStep();
      default:
        return Container();
    }
  }

  Widget _buildBasicInfoStep() {
    return Form(
      key: _basicInfoFormKey,
      child: Column(
        crossAxisAlignment: _currentLanguage.direction == TextDirection.ltr
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          _buildTextField(
            controller: _fullNameController,
            label: _getLocalizedText('full_name'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return _getLocalizedText('name_required');
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _usernameController,
            label: _getLocalizedText('username'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return _getLocalizedText('username_required');
              }
              // Demo check - username "admin" is taken
              if (value?.toLowerCase() == "admin") {
                _isUsernameValid = false;
                return _getLocalizedText('username_taken');
              }
              _isUsernameValid = true;
              return null;
            },
            onChanged: (value) {
              setState(() {
                _validateForm();
              });
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _emailController,
            label: _getLocalizedText('email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isNotEmpty ?? false) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return _getLocalizedText('email_invalid');
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 40),
          _buildNavigationButtons('continue'),
        ],
      ),
    );
  }

  Widget _buildSecurityStep() {
    return Form(
      key: _securityFormKey,
      child: Column(
        crossAxisAlignment: _currentLanguage.direction == TextDirection.ltr
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          _buildPasswordField(
            controller: _passwordController,
            label: _getLocalizedText('password'),
            isConfirmField: false,
          ),
          const SizedBox(height: 20),
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: _getLocalizedText('confirm_password'),
            isConfirmField: true,
          ),
          const SizedBox(height: 40),
          _buildNavigationButtons('continue'),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsStep() {
    return Column(
      crossAxisAlignment: _currentLanguage.direction == TextDirection.ltr
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        _buildDatePicker(),
        const SizedBox(height: 20),
        _buildGenderSelection(),
        const SizedBox(height: 20),
        _buildTermsAndConditions(),
        const SizedBox(height: 40),
        _buildNavigationButtons('create_account'),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
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
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged,
        textDirection: _currentLanguage.direction,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _gradientColors[0], width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isConfirmField,
  }) {
    bool obscureText =
        isConfirmField ? _obscureConfirmPassword : _obscurePassword;

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
        controller: controller,
        obscureText: obscureText,
        textDirection: _currentLanguage.direction,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return _getLocalizedText('password_required');
          }
          if (!isConfirmField) {
            if ((value?.length ?? 0) < 6) {
              return _getLocalizedText('password_length');
            }
          } else {
            if (value != _passwordController.text) {
              return _getLocalizedText('passwords_mismatch');
            }
          }
          return null;
        },
        onChanged: (_) => _validateForm(),
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                if (isConfirmField) {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                } else {
                  _obscurePassword = !_obscurePassword;
                }
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _gradientColors[0], width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
            Icon(Icons.calendar_today, color: _gradientColors[0]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _selectedDate == null
                    ? _getLocalizedText('date_of_birth')
                    : DateFormat('MMMM d, yyyy').format(_selectedDate!),
                style: TextStyle(
                  color:
                      _selectedDate == null ? Colors.grey[600] : Colors.black,
                  fontSize: 16,
                ),
                textDirection: _currentLanguage.direction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: _currentLanguage.direction == TextDirection.ltr
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            _getLocalizedText('gender'),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGenderOption('male', Icons.male)),
              const SizedBox(width: 16),
              Expanded(child: _buildGenderOption('female', Icons.female)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = gender;
          _validateForm();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _gradientColors[0].withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _gradientColors[0] : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? _gradientColors[0] : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              _getLocalizedText(gender),
              style: TextStyle(
                color: isSelected ? _gradientColors[0] : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
                _validateForm();
              });
            },
            activeColor: _gradientColors[0],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _showTermsDialog,
            child: RichText(
              textDirection: _currentLanguage.direction,
              text: TextSpan(
                text: '${_getLocalizedText('terms_intro')} ',
                style: TextStyle(color: Colors.grey[600]),
                children: [
                  TextSpan(
                    text: _getLocalizedText('terms_and_conditions'),
                    style: TextStyle(
                      color: _gradientColors[0],
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(String nextButtonText) {
    final bool isFirstStep = _currentStep == 0;
    final bool isLTR = _currentLanguage.direction == TextDirection.ltr;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isLTR) ...[
          if (!isFirstStep) _buildMainButton(nextButtonText),
          if (isFirstStep)
            _buildMainButton(nextButtonText)
          else
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                  _validateForm();
                });
              },
              child: Text(
                _getLocalizedText('back'),
                style: TextStyle(color: _gradientColors[0]),
              ),
            ),
        ] else ...[
          if (isFirstStep)
            _buildMainButton(nextButtonText)
          else
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                  _validateForm();
                });
              },
              child: Text(
                _getLocalizedText('back'),
                style: TextStyle(color: _gradientColors[0]),
              ),
            ),
          if (!isFirstStep) _buildMainButton(nextButtonText),
        ],
      ],
    );
  }

  Widget _buildMainButton(String buttonText) {
    return Container(
      width: 170,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: _isFormValid
            ? LinearGradient(
                colors: _gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: _isFormValid ? null : Colors.grey[300],
      ),
      child: ElevatedButton(
        onPressed: _isFormValid
            ? () {
                if (_currentStep < 2) {
                  setState(() {
                    _currentStep++;
                    _validateForm();
                  });
                } else {
                  _handleRegistration();
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          _getLocalizedText(buttonText),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _isFormValid ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }



  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = _selectedDate ?? DateTime.now().subtract(const Duration(days: 6570));

    final List<String> months = [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december'
    ];

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month - 1,
                                selectedDate.day,
                              );
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () async {
                            final int? selectedYear = await showDialog<int>(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    width: 300,
                                    height: 400,
                                    padding: const EdgeInsets.all(20),
                                    child: ListView.builder(
                                      itemCount: 124, // 1900 to 2024
                                      itemBuilder: (context, index) {
                                        final year = 2024 - index;
                                        return ListTile(
                                          selected: year == selectedDate.year,
                                          selectedTileColor: _gradientColors[0].withOpacity(0.1),
                                          onTap: () => Navigator.pop(context, year),
                                          title: Text(
                                            year.toString(),
                                            style: TextStyle(
                                              color: year == selectedDate.year ? _gradientColors[0] : null,
                                              fontWeight: year == selectedDate.year ? FontWeight.bold : null,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );

                            if (selectedYear != null) {
                              setState(() {
                                selectedDate = DateTime(
                                  selectedYear,
                                  selectedDate.month,
                                  selectedDate.day,
                                );
                              });
                            }
                          },
                          child: Column(
                            children: [
                              Text(
                                _getLocalizedText(months[selectedDate.month - 1]),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    selectedDate.year.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month + 1,
                                selectedDate.day,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
                            ].map((day) => SizedBox(
                              width: 40,
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )).toList(),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 1,
                              ),
                              itemCount: 42,
                              itemBuilder: (context, index) {
                                final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
                                final startingWeekday = firstDayOfMonth.weekday % 7;
                                final day = index - startingWeekday + 1;
                                final currentDate = DateTime(selectedDate.year, selectedDate.month, day);

                                if (day < 1 || day > DateTime(selectedDate.year, selectedDate.month + 1, 0).day) {
                                  return const SizedBox();
                                }

                                final isSelected = currentDate.year == selectedDate.year &&
                                    currentDate.month == selectedDate.month &&
                                    currentDate.day == selectedDate.day;

                                final isToday = currentDate.year == DateTime.now().year &&
                                    currentDate.month == DateTime.now().month &&
                                    currentDate.day == DateTime.now().day;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDate = currentDate;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      gradient: isSelected ? LinearGradient(
                                        colors: _gradientColors,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ) : null,
                                      color: isToday && !isSelected ? _gradientColors[0].withOpacity(0.1) : null,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        day.toString(),
                                        style: TextStyle(
                                          color: isSelected ? Colors.white :
                                          isToday ? _gradientColors[0] :
                                          Colors.black87,
                                          fontWeight: (isSelected || isToday) ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
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
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: _gradientColors[0]),
                              ),
                            ),
                            child: Text(
                              _getLocalizedText('back'),
                              style: TextStyle(
                                color: _gradientColors[0],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _gradientColors,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _gradientColors[0].withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                _selectedDate = selectedDate;
                                Navigator.pop(context, selectedDate);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                _getLocalizedText('continue'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: _currentLanguage.direction,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    _currentLanguage.direction == TextDirection.ltr
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  Text(
                    _getLocalizedText('terms_and_conditions'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        // Add your terms and conditions text here
                        'Terms and conditions content...',
                        style: TextStyle(
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                        textDirection: _currentLanguage.direction,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: _currentLanguage.direction == TextDirection.ltr
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        _getLocalizedText('continue'),
                        style: TextStyle(color: _gradientColors[0]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleRegistration() {
    // Implement your registration logic here
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: _currentLanguage.direction,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _getLocalizedText('registration_success'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getLocalizedText('account_created'),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Add your navigation logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _gradientColors[0],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _getLocalizedText('continue'),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

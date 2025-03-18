import 'dart:io';

import 'package:dorak_business/view/OTP/OTPLogin_view.dart';
import 'package:flutter/material.dart';
import 'package:dorak_business/model/registration/registration_state_model.dart';
import 'package:dorak_business/model/registration/user_model.dart';
import 'package:dorak_business/service/registration/authentication_service.dart';
import 'package:dorak_business/service/registration/localization_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

class RegistrationViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;
  final String languageCode;

  // Form Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // State Management
  RegistrationStateModel _state = RegistrationStateModel();

  RegistrationStateModel get state => _state;

  // UI Constants
  final List<Color> gradientColors = [
    Colors.blue[500]!,
    Colors.blue[400]!,
    Colors.blue[300]!,
  ];

  RegistrationViewModel(this._authenticationService, this.languageCode) {
    _initializeControllers();
  }

  void _initializeControllers() {
    fullNameController.addListener(validateForm);
    usernameController.addListener(validateForm);
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);
  }

  String getLocalizedText(String key) {
    return LocalizationService.getLocalizedText(key, languageCode);
  }

  void validateForm() {
    bool isValid = false;

    switch (_state.currentStepIndex) {
      case 0:
        isValid = _validateBasicInformation();
        break;
      case 1:
        isValid = _validateSecurityInformation();
        break;
      case 2:
        isValid = _validatePersonalDetails();
        break;
    }

    if (_state.isFormValid != isValid) {
      _state = _state.copyWith(isFormValid: isValid);
      notifyListeners();
    }
  }

  bool _validateBasicInformation() {
    return usernameController.text.isNotEmpty &&
        fullNameController.text.isNotEmpty &&
        _state.isUsernameAvailable &&
        _validateEmailIfProvided();
  }

  bool _validateEmailIfProvided() {
    if (emailController.text.isEmpty) return true;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text);
  }

  bool _validateSecurityInformation() {
    return passwordController.text.length >= 6 &&
        confirmPasswordController.text == passwordController.text;
  }

  bool _validatePersonalDetails() {
    return _state.selectedDateOfBirth != null &&
        _state.selectedGender != null &&
        _state.hasAcceptedTerms;
  }

  Future<void> checkUsernameAvailability(String username, BuildContext context) async {
    if (username.isEmpty) return;

    _state = _state.copyWith(isProcessing: true);
    notifyListeners();

    try {
      final isAvailable =
          await _authenticationService.checkUsernameAvailability(username);
      _state = _state.copyWith(
          isUsernameAvailable: isAvailable,
          isProcessing: false,
          errorMessage: isAvailable ? null : getLocalizedText('username_taken'));
    } catch (error) {
      _state = _state.copyWith(
          isProcessing: false,
          errorMessage: getLocalizedText('checking_username'));
    }
    validateForm();
    notifyListeners();
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      _state = _state.copyWith(
          passwordErrorMessage: getLocalizedText('password_required'),
          isFormValid: false
      );
    } else if (password.length < 6) {
      _state = _state.copyWith(
          passwordErrorMessage: getLocalizedText('password_length'),
          isFormValid: false
      );
    } else {
      _state = _state.copyWith(passwordErrorMessage: null);
      validatePasswordMatch();
    }
    notifyListeners();
  }

  void validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _state = _state.copyWith(
          confirmPasswordErrorMessage: getLocalizedText('password_required'),
          isFormValid: false
      );
    } else if (confirmPassword != passwordController.text) {
      _state = _state.copyWith(
          confirmPasswordErrorMessage: getLocalizedText('passwords_mismatch'),
          isFormValid: false
      );
    } else {
      _state = _state.copyWith(confirmPasswordErrorMessage: null);
    }
    notifyListeners();
  }

  void validatePasswordMatch() {
    if (confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text != passwordController.text) {
      _state = _state.copyWith(
          confirmPasswordErrorMessage: getLocalizedText('passwords_mismatch'),
          isFormValid: false
      );
      notifyListeners();
    }
  }


  void moveToNextStep() {
    if (_state.currentStepIndex < 2 && _state.isFormValid) {
      _state = _state.copyWith(
          currentStepIndex: _state.currentStepIndex + 1, isFormValid: false);
      validateForm();
      notifyListeners();
    }
  }

  void moveToPreviousStep() {
    if (_state.currentStepIndex > 0) {
      _state = _state.copyWith(
          currentStepIndex: _state.currentStepIndex - 1, errorMessage: null);
      validateForm();
      notifyListeners();
    }
  }

  void togglePasswordVisibility(bool isConfirmPassword) {
    _state = _state.copyWith(
      isConfirmPasswordHidden: isConfirmPassword
          ? !_state.isConfirmPasswordHidden
          : _state.isConfirmPasswordHidden,
      isPasswordHidden: !isConfirmPassword
          ? !_state.isPasswordHidden
          : _state.isPasswordHidden,
    );
    notifyListeners();
  }

  void setDateOfBirth(DateTime date) {
    _state = _state.copyWith(selectedDateOfBirth: date);
    validateForm();
    notifyListeners();
  }

  void setGender(String gender) {
    _state = _state.copyWith(selectedGender: gender);
    validateForm();
    notifyListeners();
  }

  void setTermsAcceptance(bool accepted) {
    _state = _state.copyWith(hasAcceptedTerms: accepted);
    validateForm();
    notifyListeners();
  }

  Future<void> registerUser(BuildContext context) async {
    if (!_state.isFormValid) return;

    _state = _state.copyWith(isProcessing: true);
    notifyListeners();

    try {
      _showLoadingDialog(context);
      await _authenticationService.registerUser(await _createUserModel());
      Navigator.pop(context); // Hide loading

      await showSuccessDialog(context);
      _navigateToHome(context);
    } catch (error) {
      Navigator.pop(context); // Hide loading
      await showErrorDialog(context, getLocalizedText("server_error"));
    }
  }

  Future<void> showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                getLocalizedText('registration_success'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                getLocalizedText('account_created'),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToHome(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gradientColors[0],
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  getLocalizedText('continue'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showErrorDialog(BuildContext context, String error) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                getLocalizedText('registration_failed'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  getLocalizedText('try_again_later'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: gradientColors[0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialog({
    required Widget icon,
    required String title,
    required String message,
    required VoidCallback onAction,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onAction,
          child: Text(getLocalizedText('continue')),
        ),
      ],
    );
  }

  Future<void> _showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhoneVerificationPage(languageCode: languageCode)),
    );
  }

  Future<UserModel> _createUserModel() async {
    return UserModel(
      fullName: fullNameController.text,
      username: usernameController.text,
      emailAddress: emailController.text.isEmpty ? null : emailController.text,
      password: passwordController.text,
      dateOfBirth: _state.selectedDateOfBirth,
      gender: _state.selectedGender,
      hasAcceptedTerms: _state.hasAcceptedTerms,
      device_type: await getDeviceDetails(),
    );
  }

  Future<String> getDeviceDetails() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      // Check if the platform is Android
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return "System: Android\n"
            "Model: ${androidInfo.model}\n"
            "Manufacturer: ${androidInfo.manufacturer}\n"
            "OS Version: ${androidInfo.version.release}";
      }
      // Check if the platform is iOS
      else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return "System: iOS\n"
            "Device Name: ${iosInfo.name}\n"
            "Model: ${iosInfo.utsname.machine}\n"
            "OS Version: ${iosInfo.systemVersion}";
      }
      // If the system is not Android or iOS
      else {
        return "Unknown system";
      }
    } catch (e) {
      return ""; // Return an empty string if an error occurs
    }
  }


  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

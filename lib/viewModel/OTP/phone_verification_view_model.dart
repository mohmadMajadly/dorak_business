import 'package:flutter/material.dart';
import 'package:dorak_business/model/OTP/country_code_model.dart';
import 'package:dorak_business/model/OTP/language_configuration_model.dart';
import 'package:dorak_business/service/OTP/verification_service.dart';
import 'package:dorak_business/model/OTP/phone_verification_state.dart';

class PhoneVerificationViewModel extends ChangeNotifier {
  final String languageCode;
  final VerificationService _verificationService;

  late final LanguageConfigurationModel languageConfiguration;
  late CountryCodeModel selectedCountry;
  PhoneVerificationState _state = PhoneVerificationState();

  // Controllers and FocusNodes
  final TextEditingController phoneNumberController = TextEditingController();
  final List<TextEditingController> oneTimePasswordControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> oneTimePasswordFocusNodes =
  List.generate(6, (index) => FocusNode());

  // Available countries list
  final List<CountryCodeModel> availableCountries = const [
    CountryCodeModel(
      countryName: 'Israel',
      countryDialingCode: '+972',
      phoneNumberFormat: 'XXX-XXX-XXXX',
    ),
  ];

  // Constructor
  PhoneVerificationViewModel({
    required this.languageCode,
    VerificationService? verificationService,
  }) : _verificationService = verificationService ?? VerificationService() {
    languageConfiguration = LanguageConfigurationModel.supportedLanguages[languageCode] ??
        LanguageConfigurationModel.supportedLanguages['en']!;
    selectedCountry = availableCountries[0];
  }

  // Getters
  bool get isSendingCode => _state.isSendingCode;
  bool get isResendingCode => _state.isResendingCode;
  bool get isVerifyingCode => _state.isVerifyingCode;
  bool get isLoading => _state.isLoading;
  String? get errorMessage => _state.errorMessage;
  bool get isPhoneNumberValid => _state.isPhoneNumberValid;
  bool get isOneTimePasswordScreenVisible => _state.isOneTimePasswordScreenVisible;
  String? get verificationId => _state.verificationId;

  // State management
  void _updateState(PhoneVerificationState newState) {
    _state = newState;
    notifyListeners();
  }

  // Phone number validation
  void validatePhoneNumber() {
    final phoneNumberDigits = phoneNumberController.text.replaceAll(RegExp(r'[^\d]'), '');
    _updateState(_state.copyWith(
      isPhoneNumberValid: phoneNumberDigits.length >= 10,
      errorMessage: phoneNumberDigits.length >= 10
          ? null
          : languageConfiguration.translations['invalidPhoneNumber'],
    ));
  }

  // Phone verification initiation
  Future<bool> initiatePhoneVerification() async {
    _updateState(_state.copyWith(
      isSendingCode: true,
      errorMessage: null,
    ));

    try {
      final response = await _verificationService.sendVerificationCode(
        phoneNumber: phoneNumberController.text,
        countryCode: selectedCountry.countryDialingCode,
      );

      if (response.success) {
        _updateState(_state.copyWith(
          isSendingCode: false,
          isOneTimePasswordScreenVisible: true,
          verificationId: response.verificationId,
        ));
        return true;
      } else {
        _updateState(_state.copyWith(
          isSendingCode: false,
          errorMessage: response.errorMessage,
        ));
        return false;
      }
    } catch (e) {
      _updateState(_state.copyWith(
        isSendingCode: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      ));
      return false;
    }
  }

  // Resend verification code
  Future<bool> resendVerificationCode() async {
    _updateState(_state.copyWith(
      isResendingCode: true,
      errorMessage: null,
    ));

    try {
      final response = await _verificationService.sendVerificationCode(
        phoneNumber: phoneNumberController.text,
        countryCode: selectedCountry.countryDialingCode,
      );

      _updateState(_state.copyWith(
        isResendingCode: false,
        errorMessage: response.success ? null : response.errorMessage,
        verificationId: response.success ? response.verificationId : _state.verificationId,
      ));

      return response.success;
    } catch (e) {
      _updateState(_state.copyWith(
        isResendingCode: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      ));
      return false;
    }
  }

  // Verify one-time password
  Future<bool> verifyOneTimePassword(String code) async {
    if (_state.verificationId == null) {
      _updateState(_state.copyWith(
        errorMessage: 'Verification session expired. Please request a new code.',
      ));
      return false;
    }

    _updateState(_state.copyWith(
      isVerifyingCode: true,
      errorMessage: null,
    ));

    try {
      final response = await _verificationService.verifyCode(
        phoneNumber: phoneNumberController.text,
        countryCode: selectedCountry.countryDialingCode,
        code: code,
      );

      _updateState(_state.copyWith(
        isVerifyingCode: false,
        errorMessage: response.success ? null : response.errorMessage,
      ));

      return response.success;
    } catch (e) {
      _updateState(_state.copyWith(
        isVerifyingCode: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      ));
      return false;
    }
  }

  // Update selected country
  void updateSelectedCountry(CountryCodeModel newCountry) {
    selectedCountry = newCountry;
    phoneNumberController.clear();
    _updateState(_state.copyWith(
      isPhoneNumberValid: false,
      errorMessage: null,
    ));
  }

  // Set OTP screen visibility
  void setOneTimePasswordScreenVisibility(bool isVisible) {
    if (!isVisible) {
      clearOneTimePasswordFields();
    }
    _updateState(_state.copyWith(
      isOneTimePasswordScreenVisible: isVisible,
      errorMessage: null,
    ));
  }

  // Clear OTP fields
  void clearOneTimePasswordFields() {
    for (var controller in oneTimePasswordControllers) {
      controller.clear();
    }
  }

  // Find last filled OTP digit
  int findLastFilledOneTimePasswordDigit() {
    for (int i = oneTimePasswordControllers.length - 1; i >= 0; i--) {
      if (oneTimePasswordControllers[i].text.isNotEmpty) {
        return i + 1;
      }
    }
    return 0;
  }

  // Resource cleanup
  @override
  void dispose() {
    phoneNumberController.dispose();
    for (var controller in oneTimePasswordControllers) {
      controller.dispose();
    }
    for (var node in oneTimePasswordFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
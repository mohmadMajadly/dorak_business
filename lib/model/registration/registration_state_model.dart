class RegistrationStateModel {
  final int currentStepIndex;
  final bool isFormValid;
  final bool isUsernameAvailable;
  final bool isProcessing;
  final bool hasAcceptedTerms;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final DateTime? selectedDateOfBirth;
  final String? selectedGender;
  final String? errorMessage;
  final String? passwordErrorMessage;
  final String? confirmPasswordErrorMessage;


  RegistrationStateModel({
    this.currentStepIndex = 0,
    this.isFormValid = false,
    this.isUsernameAvailable = true,
    this.isProcessing = false,
    this.hasAcceptedTerms = false,
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
    this.selectedDateOfBirth,
    this.selectedGender,
    this.errorMessage,
    this.passwordErrorMessage,
    this.confirmPasswordErrorMessage,
  });

  /// Creates a new instance with updated values
  RegistrationStateModel copyWith({
    int? currentStepIndex,
    bool? isFormValid,
    bool? isUsernameAvailable,
    bool? isProcessing,
    bool? hasAcceptedTerms,
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
    DateTime? selectedDateOfBirth,
    String? selectedGender,
    String? errorMessage,
    String? passwordErrorMessage,
    String? confirmPasswordErrorMessage,
  }) {
    return RegistrationStateModel(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isFormValid: isFormValid ?? this.isFormValid,
      isUsernameAvailable: isUsernameAvailable ?? this.isUsernameAvailable,
      isProcessing: isProcessing ?? this.isProcessing,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden: isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      selectedDateOfBirth: selectedDateOfBirth ?? this.selectedDateOfBirth,
      selectedGender: selectedGender ?? this.selectedGender,
      passwordErrorMessage: passwordErrorMessage,
      confirmPasswordErrorMessage: confirmPasswordErrorMessage,
      errorMessage: errorMessage,
    );
  }
}

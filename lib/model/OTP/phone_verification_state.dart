class PhoneVerificationState {
  final bool isSendingCode;
  final bool isResendingCode;
  final bool isVerifyingCode;
  final String? errorMessage;
  final bool isPhoneNumberValid;
  final bool isOneTimePasswordScreenVisible;
  final String? verificationId;

  PhoneVerificationState({
    this.isSendingCode = false,
    this.isResendingCode = false,
    this.isVerifyingCode = false,
    this.errorMessage,
    this.isPhoneNumberValid = false,
    this.isOneTimePasswordScreenVisible = false,
    this.verificationId,
  });

  bool get isLoading => isSendingCode || isResendingCode || isVerifyingCode;


  PhoneVerificationState copyWith({
    bool? isSendingCode,
    bool? isResendingCode,
    bool? isVerifyingCode,
    String? errorMessage,
    bool? isPhoneNumberValid,
    bool? isOneTimePasswordScreenVisible,
    String? verificationId,
  }) {
    return PhoneVerificationState(
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isResendingCode: isResendingCode ?? this.isResendingCode,
      isVerifyingCode: isVerifyingCode ?? this.isVerifyingCode,
      errorMessage: errorMessage,  // Note: null means clear error
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      isOneTimePasswordScreenVisible: isOneTimePasswordScreenVisible ??
          this.isOneTimePasswordScreenVisible,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}
class RouteCondition {
  final bool isUserExist;
  final bool isCredentialsValid;
  final bool isOnboardingComplete;
  final bool isProfileComplete;

  RouteCondition({
    required this.isUserExist,
    required this.isCredentialsValid,
    required this.isOnboardingComplete,
    required this.isProfileComplete,
  });

  factory RouteCondition.fromJson(Map<String, dynamic> json) {
    return RouteCondition(
      isUserExist: json['userExist'] ?? false,
      isCredentialsValid: json['credentialsValid'] ?? false,
      isOnboardingComplete: json['onboardingComplete'] ?? false,
      isProfileComplete: json['profileComplete'] ?? false,
    );
  }
}

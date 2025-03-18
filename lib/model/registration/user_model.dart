class UserModel {
  final String fullName;
  final String username;
  final String? emailAddress;
  final String password;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool hasAcceptedTerms;
  final String? device_type;

  UserModel({
    required this.fullName,
    required this.username,
    this.emailAddress,
    required this.password,
    this.dateOfBirth,
    this.gender,
    required this.hasAcceptedTerms,
    this.device_type,
  });

  /// Converts the user model to a JSON map for API communication
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'emailAddress': emailAddress,
      'password': password,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'hasAcceptedTerms': hasAcceptedTerms,
      'device_type': device_type,
    };
  }
}

class AuthCredentials {
  final String? username;
  final String? password;

  AuthCredentials({this.username, this.password});

  bool get isValid => username != null && password != null;
}

enum ConnectionFailureType {
  noInternet,
  serverError,
  timeout,
  unknown
}

class ConnectionFailure {
  final ConnectionFailureType type;
  final String message;

  ConnectionFailure({
    required this.type,
    required this.message,
  });

  String getLocalizedMessage(String languageCode) {
    switch (type) {
      case ConnectionFailureType.noInternet:
        return 'No internet connection. Please check your network and try again.';
      case ConnectionFailureType.serverError:
        return 'Server error occurred. Please try again later.';
      case ConnectionFailureType.timeout:
        return 'Connection timeout. Please try again.';
      case ConnectionFailureType.unknown:
        return message;
    }
  }
}

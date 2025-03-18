class ApiConfig {
  // Base URL for production
  static const String productionBaseUrl = 'http://192.168.1.100:8080';

  // Base URL for development
  static const String developmentBaseUrl = 'http://192.168.1.103:8080';

  // Base URL for staging
  static const String stagingBaseUrl = 'http://192.168.1.100:8080';

  // Current environment
  static const String environment = 'development'; // Can be 'development', 'staging', or 'production'

  // Get the appropriate base URL based on environment
  static String get baseUrl {
    switch (environment) {
      case 'production':
        return productionBaseUrl;
      case 'staging':
        return stagingBaseUrl;
      case 'development':
      default:
        return developmentBaseUrl;
    }
  }

  // API Endpoints
  static String get VerificationCode => '$baseUrl/user/verify-code';
  static String get sendVerification => '$baseUrl/user/send-verification';
  static String get checkConditionsEndpoint => '$baseUrl/user/check-conditions';
  static String get loginEndpoint => '$baseUrl/auth/login';
  static String get registerEndpoint => '$baseUrl/auth/register';
  static String get profileEndpoint => '$baseUrl/user/profile';

  // API Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000; // 30 seconds

  // API Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Add authorization header
  static Map<String, String> getAuthenticatedHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}


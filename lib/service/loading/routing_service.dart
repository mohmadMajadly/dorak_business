import 'dart:convert';

import 'package:dorak_business/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:dorak_business/model/loading/route_condition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class RoutingService {
  final AuthService _authService;

  RoutingService(this._authService);

  Future<RouteCondition> getRouteCondition() async {
    var isOnboardingComplete = false;
    try {
      // First, check stored credentials
      final credentials = await _authService.getStoredCredentials();

      try {
        final prefs = await SharedPreferences.getInstance();
        isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;
      } finally {
      }

      if (!credentials.isValid) {
        return RouteCondition(
          isUserExist: false,
          isCredentialsValid: false,
          isOnboardingComplete: isOnboardingComplete,
          isProfileComplete: false,
        );
      }

      // Verify credentials with server
      final isCredentialsValid = await _authService.verifyCredentials(
        credentials.username!,
        credentials.password!,
      );

      if (!isCredentialsValid) {
        return RouteCondition(
          isUserExist: true,
          isCredentialsValid: false,
          isOnboardingComplete: isOnboardingComplete,
          isProfileComplete: false,
        );
      }

      // If credentials are valid, get the rest of the conditions
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.checkConditionsEndpoint}?username=${AuthService.getUsername()}'),
        headers: ApiConfig.headers,
      );

      print(response.body);

      if (response.statusCode == 200) {
        final baseConditions =
            RouteCondition.fromJson(json.decode(response.body));
        return RouteCondition(
          isUserExist: true,
          isCredentialsValid: true,
          isOnboardingComplete: baseConditions.isOnboardingComplete,
          isProfileComplete: baseConditions.isProfileComplete,
        );
      } else {
        throw Exception('Failed to load route condition');
      }
    } catch (e) {
      throw Exception('Server error: ${e.toString()}');
    }
  }
}

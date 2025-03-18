import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dorak_business/config/api_config.dart';
import 'package:dorak_business/model/loading/auth_credentials.dart';

class AuthService {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString(_usernameKey) == null){
      return '';
    }

    return prefs.getString(_usernameKey);
  }

  // Get stored credentials
  Future<AuthCredentials> getStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthCredentials(
      username: prefs.getString(_usernameKey),
      password: prefs.getString(_passwordKey),
    );
  }

  // Verify credentials with server
  Future<bool> verifyCredentials(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/user/verify-credentials'),
        headers: ApiConfig.headers,
        body: json.encode({
          'username': username,
          'password': password,
        }),
      ).timeout(Duration(milliseconds: ApiConfig.connectionTimeout));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:dorak_business/model/registration/user_model.dart';
import 'package:dorak_business/core/errors/failures.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dorak_business/config/api_config.dart';

/// Abstract class defining the authentication service contract
abstract class AuthenticationService {
  /// Checks if a username is available
  Future<bool> checkUsernameAvailability(String username);

  /// Registers a new user
  Future<void> registerUser(UserModel user);
}

/// Implementation of the AuthenticationService
class AuthenticationServiceImplementation implements AuthenticationService {
  /*static const String apiUrl = "${ApiConfig.productionBaseUrl}/user/";*/
  static final String apiUrl = "${ApiConfig.baseUrl}/user/";


  @override
  Future<bool> checkUsernameAvailability(String username) async {
    // TODO: Replace with actual API implementation

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw ConnectionFailure(
            type: ConnectionFailureType.noInternet,
            message: 'No internet connection'
        );
      }

      final response = await http.get(
        Uri.parse('${apiUrl}checkUsernameExistence?username=$username'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        return !json.decode(response.body);
      } else if (response.statusCode == 400) {
        throw ConnectionFailure(
            type: ConnectionFailureType.unknown,
            message: 'Server error: ${response.statusCode}'
        );
      } else if (response.statusCode == 500) {
        throw ConnectionFailure(
            type: ConnectionFailureType.unknown,
            message: 'Server error: ${response.statusCode}'
        );
      }

      return false;
    } catch (e) {
      print('حدث خطأ: $e');
      throw ConnectionFailure(
          type: ConnectionFailureType.serverError,
          message: 'Server error'
      );
    }

    /*await Future.delayed(const Duration(seconds: 1));
    return username.toLowerCase() != "admin";*/
  }

  @override
  Future<void> registerUser(UserModel user) async {
    // TODO: Replace with actual API implementation
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw ConnectionFailure(
            type: ConnectionFailureType.noInternet,
            message: 'No internet connection'
        );
      }

      final response = await http.post(
        /*Uri.parse("${ApiConfig.productionBaseUrl}/user/register"),*/
        Uri.parse("${ApiConfig.baseUrl}/user/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()), // تحويل `UserModel` إلى JSON
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> jwt = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", jwt['token']);
        await prefs.setString("refresh_token", jwt['refresh_token']);
        await prefs.setString("user_id", '${jwt['user_id']}');
        await prefs.setString("username", user.username);
        await prefs.setString("password", user.password);
        print("✅ تم التسجيل بنجاح. التوكن: $jwt");
        return ;
      } else {
        throw ConnectionFailure(
            type: ConnectionFailureType.serverError,
            message: 'Server error: ${response.statusCode}'
        );
      }
    } on TimeoutException{
      throw ConnectionFailure(
          type: ConnectionFailureType.timeout,
          message: 'Connection timeout'
      );
    } catch (e) {
      print("⚠️ حدث خطأ أثناء الاتصال بالسيرفر: $e");
      throw Exception("Error to connect to the server or the username is exist");
    }

  }
}

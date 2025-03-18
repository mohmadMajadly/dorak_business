// lib/services/verification_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dorak_business/config/api_config.dart';

class VerificationResponse {
  final bool success;
  final String? errorMessage;
  final String? verificationId;

  VerificationResponse({
    required this.success,
    this.errorMessage,
    this.verificationId,
  });
}

class VerificationService {
  Future<VerificationResponse> sendVerificationCode({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      // TODO: Replace with actual API call
      String? userID;
      try {
        final prefs = await SharedPreferences.getInstance();
        userID = prefs.getString("user_id");
      } finally {

      }

      // Simulate API response
      // return VerificationResponse(
      //   success: true,
      //   verificationId: userID,
      // );

      final response = await http.post(
        Uri.parse(ApiConfig.sendVerification),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'verificationId' : userID,
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
        }),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return VerificationResponse(
          success: true,
          verificationId: data['verificationId'],
        );
      } else {
        final error = json.decode(response.body);
        return VerificationResponse(
          success: false,
          errorMessage: error['message'] ?? 'Failed to send verification code',
        );
      }
    } catch (e) {
      print(e);
      return VerificationResponse(
        success: false,
        errorMessage: 'Failed to connect to server. Please check your internet connection.',
      );
    }
  }

  Future<VerificationResponse> resendVerificationCode({
    required String phoneNumber,
    required String countryCode,
    String? previousVerificationId,
  }) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      // Simulate API response
      return VerificationResponse(
        success: true,
        verificationId: 'mock-verification-id-resend',
      );

      // Example API implementation:
      // final response = await http.post(
      //   Uri.parse('${ApiConfig.baseUrl}/resend-verification'),
      //   body: {
      //     'phoneNumber': phoneNumber,
      //     'countryCode': countryCode,
      //     'previousVerificationId': previousVerificationId,
      //   },
      // );
      //
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return VerificationResponse(
      //     success: true,
      //     verificationId: data['verificationId'],
      //   );
      // } else {
      //   final error = json.decode(response.body);
      //   return VerificationResponse(
      //     success: false,
      //     errorMessage: error['message'] ?? 'Failed to resend verification code',
      //   );
      // }
    } catch (e) {
      return VerificationResponse(
        success: false,
        errorMessage: 'Failed to connect to server. Please check your internet connection.',
      );
    }
  }

  Future<VerificationResponse> verifyCode({
    required String phoneNumber,
    required String countryCode,
    required String code,
  }) async {
    try {
      String? userID;
      try {
        final prefs = await SharedPreferences.getInstance();
        userID = prefs.getString("user_id");
      } finally {

      }

      // Simulate API response
      // return VerificationResponse(
      //   success: true,
      // );

      final response = await http.post(
        Uri.parse(ApiConfig.VerificationCode),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'verificationId' : userID,
          'phoneNumber': phoneNumber,
          'countryCode': countryCode,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        return VerificationResponse(success: true);
      } else {
        final error = json.decode(response.body);
        return VerificationResponse(
          success: false,
          errorMessage: error['message'] ?? 'Invalid verification code',
        );
      }
    } catch (e) {
      return VerificationResponse(
        success: false,
        errorMessage: 'Failed to connect to server. Please check your internet connection.',
      );
    }
  }
}
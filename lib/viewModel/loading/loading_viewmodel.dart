import 'package:dorak_business/view/OTP/phone_verification_view.dart';
import 'package:flutter/material.dart';
import 'package:dorak_business/service/loading/routing_service.dart';
import 'package:dorak_business/model/loading/route_condition.dart';
import 'package:dorak_business/utils/connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dorak_business/view/login/login_view.dart';

import '../../view/welcome/welcome_view.dart';

class LoadingViewModel extends ChangeNotifier {
  final RoutingService _routingService;
  bool _isLoading = true;
  String? _errorMessage;
  late RouteCondition _conditions;
  Widget? _nextPage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Widget? get nextPage => _nextPage;

  LoadingViewModel(this._routingService);

  Future<void> checkRouteCondition() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final hasConnection = await ConnectionChecker.hasConnection();
      if (!hasConnection) {
        _errorMessage = 'No internet connection. Please check your network settings and try again.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _conditions = await _routingService.getRouteCondition();
      _determineNextPage();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Unable to connect to server. Please try again later.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _determineNextPage() async {
    var savedLanguageCode = 'en';
    try {
      final prefs = await SharedPreferences.getInstance();
      print(prefs.getString('languageCode'));
      savedLanguageCode = prefs.getString('languageCode') ?? 'en';
    } finally {
    }
    if (!_conditions.isUserExist) {
      _nextPage = const WelcomeView();
    } else if (!_conditions.isCredentialsValid) {
      print(_conditions.isProfileComplete);
      _nextPage = LoginScreen(languageCode: savedLanguageCode,); // Add this page
    } else if (!_conditions.isOnboardingComplete) {
      _nextPage = const WelcomeView();
    } else if (!_conditions.isProfileComplete) {
      _nextPage = PhoneVerificationView(languageCode: savedLanguageCode);
    } else {
      _nextPage = LoginScreen(languageCode: savedLanguageCode,);
    }
  }
}

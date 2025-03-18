import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionChecker {
  static Future<bool> hasConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }
}

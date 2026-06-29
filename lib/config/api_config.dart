import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // Chrome / Web
    if (kIsWeb) {
      return "http://127.0.0.1:8000/api";
    }

    // Android Emulator
    return "http://10.0.2.2:8000/api";
  }

  static String get register => "$baseUrl/register/";
  static String get login => "$baseUrl/login/";
}
import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();

  static Future<String?> _getAccessToken() async {
    try {} catch (e) {
      log('$e');
      return null;
    }
    return null;
  }
}

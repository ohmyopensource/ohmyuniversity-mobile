import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_session_model.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._storage);

  static const _sessionKey = 'auth_session';
  static const _bookingHistoryKey = 'exam_booking_history';
  final FlutterSecureStorage _storage;

  Future<void> saveSession(AuthSessionModel session) {
    return _storage.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<AuthSessionModel?> readSession() async {
    try {
      final value = await _storage.read(key: _sessionKey);
      if (value == null || value.isEmpty) return null;
      return AuthSessionModel.fromStoredJson(
        jsonDecode(value) as Map<String, dynamic>,
      );
    } on FormatException {
      await clearSession();
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> clearSession() {
    return Future.wait([
      _storage.delete(key: _sessionKey),
      _storage.delete(key: _bookingHistoryKey),
    ]);
  }
}

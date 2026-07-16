import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tankio/models/user_authentication_response.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const _refreshTokenKey = "refresh_token";
  static const _accessTokenKey = "access_token";
  static const _sessionSnapshotKey = "session_snapshot";
  static const _biometricEnabledKey = "biometric_enabled";

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);

    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<bool> saveBiometricEnable(bool value) async {
    await _storage.write(key: _biometricEnabledKey, value: value.toString());
    return true;
  }

  Future<bool> readBiometricEnable() async {
    String biometricEnabled = "false";
    biometricEnabled =
        await _storage.read(key: _biometricEnabledKey) ?? "false";
    return bool.parse(biometricEnabled.toString());
  }

  Future<void> saveSessionSnapshot(UserAuthentication session) async {
    await _storage.write(
      key: _sessionSnapshotKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<UserAuthentication?> readSessionSnapshot() async {
    final rawSession = await _storage.read(key: _sessionSnapshotKey);
    if (rawSession == null || rawSession.isEmpty) {
      return null;
    }

    return UserAuthentication.fromJson(
      Map<String, dynamic>.from(jsonDecode(rawSession)),
    );
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> clearSessionData() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _sessionSnapshotKey);
  }

  Future<void> clearAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}

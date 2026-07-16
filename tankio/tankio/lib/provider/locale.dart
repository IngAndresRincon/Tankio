import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/services/secure_storage_service.dart';

class LocaleController extends AsyncNotifier<Locale> {
  final SecureStorageService _storage = SecureStorageService();

  @override
  Future<Locale> build() async {
    final languageCode = await _storage.readLocale();
    return Locale(languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    state = AsyncData(locale);
    await _storage.saveLocale(locale.languageCode);
  }
}

final localeProvider =
    AsyncNotifierProvider<LocaleController, Locale>(LocaleController.new);

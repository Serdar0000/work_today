// Сохранённый язык интерфейса (ru / en / kk).

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class AppLocaleController {
  AppLocaleController._();

  static final ValueNotifier<Locale> notifier =
      ValueNotifier(const Locale('ru'));

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.kAppLocaleKey)?.trim() ?? 'ru';
    notifier.value = Locale(_normalize(raw));
  }

  static String _normalize(String code) {
    switch (code) {
      case 'en':
        return 'en';
      case 'kk':
        return 'kk';
      default:
        return 'ru';
    }
  }

  static Future<void> setLocale(Locale locale) async {
    final code = _normalize(locale.languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.kAppLocaleKey, code);
    notifier.value = Locale(code);
  }

  /// Подпись для списка выбора (нейтрально для любого текущего UI).
  static String nativeLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'kk':
        return 'Қазақша';
      default:
        return 'Русский';
    }
  }
}

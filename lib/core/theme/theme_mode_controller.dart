import 'package:flutter/material.dart';

class ThemeModeController {
  ThemeModeController._();

  static final ValueNotifier<ThemeMode> notifier =
      ValueNotifier(ThemeMode.system);
}

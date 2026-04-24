// Слой: core | Назначение: опциональный обход реальной авторизации только в debug-сборке

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/entities/user.dart';

/// Включается только при [kDebugMode] и явном флаге (см. [.isBypassEnabled]).
class DebugAuthConfig {
  DebugAuthConfig._();

  static const String _envKey = 'DEBUG_AUTH_BYPASS';

  static bool get isBypassEnabled {
    if (!kDebugMode) return false;

    const fromDefine = String.fromEnvironment(_envKey, defaultValue: '');
    final d = fromDefine.trim().toLowerCase();
    if (d == 'true' || d == '1' || d == 'yes') return true;
    if (d == 'false' || d == '0' || d == 'no') return false;

    final e = dotenv.env[_envKey]?.trim().toLowerCase() ?? '';
    return e == 'true' || e == '1' || e == 'yes';
  }

  static User bypassUser() {
    final role = _parseRole(dotenv.env['DEBUG_AUTH_ROLE']);
    final email = _trimOr(
      dotenv.env['DEBUG_AUTH_EMAIL'],
      'debug@local.dev',
    );
    final name = _trimOr(
      dotenv.env['DEBUG_AUTH_NAME'],
      'Debug User',
    );
    const authUid = 'debug-local';
    return User(
      id: authUid.hashCode & 0x7fffffff,
      authUid: authUid,
      email: email,
      name: name,
      role: role,
      createdAt: DateTime.utc(2020),
    );
  }

  static UserRole _parseRole(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'company':
      case 'employer':
        return UserRole.company;
      default:
        return UserRole.worker;
    }
  }

  static String _trimOr(String? value, String fallback) {
    final t = value?.trim();
    if (t == null || t.isEmpty) return fallback;
    return t;
  }
}

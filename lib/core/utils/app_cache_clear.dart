// Очистка временных файлов, RAM-кэша изображений и «лишних» ключей SharedPreferences.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Ключи сессии не трогаем — пользователь остаётся в аккаунте.
const Set<String> _prefsKeysToKeep = {
  AppConstants.kSessionKey,
  AppConstants.kSessionAuthUidKey,
  AppConstants.kUserEmailKey,
  AppConstants.kUserRoleKey,
};

class AppCacheClear {
  AppCacheClear._();

  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes Б';
    }
    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} КБ';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} МБ';
  }

  /// Приблизительный объём кэша (временные папки + не-сессионные prefs).
  static Future<int> estimateBytes() async {
    var total = 0;
    if (!kIsWeb) {
      try {
        total += await _dirSize(await getTemporaryDirectory());
      } catch (_) {}
      try {
        total += await _dirSize(await getApplicationCacheDirectory());
      } catch (_) {}
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final k in prefs.getKeys()) {
        if (_prefsKeysToKeep.contains(k)) continue;
        final o = prefs.get(k);
        if (o is String) {
          total += o.length * 2;
        } else if (o is List<String>) {
          for (final s in o) {
            total += s.length * 2;
          }
        }
      }
    } catch (_) {}
    return total;
  }

  /// Реальная очистка: [ImageCache], temp/cache на диске, prefs кроме сессии.
  static Future<int> clear() async {
    var freed = 0;

    final imageCache = PaintingBinding.instance.imageCache;
    freed += imageCache.currentSizeBytes;
    imageCache.clear();
    imageCache.clearLiveImages();

    if (!kIsWeb) {
      try {
        freed += await _emptyDirectory(await getTemporaryDirectory());
      } catch (_) {}
      try {
        freed += await _emptyDirectory(await getApplicationCacheDirectory());
      } catch (_) {}
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().toList();
      for (final k in keys) {
        if (_prefsKeysToKeep.contains(k)) continue;
        final o = prefs.get(k);
        if (o is String) {
          freed += o.length * 2;
        } else if (o is List<String>) {
          for (final s in o) {
            freed += s.length * 2;
          }
        }
        await prefs.remove(k);
      }
    } catch (_) {}

    return freed;
  }

  static Future<int> _dirSize(Directory root) async {
    if (!await root.exists()) return 0;
    var n = 0;
    try {
      await for (final e in root.list(recursive: true, followLinks: false)) {
        if (e is File) {
          try {
            n += await e.length();
          } catch (_) {}
        }
      }
    } catch (_) {}
    return n;
  }

  static Future<int> _emptyDirectory(Directory root) async {
    if (!await root.exists()) return 0;
    var freed = 0;
    try {
      await for (final e in root.list(followLinks: false)) {
        try {
          if (e is File) {
            freed += await e.length();
          } else if (e is Directory) {
            freed += await _dirSize(Directory(e.path));
          }
          await e.delete(recursive: true);
        } catch (_) {}
      }
    } catch (_) {}
    return freed;
  }
}

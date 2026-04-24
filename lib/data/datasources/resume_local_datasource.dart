// Слой: data | Назначение: резюме в SharedPreferences (без Firebase / debug)

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ResumeLocalDatasource {
  static String _key(String documentKey) => 'resume_json_$documentKey';

  Future<Map<String, dynamic>?> loadMap(String documentKey) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(documentKey));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  Future<void> saveMap(String documentKey, Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(documentKey), jsonEncode(map));
  }
}

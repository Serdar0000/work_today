// Слой: domain | Назначение: лого/аватар в профиле — base64 + MIME для Firestore

import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Данные изображения, сохраняемого в `profiles/{uid}.companyLogo`.
/// На регистрации не заполняется; задаётся позже в профиле.
class CompanyLogoData extends Equatable {
  const CompanyLogoData({
    required this.base64,
    required this.mimeType,
  });

  /// Сырая base64-строка (без префикса `data:...;base64,` или с ним).
  final String base64;
  final String mimeType;

  static CompanyLogoData fromImageBytes(List<int> bytes, String mimeType) {
    return CompanyLogoData(
      base64: base64Encode(bytes),
      mimeType: mimeType,
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'base64': base64,
        'mimeType': mimeType,
      };

  static CompanyLogoData? tryFromFirestoreValue(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is! Map) {
      return null;
    }
    final map = Map<String, dynamic>.from(value);
    final raw = map['base64'] as String? ?? map['data'] as String?;
    final mime =
        (map['mimeType'] as String?)?.trim().isNotEmpty == true
            ? map['mimeType'] as String
            : 'image/png';
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return CompanyLogoData(base64: raw, mimeType: mime);
  }

  /// Байты для [Image.memory] / декодинга.
  List<int> decodeToBytes() {
    final part = _payloadOnlyBase64();
    return base64Decode(part);
  }

  String _payloadOnlyBase64() {
    var s = base64.trim();
    final comma = s.indexOf(',');
    if (s.startsWith('data:') && comma > 0) {
      s = s.substring(comma + 1);
    }
    return s.replaceAll('\n', '');
  }

  @override
  List<Object?> get props => [base64, mimeType];
}

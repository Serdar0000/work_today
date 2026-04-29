import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/company_profile.dart';

class CompanyProfileRemoteDatasource {
  CompanyProfileRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _companyProfiles =>
      _firestore.collection('companyProfiles');

  Future<CompanyProfile?> getByUid(String uid) async {
    final doc = await _companyProfiles.doc(uid).get();
    final data = doc.data();
    if (data == null) {
      return null;
    }
    return _map(uid, data);
  }

  CompanyProfile _map(String uid, Map<String, dynamic> data) {
    final createdAt = _parseDate(data['createdAt']);
    final updatedAt = _parseDate(data['updatedAt']);
    final memberSinceYear = (data['memberSinceYear'] as num?)?.toInt() ??
        createdAt.year;

    return CompanyProfile(
      accountUid: uid,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
      phone: (data['phone'] as String?) ?? '',
      city: (data['city'] as String?) ?? '',
      industry: (data['industry'] as String?) ?? '',
      website: (data['website'] as String?) ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 0,
      activeVacancies: (data['activeVacancies'] as num?)?.toInt() ?? 0,
      hiredCount: (data['hiredCount'] as num?)?.toInt() ?? 0,
      memberSinceYear: memberSinceYear,
    );
  }

  DateTime _parseDate(Object? raw) {
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is DateTime) {
      return raw;
    }
    return DateTime.tryParse(raw?.toString() ?? '') ?? DateTime.now();
  }
}

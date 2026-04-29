import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../domain/entities/item.dart' as item_entity;

class ItemRemoteDatasource {
  ItemRemoteDatasource({
    FirebaseFirestore? firestore,
    fb_auth.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final fb_auth.FirebaseAuth? _auth;

  CollectionReference<Map<String, dynamic>> get _vacancies =>
      _firestore.collection('vacancies');

  Future<List<item_entity.Item>> getAll() async {
    final snapshot =
        await _vacancies.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => _mapItem(doc.data())).toList();
  }

  Future<item_entity.Item?> getById(int id) async {
    final doc = await _vacancies.doc(id.toString()).get();
    final data = doc.data();
    if (data == null) {
      return null;
    }
    return _mapItem(data);
  }

  Future<item_entity.Item> create({
    required String title,
    String? description,
    String? companyName,
    int? salaryFrom,
    int? salaryTo,
    String? category,
    String? schedule,
    String? location,
    bool? isHot,
  }) async {
    final now = DateTime.now();
    final id = now.microsecondsSinceEpoch;
    final ownerUid = _currentUserUid();
    if (ownerUid.isEmpty) {
      throw Exception('Нельзя создать вакансию без авторизации');
    }
    final payload = {
      'id': id,
      'title': title,
      'description': description,
      'status': item_entity.ItemStatus.active.index,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
      'ownerUid': ownerUid,
      'companyName': '',
      'salaryFrom': salaryFrom,
      'salaryTo': salaryTo,
      'category': category ?? '',
      'schedule': schedule ?? '',
      'location': location ?? '',
      'isHot': isHot ?? false,
      'viewsCount': 0,
      'applicationsCount': 0,
    };
    payload['companyName'] = (companyName ?? '').trim();

    await _vacancies.doc(id.toString()).set(payload);
    return _mapItem(payload);
  }

  Future<item_entity.Item> update(item_entity.Item item) async {
    final ownerUid = _currentUserUid();
    if (ownerUid.isEmpty || (item.ownerUid.isNotEmpty && item.ownerUid != ownerUid)) {
      throw Exception('Нет доступа к обновлению вакансии');
    }
    final now = DateTime.now();
    await _vacancies.doc(item.id.toString()).update({
      'title': item.title,
      'description': item.description,
      'status': item.status.index,
      'ownerUid': item.ownerUid.isEmpty ? ownerUid : item.ownerUid,
      'updatedAt': Timestamp.fromDate(now),
    });

    final updatedDoc = await _vacancies.doc(item.id.toString()).get();
    final updatedData = updatedDoc.data();
    if (updatedData == null) {
      throw Exception('Вакансия не найдена');
    }
    return _mapItem(updatedData);
  }

  Future<void> delete(int id) async {
    await _vacancies.doc(id.toString()).delete();
  }

  Future<List<item_entity.Item>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return getAll();
    }

    final all = await getAll();
    return all.where((item) {
      final title = item.title.toLowerCase();
      final description = (item.description ?? '').toLowerCase();
      return title.contains(q) || description.contains(q);
    }).toList();
  }

  Future<List<item_entity.Item>> filterByStatus(
      item_entity.ItemStatus status) async {
    final snapshot =
        await _vacancies.where('status', isEqualTo: status.index).get();
    return snapshot.docs.map((doc) => _mapItem(doc.data())).toList();
  }

  item_entity.Item _mapItem(Map<String, dynamic> data) {
    final createdAt = _parseDate(data['createdAt']);
    final updatedAt = _parseDate(data['updatedAt']);
    final statusIndex = (data['status'] as num?)?.toInt() ?? 0;

    return item_entity.Item(
      id: (data['id'] as num?)?.toInt() ??
          DateTime.now().microsecondsSinceEpoch,
      title: (data['title'] as String?) ?? '',
      description: data['description'] as String?,
      status:
          statusIndex >= 0 && statusIndex < item_entity.ItemStatus.values.length
              ? item_entity.ItemStatus.values[statusIndex]
              : item_entity.ItemStatus.active,
      createdAt: createdAt,
      updatedAt: updatedAt,
      ownerUid: (data['ownerUid'] as String?) ?? '',
      companyName: (data['companyName'] as String?) ?? '',
      salaryFrom: (data['salaryFrom'] as num?)?.toInt(),
      salaryTo: (data['salaryTo'] as num?)?.toInt(),
      category: (data['category'] as String?) ?? '',
      schedule: (data['schedule'] as String?) ?? '',
      location: (data['location'] as String?) ?? '',
      isHot: (data['isHot'] as bool?) ?? false,
      viewsCount: (data['viewsCount'] as num?)?.toInt() ?? 0,
      applicationsCount: (data['applicationsCount'] as num?)?.toInt() ?? 0,
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

  String _currentUserUid() {
    final explicit = _auth?.currentUser?.uid;
    if (explicit != null && explicit.isNotEmpty) {
      return explicit;
    }
    try {
      final uid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
      return uid ?? '';
    } catch (_) {
      return '';
    }
  }
}

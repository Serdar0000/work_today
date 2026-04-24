import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/item.dart' as item_entity;

class ItemRemoteDatasource {
  ItemRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

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
  }) async {
    final now = DateTime.now();
    final id = now.microsecondsSinceEpoch;
    final payload = {
      'id': id,
      'title': title,
      'description': description,
      'status': item_entity.ItemStatus.active.index,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    };

    await _vacancies.doc(id.toString()).set(payload);
    return _mapItem(payload);
  }

  Future<item_entity.Item> update(item_entity.Item item) async {
    final now = DateTime.now();
    await _vacancies.doc(item.id.toString()).update({
      'title': item.title,
      'description': item.description,
      'status': item.status.index,
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

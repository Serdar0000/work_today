// Слой: data | Назначение: локальный источник данных для CRUD-операций над Items

import 'package:drift/drift.dart';

import '../../domain/entities/item.dart' as item_entity;
import '../mappers/database_mappers.dart';
import 'app_database.dart';

class ItemLocalDatasource {
  ItemLocalDatasource(this._db);

  final AppDatabase _db;

  Future<List<item_entity.Item>> getAll() async {
    final rows = await _db.select(_db.items).get();
    return rows.map((r) => r.toEntity()).toList();
  }

  Future<item_entity.Item?> getById(int id) async {
    final row = await (_db.select(_db.items)
          ..where((i) => i.id.equals(id)))
        .getSingleOrNull();
    return row?.toEntity();
  }

  Future<item_entity.Item> create({required String title, String? description}) async {
    final now = DateTime.now();
    final id = await _db.into(_db.items).insert(
          ItemsCompanion.insert(
            title: title,
            description: Value(description),
            createdAt: now,
            updatedAt: now,
          ),
        );

    final row = await (_db.select(_db.items)
          ..where((i) => i.id.equals(id)))
        .getSingle();
    return row.toEntity();
  }

  Future<item_entity.Item> update(item_entity.Item item) async {
    await (_db.update(_db.items)..where((i) => i.id.equals(item.id))).write(
      ItemsCompanion(
        title: Value(item.title),
        description: Value(item.description),
        status: Value(item.status),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final row = await (_db.select(_db.items)
          ..where((i) => i.id.equals(item.id)))
        .getSingle();
    return row.toEntity();
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.items)..where((i) => i.id.equals(id))).go();
  }

  Future<List<item_entity.Item>> search(String query) async {
    final rows = await (_db.select(_db.items)
          ..where((i) => i.title.contains(query) | i.description.contains(query)))
        .get();
    return rows.map((r) => r.toEntity()).toList();
  }

  Future<List<item_entity.Item>> filterByStatus(item_entity.ItemStatus status) async {
    final rows = await (_db.select(_db.items)
          ..where((i) => i.status.equals(status.index)))
        .get();
    return rows.map((r) => r.toEntity()).toList();
  }
}

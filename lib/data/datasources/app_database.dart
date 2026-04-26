// Слой: data | Назначение: Drift AppDatabase — singleton, таблицы, маппер-расширения

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/item.dart' show ItemStatus;
import '../models/item_model.dart';
import '../models/user_model.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Items])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // Статический синглтон для простого доступа без DI-фреймворка
  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase();

  @override
  int get schemaVersion => 3;

  // Миграции при обновлении схемы
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await customStatement(
              "ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT 'worker'",
            );
          }
          if (from < 3) {
            await m.addColumn(users, users.hasJobSeeker);
            await m.addColumn(users, users.hasCompany);
            await customStatement(
              "UPDATE users SET has_job_seeker = 1, has_company = 0 WHERE role = 'worker'",
            );
            await customStatement(
              "UPDATE users SET has_job_seeker = 0, has_company = 1 WHERE role = 'company'",
            );
          }
        },
      );
}

// Открытие соединения с файлом БД в директории документов устройства
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

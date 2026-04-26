// Слой: data | Назначение: определение Drift-таблицы Users

import 'package:drift/drift.dart';

// Drift-таблица пользователей (генерирует UserData, UsersCompanion)
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get password => text()();
  TextColumn get name => text()();
  /// Активный сценарий UI (соискатель / компания) — не «тип аккаунта».
  TextColumn get role => text()();
  BoolColumn get hasJobSeeker => boolean().withDefault(const Constant(false))();
  BoolColumn get hasCompany => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

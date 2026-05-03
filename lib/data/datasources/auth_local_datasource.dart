// Слой: data | Назначение: локальный источник данных авторизации (Drift + SharedPreferences)

import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart' as user_entity;
import '../mappers/database_mappers.dart';
import 'app_database.dart';

class AuthLocalDatasource {
  AuthLocalDatasource(this._db);

  final AppDatabase _db;

  // Регистрация: создаёт запись в таблице Users
  Future<user_entity.User> register({
    required String name,
    required String email,
    required String password,
    required user_entity.UserRole role,
  }) async {
    final existing = await (_db.select(_db.users)
          ..where((u) => u.email.equals(email)))
        .getSingleOrNull();

    if (existing != null) {
      throw Exception('Пользователь с email $email уже существует');
    }

    final hJs = role == user_entity.UserRole.worker;
    final hCo = role == user_entity.UserRole.company;

    final id = await _db.into(_db.users).insert(
          UsersCompanion.insert(
            name: name,
            email: email,
            password: password,
            role: role.name,
            hasJobSeeker: Value(hJs),
            hasCompany: Value(hCo),
            createdAt: DateTime.now(),
          ),
        );

    final userData = await (_db.select(_db.users)
          ..where((u) => u.id.equals(id)))
        .getSingle();

    return userData.toEntity();
  }

  // Вход: email + пароль; роль можно сменить как на экране Firebase-режима.
  Future<user_entity.User> login({
    required String email,
    required String password,
    required user_entity.UserRole selectedRole,
  }) async {
    final userData = await (_db.select(_db.users)
          ..where((u) => u.email.equals(email)))
        .getSingleOrNull();

    if (userData == null) {
      throw Exception('Пользователь не найден');
    }

    if (userData.password != password) {
      throw Exception('Неверный пароль');
    }

    var hJs = userData.hasJobSeeker;
    var hCo = userData.hasCompany;
    if (selectedRole == user_entity.UserRole.worker && !hJs) {
      hJs = true;
    }
    if (selectedRole == user_entity.UserRole.company && !hCo) {
      hCo = true;
    }

    if (userData.role != selectedRole.name ||
        userData.hasJobSeeker != hJs ||
        userData.hasCompany != hCo) {
      await (_db.update(_db.users)..where((u) => u.id.equals(userData.id)))
          .write(UsersCompanion(
        role: Value(selectedRole.name),
        hasJobSeeker: Value(hJs),
        hasCompany: Value(hCo),
      ));
      final updated = await (_db.select(_db.users)
            ..where((u) => u.id.equals(userData.id)))
            .getSingle();
      return updated.toEntity();
    }

    return userData.toEntity();
  }

  Future<user_entity.User> switchContext({
    required user_entity.UserRole selectedRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.kSessionKey);
    if (userId == null) {
      throw Exception('Сессия не найдена, войдите снова');
    }

    final userData = await (_db.select(_db.users)..where((u) => u.id.equals(userId)))
        .getSingleOrNull();
    if (userData == null) {
      throw Exception('Пользователь не найден');
    }

    var hasJobSeeker = userData.hasJobSeeker;
    var hasCompany = userData.hasCompany;
    if (selectedRole == user_entity.UserRole.worker) {
      hasJobSeeker = true;
    } else {
      hasCompany = true;
    }

    await (_db.update(_db.users)..where((u) => u.id.equals(userData.id))).write(
      UsersCompanion(
        role: Value(selectedRole.name),
        hasJobSeeker: Value(hasJobSeeker),
        hasCompany: Value(hasCompany),
      ),
    );

    final updated =
        await (_db.select(_db.users)..where((u) => u.id.equals(userData.id)))
            .getSingle();
    return updated.toEntity();
  }

  // Сохранение сессии в SharedPreferences
  Future<void> saveSession(user_entity.User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.kSessionKey, user.id);
    await prefs.setString(AppConstants.kUserEmailKey, user.email);
    await prefs.setString(AppConstants.kUserRoleKey, user.activeContext.name);
  }

  // Чтение сессии при запуске приложения
  Future<user_entity.User?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.kSessionKey);

    if (userId == null) return null;

    final userData = await (_db.select(_db.users)
          ..where((u) => u.id.equals(userId)))
        .getSingleOrNull();

    return userData?.toEntity();
  }

  // Очистка сессии при выходе
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.kSessionKey);
    await prefs.remove(AppConstants.kUserEmailKey);
    await prefs.remove(AppConstants.kUserRoleKey);
  }

  Future<user_entity.User> updateAccountProfile({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.kSessionKey);
    if (userId == null) {
      throw Exception('Сессия не найдена, войдите снова');
    }

    final trimmedName = name.trim();
    final normalizedEmail = email.trim().toLowerCase();
    if (trimmedName.isEmpty) {
      throw Exception('Укажите имя');
    }
    if (normalizedEmail.isEmpty) {
      throw Exception('Укажите email');
    }

    final duplicate = await (_db.select(_db.users)
          ..where((u) => u.email.equals(normalizedEmail)))
        .getSingleOrNull();
    if (duplicate != null && duplicate.id != userId) {
      throw Exception('Этот email уже занят другим аккаунтом');
    }

    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        name: Value(trimmedName),
        email: Value(normalizedEmail),
      ),
    );

    final row = await (_db.select(_db.users)..where((u) => u.id.equals(userId)))
        .getSingle();
    final user = row.toEntity();
    await saveSession(user);
    return user;
  }
}


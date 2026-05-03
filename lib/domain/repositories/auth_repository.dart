// Слой: domain | Назначение: абстрактный интерфейс репозитория авторизации

import '../entities/company_logo_data.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// [selectedRole] — роль с экрана входа; синхронизируется с хранилищем, чтобы можно было менять тип аккаунта.
  Future<User> login({
    required String email,
    required String password,
    required UserRole selectedRole,
  });

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    CompanyLogoData? companyLogo,
  });

  /// [selectedRole] — как вошли с экрана (синхронизируется с Firestore).
  Future<User> signInWithGoogle({required UserRole selectedRole});

  /// Переключение контекста между worker/company без повторной регистрации.
  Future<User> switchContext({required UserRole selectedRole});

  Future<User?> checkSession();

  /// Имя и email в [users] / связанных коллекциях (и локально в Drift при fallback).
  Future<User> updateAccountProfile({
    required String name,
    required String email,
  });

  /// Смена пароля (email-аккаунт Firebase или локальный Drift). Требует текущий пароль.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> logout();
}

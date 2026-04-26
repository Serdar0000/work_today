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

  Future<User?> checkSession();

  Future<void> logout();
}

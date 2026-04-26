// Слой: domain | Назначение: абстрактный интерфейс репозитория авторизации

import '../entities/company_logo_data.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    CompanyLogoData? companyLogo,
  });

  /// Новый Google-аккаунт создаётся как [UserRole.worker]; дальше роль только в хранилище.
  Future<User> signInWithGoogle();

  Future<User?> checkSession();

  Future<void> logout();
}

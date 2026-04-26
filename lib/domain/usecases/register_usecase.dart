// Слой: domain | Назначение: use case регистрации нового пользователя

import 'package:equatable/equatable.dart';
import '../entities/company_logo_data.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_usecase.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<User> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      role: params.role,
      companyLogo: params.companyLogo,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    this.role = UserRole.worker,
    this.companyLogo,
  });

  final String name;
  final String email;
  final String password;
  /// Сейчас при стандартной регистрации всегда [UserRole.worker];
  /// роль «компания» можно включить отдельным сценарием в профиле.
  final UserRole role;
  final CompanyLogoData? companyLogo;

  @override
  List<Object?> get props => [name, email, password, role, companyLogo];
}

// Слой: domain | Назначение: use case входа по email и паролю

import 'package:equatable/equatable.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_usecase.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<User> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
      role: params.role,
    );
  }
}

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final UserRole role;

  @override
  List<Object?> get props => [email, password, role];
}

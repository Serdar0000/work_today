// Слой: domain | Обновление имени и email аккаунта

import 'package:equatable/equatable.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'base_usecase.dart';

class UpdateAccountProfileUseCase
    implements UseCase<User, UpdateAccountProfileParams> {
  UpdateAccountProfileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<User> call(UpdateAccountProfileParams params) {
    return _repository.updateAccountProfile(
      name: params.name,
      email: params.email,
    );
  }
}

class UpdateAccountProfileParams extends Equatable {
  const UpdateAccountProfileParams({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  List<Object?> get props => [name, email];
}

// Слой: domain | Назначение: чистая сущность пользователя (без Flutter-зависимостей)

import 'package:equatable/equatable.dart';

enum UserRole { worker, company }

class User extends Equatable {
  const User({
    required this.id,
    this.authUid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  final int id;
  final String? authUid;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, authUid, email, name, role, createdAt];
}

// Слой: presentation | Назначение: события AuthBloc

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
    required this.selectedRole,
  });

  final String email;
  final String password;
  final UserRole selectedRole;

  @override
  List<Object?> get props => [email, password, selectedRole];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.role = UserRole.worker,
  });

  final String name;
  final String email;
  final String password;
  final UserRole role;

  @override
  List<Object?> get props => [name, email, password, role];
}

class AuthCheckSessionRequested extends AuthEvent {
  const AuthCheckSessionRequested();
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested({required this.selectedRole});

  final UserRole selectedRole;

  @override
  List<Object?> get props => [selectedRole];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

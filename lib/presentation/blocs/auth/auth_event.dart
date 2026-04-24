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
    required this.role,
  });

  final String email;
  final String password;
  final UserRole role;

  @override
  List<Object?> get props => [email, password, role];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
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
  const AuthGoogleSignInRequested({required this.role});

  final UserRole role;

  @override
  List<Object?> get props => [role];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

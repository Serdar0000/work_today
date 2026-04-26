// Слой: domain | Аккаунт пользователя. Профили соискателя/компании существуют отдельно;
// [UserRole] здесь — выбранный при входе контекст UI, а не «единственная роль в БД».

import 'package:equatable/equatable.dart';

enum UserRole { worker, company }

class User extends Equatable {
  const User({
    required this.id,
    this.authUid,
    required this.email,
    required this.name,
    required this.hasJobSeekerProfile,
    required this.hasCompanyProfile,
    required this.activeContext,
    required this.createdAt,
  });

  final int id;
  final String? authUid;
  final String email;
  final String name;

  /// Есть ли в данных профиль соискателя (создаётся при первом входе/регистрации как соискатель
  /// или по запросу при входе в сценарий «соискатель»).
  final bool hasJobSeekerProfile;
  final bool hasCompanyProfile;

  /// С какой «шапки» вошли сейчас: соискатель или компания. При наличии обоих — выбор на экране логина.
  final UserRole activeContext;
  final DateTime createdAt;

  bool get isCompanyView => activeContext == UserRole.company;
  bool get isJobSeekerView => activeContext == UserRole.worker;

  @override
  List<Object?> get props => [
        id,
        authUid,
        email,
        name,
        hasJobSeekerProfile,
        hasCompanyProfile,
        activeContext,
        createdAt,
      ];
}

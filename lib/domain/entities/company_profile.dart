// Слой: domain | Профиль компании, привязанный к аккаунту [User] (тот же uid/идентификатор).

import 'package:equatable/equatable.dart';

class CompanyProfile extends Equatable {
  const CompanyProfile({
    required this.accountUid,
    required this.createdAt,
  });

  /// Firestore: doc id в коллекции companyProfiles (совпадает с uid в Firebase Auth).
  final String accountUid;
  final DateTime createdAt;

  @override
  List<Object?> get props => [accountUid, createdAt];
}

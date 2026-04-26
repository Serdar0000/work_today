// Слой: domain | Профиль соискателя, привязанный к аккаунту [User] (тот же uid/идентификатор).

import 'package:equatable/equatable.dart';

class JobSeekerProfile extends Equatable {
  const JobSeekerProfile({
    required this.accountUid,
    required this.createdAt,
  });

  /// Firestore: doc id в коллекции jobSeekerProfiles (совпадает с uid в Firebase Auth).
  final String accountUid;
  final DateTime createdAt;

  @override
  List<Object?> get props => [accountUid, createdAt];
}

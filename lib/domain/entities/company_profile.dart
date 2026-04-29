// Слой: domain | Профиль компании, привязанный к аккаунту [User] (тот же uid/идентификатор).

import 'package:equatable/equatable.dart';

class CompanyProfile extends Equatable {
  const CompanyProfile({
    required this.accountUid,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.phone = '',
    this.city = '',
    this.industry = '',
    this.website = '',
    this.rating = 0,
    this.reviewsCount = 0,
    this.activeVacancies = 0,
    this.hiredCount = 0,
    this.memberSinceYear,
  });

  /// Firestore: doc id в коллекции companyProfiles (совпадает с uid в Firebase Auth).
  final String accountUid;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phone;
  final String city;
  final String industry;
  final String website;
  final double rating;
  final int reviewsCount;
  final int activeVacancies;
  final int hiredCount;
  final int? memberSinceYear;

  @override
  List<Object?> get props => [
        accountUid,
        name,
        email,
        createdAt,
        updatedAt,
        phone,
        city,
        industry,
        website,
        rating,
        reviewsCount,
        activeVacancies,
        hiredCount,
        memberSinceYear,
      ];
}

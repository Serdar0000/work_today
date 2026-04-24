// Слой: domain | Назначение: модель резюме для редактирования и Firestore

import 'package:equatable/equatable.dart';

class WorkExperienceItem extends Equatable {
  const WorkExperienceItem({
    required this.id,
    required this.title,
    required this.company,
    required this.periodStartText,
    required this.periodEndText,
    required this.description,
  });

  final String id;
  final String title;
  final String company;
  /// Например «Март 2025» или «01.03.2025»
  final String periodStartText;
  /// Пусто = «Настоящее время»
  final String periodEndText;
  final String description;

  WorkExperienceItem copyWith({
    String? id,
    String? title,
    String? company,
    String? periodStartText,
    String? periodEndText,
    String? description,
  }) {
    return WorkExperienceItem(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      periodStartText: periodStartText ?? this.periodStartText,
      periodEndText: periodEndText ?? this.periodEndText,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'company': company,
        'periodStartText': periodStartText,
        'periodEndText': periodEndText,
        'description': description,
      };

  factory WorkExperienceItem.fromJson(Map<String, dynamic> json) {
    return WorkExperienceItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      periodStartText: json['periodStartText']?.toString() ?? '',
      periodEndText: json['periodEndText']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [id, title, company, periodStartText, periodEndText, description];
}

class LanguageItem extends Equatable {
  const LanguageItem({
    required this.id,
    required this.name,
    required this.level,
  });

  final String id;
  final String name;
  final String level;

  LanguageItem copyWith({String? id, String? name, String? level}) {
    return LanguageItem(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
      };

  factory LanguageItem.fromJson(Map<String, dynamic> json) {
    return LanguageItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, level];
}

class Resume extends Equatable {
  const Resume({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.city,
    required this.birthDate,
    required this.headline,
    required this.about,
    required this.skills,
    required this.workExperience,
    required this.languages,
    required this.isPublic,
  });

  final String fullName;
  final String phone;
  final String email;
  final String city;
  final String birthDate;
  /// Было поле `title` в Firestore (желаемая позиция)
  final String headline;
  final String about;
  final List<String> skills;
  final List<WorkExperienceItem> workExperience;
  final List<LanguageItem> languages;
  final bool isPublic;

  factory Resume.blank({
    required String seedName,
    required String seedEmail,
  }) {
    return Resume(
      fullName: seedName,
      phone: '',
      email: seedEmail,
      city: '',
      birthDate: '',
      headline: 'Соискатель',
      about: '',
      skills: const [],
      workExperience: const [],
      languages: const [],
      isPublic: true,
    );
  }

  Resume copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? city,
    String? birthDate,
    String? headline,
    String? about,
    List<String>? skills,
    List<WorkExperienceItem>? workExperience,
    List<LanguageItem>? languages,
    bool? isPublic,
  }) {
    return Resume(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      city: city ?? this.city,
      birthDate: birthDate ?? this.birthDate,
      headline: headline ?? this.headline,
      about: about ?? this.about,
      skills: skills ?? this.skills,
      workExperience: workExperience ?? this.workExperience,
      languages: languages ?? this.languages,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'name': fullName,
      'email': email,
      'phone': phone,
      'city': city,
      'birthDate': birthDate,
      'title': headline,
      'about': about,
      'skills': skills,
      'workExperience': workExperience.map((e) => e.toJson()).toList(),
      'languages': languages.map((e) => e.toJson()).toList(),
      'isPublic': isPublic,
    };
  }

  @override
  List<Object?> get props => [
        fullName,
        phone,
        email,
        city,
        birthDate,
        headline,
        about,
        skills,
        workExperience,
        languages,
        isPublic,
      ];
}

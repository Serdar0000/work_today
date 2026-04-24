// Слой: data | Назначение: маппинг Firestore ↔ Resume

import '../../domain/entities/resume.dart';

class ResumeMapper {
  ResumeMapper._();

  static Resume fromFirestore(
    Map<String, dynamic> data, {
    required String seedName,
    required String seedEmail,
  }) {
    final skillsRaw = data['skills'];
    final skills = (skillsRaw is List<dynamic>)
        ? skillsRaw.map((e) => e.toString()).toList()
        : <String>[];

    final weRaw = data['workExperience'];
    final workExperience = <WorkExperienceItem>[];
    if (weRaw is List<dynamic>) {
      for (final e in weRaw) {
        if (e is Map<String, dynamic>) {
          workExperience.add(WorkExperienceItem.fromJson(e));
        } else if (e is Map) {
          workExperience.add(
            WorkExperienceItem.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }

    final langRaw = data['languages'];
    final languages = <LanguageItem>[];
    if (langRaw is List<dynamic>) {
      for (final e in langRaw) {
        if (e is Map<String, dynamic>) {
          languages.add(LanguageItem.fromJson(e));
        } else if (e is Map) {
          languages.add(LanguageItem.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }

    final name = (data['name'] as String?)?.trim();
    final email = (data['email'] as String?)?.trim();

    return Resume(
      fullName: (name == null || name.isEmpty) ? seedName : name,
      phone: (data['phone'] as String?)?.trim() ?? '',
      email: (email == null || email.isEmpty) ? seedEmail : email,
      city: (data['city'] as String?)?.trim() ?? '',
      birthDate: (data['birthDate'] as String?)?.trim() ?? '',
      headline: (data['title'] as String?)?.trim().isNotEmpty == true
          ? data['title'] as String
          : 'Соискатель',
      about: (data['about'] as String?)?.trim() ?? '',
      skills: skills,
      workExperience: workExperience,
      languages: languages,
      isPublic: data['isPublic'] as bool? ?? true,
    );
  }
}

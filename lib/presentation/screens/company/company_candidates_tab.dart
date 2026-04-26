// Слой: presentation | Назначение: таб «Кандидаты» — публичные резюме (как в прежнем company home)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class CompanyCandidatesTab extends StatelessWidget {
  const CompanyCandidatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('resumes')
          .where('isPublic', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Не удалось загрузить резюме: ${snapshot.error}',
                style: text.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? const [];

        if (docs.isEmpty) {
          return Center(
            child: Text(
              'Пока нет доступных резюме',
              style: text.titleMedium?.copyWith(
                color: tokens.mutedForeground,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();
            final skills = (data['skills'] as List<dynamic>? ?? const [])
                .map((e) => e.toString())
                .toList();

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: tokens.card,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: tokens.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (data['name'] as String?) ?? 'Без имени',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (data['title'] as String?) ?? 'Соискатель',
                      style: text.bodyMedium?.copyWith(
                        color: tokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (data['about'] as String?)?.trim().isNotEmpty == true
                          ? data['about'] as String
                          : 'О себе пока не заполнено',
                      style: text.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: skills.isEmpty
                          ? [
                              Text(
                                'Навыки не указаны',
                                style: text.bodySmall?.copyWith(
                                  color: tokens.mutedForeground,
                                ),
                              ),
                            ]
                          : skills.take(6).map((skill) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: tokens.muted,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.pill),
                                ),
                                child: Text(skill, style: text.bodySmall),
                              );
                            }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

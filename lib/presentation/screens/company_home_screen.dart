import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../blocs/auth/auth_bloc.dart';

class CompanyHomeScreen extends StatelessWidget {
  const CompanyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: const Text('Кабинет компании'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Выйти',
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? const [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'База резюме соискателей',
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Компания видит публичные резюме в реальном времени.',
                        style: text.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (docs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Пока нет доступных резюме',
                    style: text.titleMedium,
                  ),
                )
              else
                ...docs.map((doc) {
                  final data = doc.data();
                  final skills = (data['skills'] as List<dynamic>? ?? const [])
                      .map((e) => e.toString())
                      .toList();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
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
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

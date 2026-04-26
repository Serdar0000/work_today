import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';

class VacancyDetailsScreen extends StatelessWidget {
  const VacancyDetailsScreen({super.key, required this.vacancy});

  final Map<String, dynamic>? vacancy;

  @override
  Widget build(BuildContext context) {
    final data = vacancy ??
        const {
          'id': 'vac-000',
          'title': 'Неизвестная вакансия',
          'company': 'Компания не указана',
          'salary': 'Зарплата не указана',
          'category': 'Без категории',
        };

    return AppSafeScaffold(
      appBar: AppBar(title: const Text('Детали вакансии')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] as String,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.apartment_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(data['company'] as String),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.payments_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        data['salary'] as String,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.category_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(data['category'] as String),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Описание',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Сменный график, быстрое оформление, выплаты каждую неделю. '
            'На следующем этапе сюда придет текст из Firebase.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push(AppConstants.routeMyApplications),
            icon: const Icon(Icons.send_rounded),
            label: const Text('Откликнуться'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Назад к списку'),
          ),
        ],
      ),
    );
  }
}

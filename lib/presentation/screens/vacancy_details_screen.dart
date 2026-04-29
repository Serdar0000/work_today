import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../domain/entities/item.dart';
import '../blocs/item/item_bloc.dart';

class VacancyDetailsScreen extends StatelessWidget {
  const VacancyDetailsScreen({super.key, required this.vacancyId});

  final int vacancyId;

  @override
  Widget build(BuildContext context) {
    final itemBloc = context.read<ItemBloc>();
    if (itemBloc.state is ItemInitial) {
      itemBloc.add(const ItemLoaded());
    }

    return AppSafeScaffold(
      appBar: AppBar(title: const Text('Детали вакансии')),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading || state is ItemInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ItemFailure) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          final items = state is ItemSuccess ? state.items : <Item>[];
          Item? vacancy;
          for (final item in items) {
            if (item.id == vacancyId) {
              vacancy = item;
              break;
            }
          }
          if (vacancy == null) {
            return const Center(child: Text('Вакансия не найдена'));
          }
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
                        vacancy.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.apartment_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(vacancy.companyName.isEmpty
                              ? 'Компания не указана'
                              : vacancy.companyName),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.payments_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _salaryLabel(vacancy),
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
                          Text(vacancy.category.isEmpty
                              ? 'Без категории'
                              : vacancy.category),
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
                vacancy.description?.trim().isNotEmpty == true
                    ? vacancy.description!
                    : 'Описание пока не добавлено',
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
          );
        },
      ),
    );
  }

  String _salaryLabel(Item vacancy) {
    final from = vacancy.salaryFrom;
    final to = vacancy.salaryTo;
    if (from == null && to == null) {
      return 'Зарплата не указана';
    }
    if (from != null && to != null) {
      return '$from - $to тг';
    }
    return 'от ${from ?? to} тг';
  }
}

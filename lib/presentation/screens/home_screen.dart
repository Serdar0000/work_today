// Слой: presentation | Назначение: главный экран вакансий EasyShift

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../blocs/auth/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Все';

  static const List<String> _categories = [
    'Все',
    'Склад',
    'Курьер',
    'Касса',
    'Клининг',
  ];

  static const List<Map<String, dynamic>> _vacancies = [
    {
      'id': 'vac-001',
      'title': 'Сборщик заказов',
      'company': 'Market Hub',
      'salary': '220 000 - 280 000 тг',
      'category': 'Склад',
    },
    {
      'id': 'vac-002',
      'title': 'Курьер на вечерние смены',
      'company': 'FastLine',
      'salary': '200 000 - 320 000 тг',
      'category': 'Курьер',
    },
    {
      'id': 'vac-003',
      'title': 'Кассир выходного дня',
      'company': 'FoodTown',
      'salary': '180 000 - 230 000 тг',
      'category': 'Касса',
    },
    {
      'id': 'vac-004',
      'title': 'Специалист по клинингу',
      'company': 'City Clean',
      'salary': '170 000 - 210 000 тг',
      'category': 'Клининг',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredVacancies {
    final query = _searchController.text.trim().toLowerCase();

    return _vacancies.where((vacancy) {
      final inCategory = _selectedCategory == 'Все' ||
          vacancy['category'] == _selectedCategory;
      final inSearch = query.isEmpty ||
          (vacancy['title'] as String).toLowerCase().contains(query) ||
          (vacancy['company'] as String).toLowerCase().contains(query);
      return inCategory && inSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final vacancies = _filteredVacancies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyShift'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_rounded),
            tooltip: 'Мои отклики',
            onPressed: () => context.push(AppConstants.routeMyApplications),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Статистика',
            onPressed: () => context.push(AppConstants.routeStatistics),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Выйти',
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Offline-first: данные берутся из кэша, если сеть недоступна',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Поиск вакансий и компаний',
              leading: const Icon(Icons.search),
              onChanged: (_) => setState(() {}),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return FilterChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (_) => setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: vacancies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work_off_rounded,
                          size: 56,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Вакансии не найдены',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: vacancies.length,
                    itemBuilder: (context, index) {
                      final vacancy = vacancies[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          title: Text(vacancy['title'] as String),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vacancy['company'] as String),
                                const SizedBox(height: 4),
                                Text(
                                  vacancy['salary'] as String,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push(
                            AppConstants.routeVacancyDetails,
                            extra: vacancy,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

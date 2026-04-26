// Слой: presentation | Назначение: главный экран вакансий EasyShift

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../utils/auth_logout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Все';
  bool _showOfflineBanner = true;

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
      'schedule': 'Сменный',
      'location': 'Алматы',
      'hot': false,
    },
    {
      'id': 'vac-002',
      'title': 'Курьер на вечерние смены',
      'company': 'FastLine',
      'salary': '200 000 - 320 000 тг',
      'category': 'Курьер',
      'schedule': 'Частичная',
      'location': 'Алматы',
      'hot': false,
    },
    {
      'id': 'vac-003',
      'title': 'Кассир выходного дня',
      'company': 'FoodTown',
      'salary': '180 000 - 230 000 тг',
      'category': 'Касса',
      'schedule': 'Выходные',
      'location': 'Точки по городу',
      'hot': false,
    },
    {
      'id': 'vac-004',
      'title': 'Специалист по клинингу',
      'company': 'City Clean',
      'salary': '170 000 - 210 000 тг',
      'category': 'Клининг',
      'schedule': 'Разъездная',
      'location': 'Разъездная',
      'hot': false,
    },
    {
      'id': 'vac-005',
      'title': 'Промоутер',
      'company': 'BrandBoost',
      'salary': '150 000 - 200 000 тг',
      'category': 'Касса',
      'schedule': 'Проектный',
      'location': 'Торговые центры',
      'hot': true,
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
    final colors = Theme.of(context).colorScheme;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    return AppSafeScaffold(
      backgroundColor: tokens.background,
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'E',
                      style: TextStyle(
                        color: tokens.card,
                        fontSize: AppTypography.sectionTitle,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'EasyShift',
                      style: text.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Аккаунт',
                    child: const Icon(Icons.account_circle_outlined),
                    onSelected: (value) {
                      if (value == 'profile') {
                        context.push(AppConstants.routeProfile);
                      } else if (value == 'logout') {
                        showConfirmLogout(context);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'profile',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.person_outline),
                          title: Text('Профиль'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.logout_rounded),
                          title: Text('Выйти'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_showOfflineBanner)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: tokens.muted,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off_rounded,
                          color: colors.onSurfaceVariant),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Offline-first: данные берутся из кэша',
                          style: text.bodyLarge,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _showOfflineBanner = false),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: Container(
                decoration: BoxDecoration(
                  color: tokens.muted,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Поиск вакансий и компаний',
                    hintStyle: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: AppTypography.body,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 14),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _selectedCategory = category),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? colors.primary : tokens.background,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isSelected ? colors.primary : tokens.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (isSelected) ...[
                              Icon(Icons.check, size: 18, color: tokens.card),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              category,
                              style: TextStyle(
                                color:
                                    isSelected ? tokens.card : colors.onSurface,
                                fontSize: AppTypography.bodySmall,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: vacancies.isEmpty
                  ? Center(
                      child: Text(
                        'Вакансии не найдены',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                      itemCount: vacancies.length,
                      itemBuilder: (context, index) {
                        final vacancy = vacancies[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: tokens.card,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            boxShadow: [
                              BoxShadow(
                                color: tokens.foreground.withOpacity(0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 14, 12, 12),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    vacancy['title'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: AppTypography.cardTitle,
                                    ),
                                  ),
                                ),
                                if (vacancy['hot'] == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          tokens.destructive.withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.pill),
                                    ),
                                    child: Text(
                                      'Горячая',
                                      style: TextStyle(
                                        color: tokens.destructive,
                                        fontSize: AppTypography.caption,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.business_outlined,
                                        size: 18,
                                        color: colors.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        vacancy['company'] as String,
                                        style: TextStyle(
                                          fontSize: AppTypography.cardTitle,
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 18,
                                        color: colors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        vacancy['salary'] as String,
                                        style: TextStyle(
                                          color: colors.primary,
                                          fontSize: AppTypography.sectionTitle,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule_outlined,
                                        size: 18,
                                        color: colors.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        vacancy['schedule'] as String,
                                        style: TextStyle(
                                          fontSize: AppTypography.bodySmall,
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              size: 28,
                              color: colors.onSurfaceVariant,
                            ),
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
      bottomNavigationBar: Container(
        height: 92,
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
        decoration: BoxDecoration(
          color: tokens.navBackground,
          border: Border(top: BorderSide(color: tokens.border)),
        ),
        child: Row(
          children: [
            _BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Вакансии',
              selected: true,
              onTap: () {},
            ),
            _BottomNavItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description_rounded,
              label: 'Отклики',
              selected: false,
              onTap: () => context.push(AppConstants.routeMyApplications),
            ),
            _BottomNavItem(
              icon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart_rounded,
              label: 'Статистика',
              selected: false,
              onTap: () => context.push(AppConstants.routeStatistics),
            ),
            _BottomNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Профиль',
              selected: false,
              onTap: () => context.push(AppConstants.routeProfile),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? colors.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? activeIcon : icon,
                color: selected ? colors.primary : colors.onSurfaceVariant,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? colors.primary : colors.onSurfaceVariant,
                  fontSize: AppTypography.caption,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

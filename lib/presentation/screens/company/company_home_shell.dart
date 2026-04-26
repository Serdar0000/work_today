// Слой: presentation | Назначение: shell компании — AppBar + нижняя навигация

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_safe_scaffold.dart';
import 'company_candidates_tab.dart';
import 'company_profile_tab.dart';
import 'company_statistics_tab.dart';
import 'company_vacancies_tab.dart';

const Color _companyNavRed = Color(0xFFDC2626);

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  int _tabIndex = 0;

  String get _appBarTitle {
    return switch (_tabIndex) {
      0 => 'Мои вакансии',
      1 => 'Все кандидаты',
      2 => 'Статистика',
      _ => 'Профиль компании',
    };
  }

  void _onCreateVacancy() {
    // TODO: маршрут «Создать вакансию»
  }

  void _onProfileEdit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Редактирование профиля — скоро')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppSafeScaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(_appBarTitle),
        backgroundColor: tokens.card,
        foregroundColor: tokens.foreground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        actions: [
          if (_tabIndex == 0)
            TextButton(
              onPressed: _onCreateVacancy,
              child: const Text('+ Создать'),
            ),
          if (_tabIndex == 3)
            IconButton(
              onPressed: () => _onProfileEdit(context),
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Редактировать',
            ),
        ],
      ),
      body: SizedBox.expand(
        child: IndexedStack(
          index: _tabIndex,
          sizing: StackFit.expand,
          children: const [
            CompanyVacanciesTab(),
            CompanyCandidatesTab(),
            CompanyStatisticsTab(),
            CompanyProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: tokens.navBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                label: 'Вакансии',
                icon: Icons.work_rounded,
                isSelected: _tabIndex == 0,
                activeColor: _companyNavRed,
                scheme: scheme,
                onTap: () => setState(() => _tabIndex = 0),
              ),
              _NavItem(
                label: 'Кандидаты',
                icon: Icons.person_search_rounded,
                isSelected: _tabIndex == 1,
                activeColor: _companyNavRed,
                scheme: scheme,
                onTap: () => setState(() => _tabIndex = 1),
              ),
              _NavItem(
                label: 'Статистика',
                icon: Icons.bar_chart_rounded,
                isSelected: _tabIndex == 2,
                activeColor: _companyNavRed,
                scheme: scheme,
                onTap: () => setState(() => _tabIndex = 2),
              ),
              _NavItem(
                label: 'Компания',
                icon: Icons.apartment_rounded,
                isSelected: _tabIndex == 3,
                activeColor: _companyNavRed,
                scheme: scheme,
                onTap: () => setState(() => _tabIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.scheme,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final fg = isSelected ? activeColor : tokens.mutedForeground;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: fg),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: fg,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

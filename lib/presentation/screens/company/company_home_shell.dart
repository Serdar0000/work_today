// Слой: presentation | Назначение: shell компании — нижняя навигация; маршрут [routeCompanyHome] с redirect только для [UserRole.company]

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return Scaffold(
      backgroundColor: tokens.background,
      // По умолчанию IndexedStack = StackFit.loose → детям уходят loosen() и бесконечные max;
      // CustomScrollView/Row ломаются. StackFit.expand + tight body даёт нормальные constraints.
      body: SizedBox.expand(
        child: IndexedStack(
          index: _tabIndex,
          sizing: StackFit.expand,
          children: [
            CompanyVacanciesTab(
              onCreateTap: () {
                // TODO: маршрут «Создать вакансию»
              },
            ),
            const CompanyCandidatesTab(),
            const CompanyStatisticsTab(),
            const CompanyProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: tokens.navBackground,
        child: SafeArea(
          top: false,
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
                  onTap: () => setState(() => _tabIndex = 0),
                ),
                _NavItem(
                  label: 'Кандидаты',
                  icon: Icons.person_search_rounded,
                  isSelected: _tabIndex == 1,
                  activeColor: _companyNavRed,
                  onTap: () => setState(() => _tabIndex = 1),
                ),
                _NavItem(
                  label: 'Статистика',
                  icon: Icons.bar_chart_rounded,
                  isSelected: _tabIndex == 2,
                  activeColor: _companyNavRed,
                  onTap: () => setState(() => _tabIndex = 2),
                ),
                _NavItem(
                  label: 'Компания',
                  icon: Icons.apartment_rounded,
                  isSelected: _tabIndex == 3,
                  activeColor: _companyNavRed,
                  onTap: () => setState(() => _tabIndex = 3),
                ),
              ],
            ),
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
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
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
          color:
              isSelected ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
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

// Слой: presentation | Назначение: shell компании — AppBar + нижняя навигация

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_safe_scaffold.dart';
import '../../../l10n/app_localizations.dart';
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

  String _appBarTitle(AppLocalizations l10n) {
    return switch (_tabIndex) {
      0 => l10n.companyShellVacanciesTitle,
      1 => l10n.companyShellCandidatesTitle,
      2 => l10n.companyShellStatisticsTitle,
      _ => l10n.companyShellProfileTitle,
    };
  }

  void _onCreateVacancy() {
    context.push(AppConstants.routeCreateVacancy);
  }

  void _onProfileEdit(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.companyHomeEditProfileSoon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppSafeScaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(_appBarTitle(l10n)),
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
              child: Text(l10n.companyHomeCreateVacancy),
            ),
          if (_tabIndex == 3)
            IconButton(
              onPressed: () => _onProfileEdit(context),
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.companyEditProfileTooltip,
            ),
        ],
      ),
      body: SizedBox.expand(
        child: IndexedStack(
          index: _tabIndex,
          sizing: StackFit.expand,
          children: [
            CompanyVacanciesTab(
              onOpenCandidates: () => setState(() => _tabIndex = 1),
            ),
            const CompanyCandidatesTab(),
            const CompanyStatisticsTab(),
            const CompanyProfileTab(),
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
                label: l10n.companyNavVacancies,
                icon: Icons.work_rounded,
                isSelected: _tabIndex == 0,
                activeColor: _companyNavRed,
                scheme: scheme,
                onTap: () => setState(() => _tabIndex = 0),
              ),
              _NavItem(
                label: l10n.companyNavCandidates,
                icon: Icons.person_search_rounded,
                isSelected: _tabIndex == 1,
                activeColor: _companyNavRed,
                scheme: scheme,
                onTap: () => setState(() => _tabIndex = 1),
              ),
              _NavItem(
                label: l10n.companyNavStatistics,
                icon: Icons.bar_chart_rounded,
                isSelected: _tabIndex == 2,
                activeColor: _companyNavRed,
                scheme: scheme,
                onTap: () => setState(() => _tabIndex = 2),
              ),
              _NavItem(
                label: l10n.companyNavCompany,
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

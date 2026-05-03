import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/kazakhstan_major_cities.dart';
import '../../core/locale/app_locale_controller.dart';
import '../../core/utils/app_cache_clear.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_mode_controller.dart';
import '../../l10n/app_localizations.dart';

enum _ThemeChoice { light, dark, system }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late _ThemeChoice _theme;
  bool _offlineMode = true;
  bool _autoUpdate = true;
  String _preferredCity = '';
  bool _cityLoaded = false;
  String _cacheSizeText = '…';
  bool _clearingCache = false;

  @override
  void initState() {
    super.initState();
    _theme = _themeChoiceFromMode(ThemeModeController.notifier.value);
    _loadPreferredCity();
    _refreshCacheSizeLabel();
  }

  Future<void> _refreshCacheSizeLabel() async {
    final bytes = await AppCacheClear.estimateBytes();
    if (!mounted) return;
    setState(() {
      _cacheSizeText = AppCacheClear.formatBytes(bytes);
    });
  }

  Future<void> _onClearCachePressed() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsClearCacheConfirmTitle),
        content: Text(l10n.settingsClearCacheConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.settingsClearCacheAction),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _clearingCache = true);
    try {
      final freed = await AppCacheClear.clear();
      if (!mounted) return;
      await _loadPreferredCity();
      await _refreshCacheSizeLabel();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.settingsCacheCleared(AppCacheClear.formatBytes(freed)),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.errorWithMessage('$e')),
        ),
      );
    } finally {
      if (mounted) setState(() => _clearingCache = false);
    }
  }

  Future<void> _loadPreferredCity() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.kPreferredCityKey)?.trim() ?? '';
    if (!mounted) return;
    setState(() {
      _preferredCity =
          raw.isEmpty || kKazakhstanMajorCities.contains(raw) ? raw : '';
      _cityLoaded = true;
    });
  }

  Future<void> _pickPreferredCity() async {
    final l10n = AppLocalizations.of(context);
    final chosen = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  l10n.cityTitle,
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_off_outlined),
                title: Text(AppLocalizations.of(ctx).settingsCityNotSelected),
                subtitle:
                    Text(AppLocalizations.of(ctx).settingsCityAllCitiesHint),
                onTap: () => Navigator.pop(ctx, ''),
              ),
              const Divider(height: 1),
              ...kKazakhstanMajorCities.map(
                (c) => ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: c == _preferredCity
                        ? Theme.of(ctx).colorScheme.primary
                        : null,
                  ),
                  title: Text(c),
                  trailing: c == _preferredCity
                      ? Icon(Icons.check_rounded,
                          color: Theme.of(ctx).colorScheme.primary)
                      : null,
                  onTap: () => Navigator.pop(ctx, c),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted || chosen == null) return;
    final prefs = await SharedPreferences.getInstance();
    if (chosen.isEmpty) {
      await prefs.remove(AppConstants.kPreferredCityKey);
    } else {
      await prefs.setString(AppConstants.kPreferredCityKey, chosen);
    }
    if (!mounted) return;
    setState(() => _preferredCity = chosen);
  }

  Future<void> _pickLanguage() async {
    final current = AppLocaleController.notifier.value;
    final picked = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        Widget tile(Locale loc, String label) {
          final sel = current.languageCode == loc.languageCode;
          return ListTile(
            leading: Icon(
              Icons.language_rounded,
              color: sel ? scheme.primary : null,
            ),
            title: Text(label),
            trailing: sel
                ? Icon(Icons.check_rounded, color: scheme.primary)
                : null,
            onTap: () => Navigator.pop(ctx, loc),
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(ctx).languageTitle,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
              tile(const Locale('ru'), AppLocaleController.nativeLabel(const Locale('ru'))),
              tile(const Locale('kk'), AppLocaleController.nativeLabel(const Locale('kk'))),
              tile(const Locale('en'), AppLocaleController.nativeLabel(const Locale('en'))),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (picked != null) {
      await AppLocaleController.setLocale(picked);
    }
  }

  void _selectTheme(_ThemeChoice choice) {
    final nextMode = _modeFromThemeChoice(choice);
    if (ThemeModeController.notifier.value != nextMode) {
      ThemeModeController.notifier.value = nextMode;
    }

    if (_theme != choice) {
      setState(() => _theme = choice);
    }
  }

  _ThemeChoice _themeChoiceFromMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return _ThemeChoice.light;
      case ThemeMode.dark:
        return _ThemeChoice.dark;
      case ThemeMode.system:
        return _ThemeChoice.system;
    }
  }

  ThemeMode _modeFromThemeChoice(_ThemeChoice choice) {
    switch (choice) {
      case _ThemeChoice.light:
        return ThemeMode.light;
      case _ThemeChoice.dark:
        return ThemeMode.dark;
      case _ThemeChoice.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return AppSafeScaffold(
      backgroundColor: tokens.background,
      body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: tokens.border)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon:
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  ),
                  Expanded(
                    child: Text(
                      l10n.settingsTitle,
                      style: text.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
                children: [
                  _SectionLabel(title: l10n.appearanceSection),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.palette_outlined, color: colors.primary),
                            const SizedBox(width: 8),
                            Text(
                              l10n.themeSectionTitle,
                              style: text.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _ThemeButton(
                                title: l10n.themeLight,
                                icon: Icons.wb_sunny_outlined,
                                selected: _theme == _ThemeChoice.light,
                                onTap: () => _selectTheme(_ThemeChoice.light),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ThemeButton(
                                title: l10n.themeDark,
                                icon: Icons.nightlight_round,
                                selected: _theme == _ThemeChoice.dark,
                                onTap: () => _selectTheme(_ThemeChoice.dark),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ThemeButton(
                                title: l10n.themeSystem,
                                icon: Icons.smartphone_rounded,
                                selected: _theme == _ThemeChoice.system,
                                onTap: () => _selectTheme(_ThemeChoice.system),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SectionCard(
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _pickLanguage,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: ValueListenableBuilder<Locale>(
                              valueListenable: AppLocaleController.notifier,
                              builder: (context, loc, _) {
                                return _SimpleRow(
                                  icon: Icons.language_rounded,
                                  title: l10n.languageTitle,
                                  subtitle:
                                      AppLocaleController.nativeLabel(loc),
                                  trailing: const Icon(
                                    Icons.chevron_right_rounded,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _cityLoaded ? _pickPreferredCity : null,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: _SimpleRow(
                              icon: Icons.location_on_outlined,
                              title: l10n.cityTitle,
                              subtitle: !_cityLoaded
                                  ? '…'
                                  : (_preferredCity.isEmpty
                                      ? 'Не выбран'
                                      : _preferredCity),
                              trailing: const Icon(Icons.chevron_right_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionLabel(title: l10n.dataStorageSection),
                  _SectionCard(
                    child: Column(
                      children: [
                        _SwitchRow(
                          icon: Icons.download_for_offline_outlined,
                          title: l10n.offlineModeTitle,
                          subtitle: l10n.offlineModeSubtitle,
                          value: _offlineMode,
                          onChanged: (value) =>
                              setState(() => _offlineMode = value),
                        ),
                        const SizedBox(height: 12),
                        _SwitchRow(
                          icon: Icons.smartphone_outlined,
                          title: l10n.autoUpdateTitle,
                          subtitle: l10n.autoUpdateSubtitle,
                          value: _autoUpdate,
                          onChanged: (value) =>
                              setState(() => _autoUpdate = value),
                        ),
                        const SizedBox(height: 12),
                        Divider(color: tokens.border),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              l10n.appCacheTitle,
                              style: text.bodyMedium?.copyWith(
                                color: tokens.mutedForeground,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: tokens.muted,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                _cacheSizeText,
                                style: text.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed:
                                _clearingCache ? null : _onClearCachePressed,
                            icon: _clearingCache
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colors.primary,
                                    ),
                                  )
                                : const Icon(Icons.delete_outline_rounded),
                            label: Text(
                              _clearingCache ? 'Очистка…' : l10n.clearCacheButton,
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: tokens.border),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionLabel(title: l10n.aboutSection),
                  _SectionCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: tokens.muted,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'E',
                                style: text.headlineMedium?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.appName,
                                  style: text.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  l10n.appVersion,
                                  style: text.bodyMedium?.copyWith(
                                    color: tokens.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.termsOfService,
                                    style: text.bodyLarge,
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              label: l10n.bottomNavVacancies,
              selected: false,
              onTap: () => context.go(AppConstants.routeHome),
            ),
            _BottomNavItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description_rounded,
              label: l10n.bottomNavApplications,
              selected: false,
              onTap: () => context.go(AppConstants.routeMyApplications),
            ),
            _BottomNavItem(
              icon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart_rounded,
              label: l10n.bottomNavStats,
              selected: false,
              onTap: () => context.go(AppConstants.routeStatistics),
            ),
            _BottomNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: l10n.bottomNavProfile,
              selected: true,
              onTap: () => context.go(AppConstants.routeProfile),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final tokens = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: text.bodyLarge?.copyWith(
          color: tokens.mutedForeground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: tokens.border),
        boxShadow: [
          BoxShadow(
            color: tokens.foreground.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ThemeButton extends StatelessWidget {
  const _ThemeButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tokens = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color:
              selected ? colors.primary.withValues(alpha: 0.08) : tokens.muted,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? colors.primary : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 18,
                color: selected ? colors.primary : tokens.mutedForeground),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: AppTypography.caption,
                color: selected ? colors.primary : tokens.foreground,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleRow extends StatelessWidget {
  const _SimpleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final tokens = context.appColors;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: tokens.muted,
            shape: BoxShape.circle,
          ),
          child: Icon(icon),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                subtitle,
                style: text.bodyMedium?.copyWith(color: tokens.mutedForeground),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final tokens = context.appColors;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: tokens.muted,
            shape: BoxShape.circle,
          ),
          child: Icon(icon),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                subtitle,
                style: text.bodyMedium?.copyWith(color: tokens.mutedForeground),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
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
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? colors.primary.withValues(alpha: 0.12)
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

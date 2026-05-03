import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../domain/entities/user.dart';
import '../blocs/auth/auth_bloc.dart';
import '../utils/auth_logout.dart';

String _initialsForName(String name) {
  final t = name.trim();
  if (t.isEmpty) {
    return '?';
  }
  final parts = t.split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    final a = parts[0].isNotEmpty ? parts[0][0] : '';
    final b = parts[1].isNotEmpty ? parts[1][0] : '';
    return ('$a$b').toUpperCase();
  }
  if (t.length >= 2) {
    return t.substring(0, 2).toUpperCase();
  }
  return t[0].toUpperCase();
}

String _profileSummaryLine(AppLocalizations l10n, User u) {
  if (!u.hasJobSeekerProfile && !u.hasCompanyProfile) {
    return l10n.profileSummaryNotFilled;
  }
  if (u.hasJobSeekerProfile && u.hasCompanyProfile) {
    final active = u.activeContext == UserRole.company
        ? l10n.profileLabelCompanyShort
        : l10n.profileLabelWorkerShort;
    return l10n.profileSummaryDual(
      l10n.profileLabelWorkerShort,
      l10n.profileLabelCompanyShort,
      active,
    );
  }
  if (u.hasCompanyProfile) {
    return l10n.profileSummaryCompanyOnly;
  }
  return l10n.profileSummaryWorkerOnly;
}

String _calendarDayString(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

/// Обновляет счётчик дней подряд при открытии профиля; возвращает текущую серию.
Future<int> refreshDailyLoginStreak() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now();
  final todayStr = _calendarDayString(today);
  final yesterdayStr = _calendarDayString(
    today.subtract(const Duration(days: 1)),
  );

  final last = prefs.getString(AppConstants.kActivityLastOpenDayKey) ?? '';
  final streak = prefs.getInt(AppConstants.kActivityStreakKey) ?? 0;

  if (last == todayStr) {
    return streak < 1 ? 1 : streak;
  }

  final int newStreak;
  if (last.isEmpty) {
    newStreak = 1;
  } else if (last == yesterdayStr) {
    newStreak = streak + 1;
  } else {
    newStreak = 1;
  }

  await prefs.setString(AppConstants.kActivityLastOpenDayKey, todayStr);
  await prefs.setInt(AppConstants.kActivityStreakKey, newStreak);
  return newStreak;
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static List<_ProfileMenuItemData> _menuItems(AppLocalizations l10n) => [
        _ProfileMenuItemData(
          icon: Icons.description_outlined,
          title: l10n.profileResume,
          badgeText: l10n.profileResumeBadge,
        ),
        _ProfileMenuItemData(
          icon: Icons.notifications_none_rounded,
          title: l10n.profileNotifications,
          badgeText: l10n.profileNotificationsBadge,
        ),
        _ProfileMenuItemData(
          icon: Icons.shield_outlined,
          title: l10n.profileSecurity,
        ),
        _ProfileMenuItemData(
          icon: Icons.settings_outlined,
          title: l10n.profileSettings,
        ),
        _ProfileMenuItemData(
          icon: Icons.help_outline_rounded,
          title: l10n.profileHelp,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    final menuItems = _menuItems(l10n);

    return AppSafeScaffold(
      backgroundColor: tokens.background,
      body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: tokens.border),
                ),
              ),
              child: Text(
                l10n.profileTitle,
                style: text.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                children: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is! AuthAuthenticated) {
                        return _SectionCard(
                          child: Text(
                            l10n.profileLoginPrompt,
                            style: text.bodyLarge,
                          ),
                        );
                      }
                      final user = state.user;
                      return _SectionCard(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                    color: tokens.muted,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: tokens.border,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _initialsForName(user.name),
                                    style: TextStyle(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: AppTypography.sectionTitle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.name,
                                              style: const TextStyle(
                                                fontSize: AppTypography.cardTitle,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _profileSummaryLine(l10n, user),
                                        style: TextStyle(
                                          fontSize: AppTypography.body,
                                          color: tokens.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _ContactRow(
                              icon: Icons.mail_outline,
                              text: user.email,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  context.push(AppConstants.routeEditProfile);
                                },
                                icon: const Icon(Icons.person_outline_rounded),
                                label: Text(l10n.profileEdit),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                  backgroundColor: tokens.muted,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.xl),
                                  ),
                                  side: BorderSide(
                                    color: tokens.border,
                                  ),
                                  foregroundColor: colors.onSurface,
                                ),
                              ),
                            ),
                            if (user.activeContext == UserRole.worker) ...[
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                          const AuthContextSwitchRequested(
                                            selectedRole: UserRole.company,
                                          ),
                                        );
                                  },
                                  icon: const Icon(Icons.apartment_outlined),
                                  label: Text(l10n.profileSwitchCompany),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is! AuthAuthenticated) {
                        return const SizedBox.shrink();
                      }
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: _DailyActivitySection(),
                      );
                    },
                  ),
                  _SectionCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: List.generate(menuItems.length, (index) {
                        final item = menuItems[index];
                        final isLast = index == menuItems.length - 1;

                        return InkWell(
                          onTap: () {
                            if (index == 0) {
                              context.push(AppConstants.routeResume);
                            }

                            if (index == 1) {
                              context.push(AppConstants.routeNotifications);
                            }

                            if (index == 2) {
                              context.push(AppConstants.routeSecurity);
                            }

                            if (index == 3) {
                              context.push(AppConstants.routeSettings);
                            }
                          },
                          borderRadius: isLast
                              ? const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                )
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: isLast
                                  ? null
                                  : Border(
                                      bottom: BorderSide(
                                        color: tokens.border,
                                      ),
                                    ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: tokens.muted,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    item.icon,
                                    size: 20,
                                    color: colors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: text.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (item.badgeText case final badge?)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tokens.muted,
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.pill),
                                    ),
                                    child: Text(
                                      badge,
                                      style: const TextStyle(
                                        fontSize: AppTypography.caption,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: colors.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () => showConfirmLogout(context),
                        icon: const Icon(Icons.logout_rounded),
                        label: Text(l10n.profileLogout),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
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
          border: Border(
            top: BorderSide(color: tokens.border),
          ),
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Серия ежедневных заходов на экран «Профиль» (обновляется при каждом открытии).
class _DailyActivitySection extends StatefulWidget {
  const _DailyActivitySection();

  @override
  State<_DailyActivitySection> createState() => _DailyActivitySectionState();
}

class _DailyActivitySectionState extends State<_DailyActivitySection> {
  int? _streakDays;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final n = await refreshDailyLoginStreak();
      if (mounted) {
        setState(() {
          _streakDays = n;
          _loadError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadError = e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department_rounded, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                l10n.profileActivityTitle,
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.profileActivityHint,
            style: text.bodyMedium?.copyWith(
              color: tokens.mutedForeground,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          if (_loadError != null)
            Text(
              l10n.profileActivityLoadError('$_loadError'),
              style: text.bodySmall?.copyWith(color: tokens.destructive),
            )
          else if (_streakDays == null)
            const LinearProgressIndicator(minHeight: 2)
          else
            Row(
              children: [
                Text(
                  l10n.profileActivityStreakLabel,
                  style: text.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    l10n.profileStreakDays(_streakDays!),
                    style: text.titleMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ProfileMenuItemData {
  const _ProfileMenuItemData({
    required this.icon,
    required this.title,
    this.badgeText,
  });

  final IconData icon;
  final String title;
  final String? badgeText;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: tokens.foreground.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return Row(
      children: [
        Icon(icon, size: 18, color: tokens.mutedForeground),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: AppTypography.bodySmall,
            color: tokens.mutedForeground,
          ),
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

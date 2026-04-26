import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
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

String _roleLabel(UserRole role) {
  return role == UserRole.company ? 'Компания' : 'Соискатель';
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<Map<String, String>> _achievements = [
    {'emoji': '🚀', 'title': 'Быстрый\nстарт'},
    {'emoji': '⭐', 'title': '5 откликов'},
    {'emoji': '💼', 'title': 'Первая\nработа'},
  ];

  static const List<_ProfileMenuItemData> _menuItems = [
    _ProfileMenuItemData(
      icon: Icons.description_outlined,
      title: 'Моё резюме',
      badgeText: 'Заполнено',
    ),
    _ProfileMenuItemData(
      icon: Icons.notifications_none_rounded,
      title: 'Уведомления',
      badgeText: '3',
    ),
    _ProfileMenuItemData(
      icon: Icons.shield_outlined,
      title: 'Безопасность',
    ),
    _ProfileMenuItemData(
      icon: Icons.settings_outlined,
      title: 'Настройки',
    ),
    _ProfileMenuItemData(
      icon: Icons.help_outline_rounded,
      title: 'Помощь',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
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
                'Профиль',
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
                            'Войдите в аккаунт, чтобы увидеть профиль.',
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
                                        _roleLabel(user.role),
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
                                onPressed: () {},
                                icon: const Icon(Icons.person_outline_rounded),
                                label: const Text('Редактировать профиль'),
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
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.workspace_premium_outlined,
                                color: tokens.accent),
                            const SizedBox(width: 8),
                            Text(
                              'Достижения',
                              style: text.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: List.generate(
                            _achievements.length,
                            (index) {
                              final item = _achievements[index];
                              return Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: index == _achievements.length - 1
                                        ? 0
                                        : 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tokens.muted,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.lg),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        item['emoji']!,
                                        style: const TextStyle(
                                          fontSize: AppTypography.sectionTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['title']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: AppTypography.bodySmall,
                                          height: 1.2,
                                          color: tokens.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: List.generate(_menuItems.length, (index) {
                        final item = _menuItems[index];
                        final isLast = index == _menuItems.length - 1;

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
                        label: const Text('Выйти из аккаунта'),
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
              label: 'Вакансии',
              selected: false,
              onTap: () => context.go(AppConstants.routeHome),
            ),
            _BottomNavItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description_rounded,
              label: 'Отклики',
              selected: false,
              onTap: () => context.go(AppConstants.routeMyApplications),
            ),
            _BottomNavItem(
              icon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart_rounded,
              label: 'Статистика',
              selected: false,
              onTap: () => context.go(AppConstants.routeStatistics),
            ),
            _BottomNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Профиль',
              selected: true,
              onTap: () {},
            ),
          ],
        ),
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

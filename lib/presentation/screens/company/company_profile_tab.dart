// Слой: presentation | Назначение: таб «Компания» — профиль работодателя (mock; дальше Firestore profiles)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/auth_logout.dart';

const Color _companyRed = Color(0xFFDC2626);
const Color _navyText = Color(0xFF1E3A5F);

class CompanyProfileTab extends StatelessWidget {
  const CompanyProfileTab({super.key});

  static void _soon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature — скоро')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _CompanyHeroCard(tokens: tokens, text: text),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _ContactCard(tokens: tokens, text: text),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _MenuCard(
              tokens: tokens,
              text: text,
              scheme: scheme,
              onEditProfile: () => _soon(context, 'Редактировать профиль'),
              onTeam: () => _soon(context, 'Команда'),
              onNotifications: () =>
                  context.push(AppConstants.routeNotifications),
              onSecurity: () => context.push(AppConstants.routeSecurity),
              onSettings: () => context.push(AppConstants.routeSettings),
              onHelp: () => _soon(context, 'Помощь'),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          sliver: SliverToBoxAdapter(
            child: OutlinedButton.icon(
              onPressed: () => _onSwitchToWorker(context),
              icon: const Icon(Icons.work_outline_rounded),
              label: const Text('Войти как соискатель'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: tokens.foreground,
                side: BorderSide(color: tokens.border),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: TextButton.icon(
              onPressed: () => showConfirmLogout(context),
              icon: Icon(Icons.logout_rounded, color: tokens.destructive),
              label: Text(
                'Выйти из аккаунта',
                style: text.titleSmall?.copyWith(
                  color: tokens.destructive,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: Center(
              child: Text(
                'EasyShift для бизнеса v1.0.0',
                style: text.bodySmall?.copyWith(
                  color: tokens.mutedForeground,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onSwitchToWorker(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Войти как соискатель'),
        content: const Text(
          'Смена роли потребует обновления профиля в облаке. '
          'Сейчас эта функция в разработке.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }
}

class _CompanyHeroCard extends StatelessWidget {
  const _CompanyHeroCard({required this.tokens, required this.text});

  final AppColors tokens;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: tokens.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _companyRed,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  'FL',
                  style: text.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FastLine Delivery',
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: _navyText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Логистика и доставка',
                      style: text.bodyMedium?.copyWith(
                        color: tokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFEAB308),
                          size: 22,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.7 (128 отзывов)',
                          style: text.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.work_outline_rounded,
                  iconColor: _companyRed,
                  value: '5',
                  label: 'Вакансий',
                  tokens: tokens,
                  text: text,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStat(
                  icon: Icons.groups_outlined,
                  iconColor: const Color(0xFF2563EB),
                  value: '47',
                  label: 'Наняли',
                  tokens: tokens,
                  text: text,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStat(
                  icon: Icons.calendar_today_outlined,
                  iconColor: tokens.success,
                  value: '2024',
                  label: 'С нами с',
                  tokens: tokens,
                  text: text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.tokens,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final AppColors tokens;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: tokens.muted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: text.labelSmall?.copyWith(
              color: tokens.mutedForeground,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.tokens, required this.text});

  final AppColors tokens;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Контактная информация',
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: _navyText,
            ),
          ),
          const SizedBox(height: 14),
          _ContactRow(
            icon: Icons.location_on_outlined,
            text: 'Алматы, Казахстан',
            tokens: tokens,
            theme: text,
          ),
          const Divider(height: 20),
          _ContactRow(
            icon: Icons.phone_outlined,
            text: '+7 (727) 123-45-67',
            tokens: tokens,
            theme: text,
          ),
          const Divider(height: 20),
          _ContactRow(
            icon: Icons.email_outlined,
            text: 'hr@fastline.kz',
            tokens: tokens,
            theme: text,
          ),
          const Divider(height: 20),
          _ContactRow(
            icon: Icons.language_rounded,
            text: 'fastline.kz',
            tokens: tokens,
            theme: text,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.text,
    required this.tokens,
    required this.theme,
  });

  final IconData icon;
  final String text;
  final AppColors tokens;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: tokens.mutedForeground),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: theme.bodyMedium),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.tokens,
    required this.text,
    required this.scheme,
    required this.onEditProfile,
    required this.onTeam,
    required this.onNotifications,
    required this.onSecurity,
    required this.onSettings,
    required this.onHelp,
  });

  final AppColors tokens;
  final TextTheme text;
  final ColorScheme scheme;
  final VoidCallback onEditProfile;
  final VoidCallback onTeam;
  final VoidCallback onNotifications;
  final VoidCallback onSecurity;
  final VoidCallback onSettings;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.edit_note_outlined,
            title: 'Редактировать профиль',
            onTap: onEditProfile,
            tokens: tokens,
            text: text,
          ),
          Divider(height: 1, color: tokens.border),
          _MenuTile(
            icon: Icons.groups_outlined,
            title: 'Команда',
            onTap: onTeam,
            tokens: tokens,
            text: text,
          ),
          Divider(height: 1, color: tokens.border),
          _MenuTile(
            icon: Icons.notifications_none_rounded,
            title: 'Уведомления',
            onTap: onNotifications,
            tokens: tokens,
            text: text,
            badge: '3',
            badgeColor: scheme.error,
          ),
          Divider(height: 1, color: tokens.border),
          _MenuTile(
            icon: Icons.shield_outlined,
            title: 'Безопасность',
            onTap: onSecurity,
            tokens: tokens,
            text: text,
          ),
          Divider(height: 1, color: tokens.border),
          _MenuTile(
            icon: Icons.settings_outlined,
            title: 'Настройки',
            onTap: onSettings,
            tokens: tokens,
            text: text,
          ),
          Divider(height: 1, color: tokens.border),
          _MenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Помощь',
            onTap: onHelp,
            tokens: tokens,
            text: text,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.tokens,
    required this.text,
    this.badge,
    this.badgeColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final AppColors tokens;
  final TextTheme text;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 24, color: tokens.mutedForeground),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor ?? tokens.destructive,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: text.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: tokens.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

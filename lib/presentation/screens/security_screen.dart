import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/repositories/auth_repository.dart';
import '../utils/auth_logout.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _firebaseAuth = false;

  @override
  void initState() {
    super.initState();
    _firebaseAuth = Firebase.apps.isNotEmpty;
  }

  bool get _canChangePassword {
    if (!_firebaseAuth) return true;
    final u = fb_auth.FirebaseAuth.instance.currentUser;
    if (u == null) return false;
    return u.providerData.any((p) => p.providerId == 'password');
  }

  String? get _firebaseEmail {
    if (!_firebaseAuth) return null;
    final e = fb_auth.FirebaseAuth.instance.currentUser?.email?.trim();
    if (e == null || e.isEmpty) return null;
    return e;
  }

  Future<void> _showChangePasswordDialog() async {
    final messenger = ScaffoldMessenger.of(context);
    final authRepo = context.read<AuthRepository>();
    final current = TextEditingController();
    final next = TextEditingController();
    final confirm = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var saving = false;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Новый пароль'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: current,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Текущий пароль',
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Введите текущий пароль' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: next,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Новый пароль',
                      helperText:
                          'Не короче ${AppConstants.kMinPasswordLength} символов',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Введите новый пароль';
                      }
                      if (v.length < AppConstants.kMinPasswordLength) {
                        return 'Слишком короткий пароль';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirm,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Повторите новый пароль',
                    ),
                    validator: (v) =>
                        v != next.text ? 'Пароли не совпадают' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(ctx),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setModal(() => saving = true);
                      try {
                        await authRepo.updatePassword(
                          currentPassword: current.text,
                          newPassword: next.text,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Пароль обновлён')),
                        );
                      } catch (e) {
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                        setModal(() => saving = false);
                      }
                    },
              child: saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );

    current.dispose();
    next.dispose();
    confirm.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    final email = _firebaseEmail;
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет email для сброса')),
      );
      return;
    }
    try {
      await fb_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Письмо со ссылкой отправлено на ваш email'),
        ),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? e.code)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    final accountHint = !_firebaseAuth
        ? 'Локальный режим: пароль хранится только на устройстве.'
        : _canChangePassword
            ? 'Аккаунт с email и паролем. Можно сменить пароль ниже.'
            : 'Вход через Google. Пароль приложения не используется — '
                'управление доступом в Google-аккаунте.';

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
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                ),
                Expanded(
                  child: Text(
                    'Безопасность',
                    style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
              children: [
                _SectionCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: tokens.success.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          color: tokens.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Аккаунт',
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              accountHint,
                              style: text.bodyMedium?.copyWith(
                                color: tokens.mutedForeground,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              color: colors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Пароль',
                            style: text.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Для смены укажите текущий пароль и новый (не короче '
                        '${AppConstants.kMinPasswordLength} символов).',
                        style: text.bodyMedium?.copyWith(
                          color: tokens.mutedForeground,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _canChangePassword
                                  ? _showChangePasswordDialog
                                  : null,
                              icon: const Icon(Icons.key_rounded, size: 18),
                              label: const Text('Сменить пароль'),
                            ),
                          ),
                        ],
                      ),
                      if (_firebaseAuth && _canChangePassword) ...[
                        const SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: _sendPasswordResetEmail,
                          icon: const Icon(Icons.mail_outline_rounded, size: 18),
                          label: const Text('Письмо для сброса пароля на email'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _SectionCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: tokens.muted,
                      child: Icon(Icons.person_outline_rounded,
                          color: colors.primary),
                    ),
                    title: Text(
                      'Email и имя',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Редактирование профиля и смена email (с подтверждением).',
                      style: text.bodySmall?.copyWith(
                        color: tokens.mutedForeground,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        context.push(AppConstants.routeEditProfile),
                  ),
                ),
                const SizedBox(height: 10),
                _SectionCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: tokens.muted,
                      child: Icon(Icons.verified_user_outlined,
                          color: colors.onSurfaceVariant),
                    ),
                    title: Text(
                      'Двухфакторная аутентификация',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Пока недоступно. Позже подключим SMS или приложение-аутентификатор.',
                      style: text.bodySmall?.copyWith(
                        color: tokens.mutedForeground,
                      ),
                    ),
                    trailing: Chip(
                      label: const Text('Скоро'),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: tokens.muted,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _SectionCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: tokens.muted,
                      child: const Icon(Icons.fingerprint),
                    ),
                    title: Text(
                      'Биометрия',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Вход по отпечатку или Face ID — в планах.',
                      style: text.bodySmall?.copyWith(
                        color: tokens.mutedForeground,
                      ),
                    ),
                    trailing: Chip(
                      label: const Text('Скоро'),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: tokens.muted,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.devices_rounded, color: colors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Сеансы',
                              style: text.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Список устройств в приложении недоступен: Firebase '
                        'не отдаёт активные сеансы в клиенте. Вы можете выйти '
                        'из аккаунта на этом устройстве.',
                        style: text.bodyMedium?.copyWith(
                          color: tokens.mutedForeground,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => showConfirmLogout(context),
                          icon: Icon(
                            Icons.logout_rounded,
                            color: tokens.destructive,
                            size: 20,
                          ),
                          label: Text(
                            'Выйти из аккаунта',
                            style: text.bodyMedium?.copyWith(
                              color: tokens.destructive,
                              fontWeight: FontWeight.w600,
                            ),
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
              onTap: () => context.go(AppConstants.routeProfile),
            ),
          ],
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: tokens.border),
        boxShadow: [
          BoxShadow(
            color: tokens.foreground.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
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

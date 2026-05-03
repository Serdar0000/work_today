// Слой: presentation | Редактирование имени и email аккаунта (оформление как «Моё резюме»)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/profile_edit/profile_edit_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state;
    if (auth is AuthAuthenticated) {
      _nameCtrl.text = auth.user.name;
      _emailCtrl.text = auth.user.email;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return BlocConsumer<ProfileEditCubit, ProfileEditState>(
      listenWhen: (prev, curr) =>
          curr is ProfileEditSuccess || curr is ProfileEditFailure,
      listener: (context, state) {
        if (state is ProfileEditSuccess) {
          context.read<AuthBloc>().add(AuthSessionUserRefreshed(state.user));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).editProfileSaved),
            ),
          );
          context.pop();
        } else if (state is ProfileEditFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final saving = state is ProfileEditSaving;
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
                      onPressed: saving ? null : () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    ),
                    Expanded(
                      child: Text(
                        l10n.editProfileTitle,
                        style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: saving
                          ? null
                          : () {
                              context.read<ProfileEditCubit>().submit(
                                    name: _nameCtrl.text,
                                    email: _emailCtrl.text,
                                  );
                            },
                      icon: saving
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.primary,
                              ),
                            )
                          : const Icon(Icons.save_outlined, size: 20),
                      label: Text(
                        saving ? l10n.editProfileSaving : l10n.editProfileSave,
                      ),
                    ),
                  ],
                ),
              ),
              if (saving) const LinearProgressIndicator(minHeight: 2),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
                  children: [
                    _SectionCard(
                      title: l10n.editProfilePrimarySection,
                      icon: Icons.person_outline_rounded,
                      child: Column(
                        children: [
                          _LabeledField(
                            icon: Icons.badge_outlined,
                            label: l10n.editProfileNameLabel,
                            controller: _nameCtrl,
                            hint: l10n.registerNameHint,
                          ),
                          _LabeledField(
                            icon: Icons.mail_outline_rounded,
                            label: l10n.fieldEmail,
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Text(
                            l10n.editProfileEmailHint,
                            style: text.bodySmall?.copyWith(
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
      },
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.hint,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: tokens.muted,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: colors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: tokens.mutedForeground,
                    fontSize: AppTypography.caption,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hint,
                    isDense: true,
                  ),
                  style: text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: tokens.foreground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: tokens.foreground.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
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

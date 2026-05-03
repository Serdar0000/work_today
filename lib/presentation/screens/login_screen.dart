// Слой: presentation | Назначение: вход — сначала выбор роли, затем email/пароль

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/loading_button.dart';
import '../../domain/entities/user.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/auth/auth_bloc.dart';

enum _LoginPhase { pickRole, credentials }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _LoginPhase _phase = _LoginPhase.pickRole;
  UserRole? _pickedRole;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              selectedRole: _pickedRole!,
            ),
          );
    }
  }

  String _roleTitle(AppLocalizations l10n, UserRole r) =>
      r == UserRole.company ? l10n.roleCompany : l10n.roleWorker;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (_phase == _LoginPhase.pickRole) {
      return AppSafeScaffold(
        backgroundColor: tokens.background,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppConstants.kAppLogoAsset,
                        width: 56,
                        height: 56,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.appName,
                        style: text.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginPickRoleSubtitle,
                        style: text.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _RoleChoiceCard(
                        selected: _pickedRole == UserRole.worker,
                        icon: Icons.person_outline_rounded,
                        iconBackground: colors.primary.withValues(alpha: 0.12),
                        iconColor: colors.primary,
                        title: l10n.loginWorkerTitle,
                        subtitle: l10n.loginWorkerSubtitle,
                        tags: [l10n.loginWorkerTag1, l10n.loginWorkerTag2],
                        tagColor: colors.primary,
                        onTap: () =>
                            setState(() => _pickedRole = UserRole.worker),
                      ),
                      const SizedBox(height: 12),
                      _RoleChoiceCard(
                        selected: _pickedRole == UserRole.company,
                        icon: Icons.apartment_rounded,
                        iconBackground: colors.error.withValues(alpha: 0.12),
                        iconColor: colors.error,
                        title: l10n.loginCompanyTitle,
                        subtitle: l10n.loginCompanySubtitle,
                        tags: [l10n.loginCompanyTag1, l10n.loginCompanyTag2],
                        tagColor: colors.error,
                        onTap: () =>
                            setState(() => _pickedRole = UserRole.company),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.loginChangeRoleFooter,
                        textAlign: TextAlign.center,
                        style: text.bodySmall?.copyWith(
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: FilledButton(
                  onPressed: _pickedRole == null
                      ? null
                      : () => setState(() => _phase = _LoginPhase.credentials),
                  child: Text(l10n.loginContinue),
                ),
              ),
            ],
          ),
      );
    }

    return AppSafeScaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => setState(() {
            _phase = _LoginPhase.pickRole;
          }),
        ),
        title: Text(l10n.loginScreenTitle),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final role = _pickedRole!;
          final strings = AppLocalizations.of(context);

          return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      AppConstants.kAppLogoAsset,
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      strings.loginCredentialsTitle,
                      style: text.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.loginCredentialsBody(_roleTitle(strings, role)),
                      style: text.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => setState(() => _phase = _LoginPhase.pickRole),
                        child: Text(strings.loginChangeRole),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: strings.fieldEmail,
                      controller: _emailController,
                      validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: strings.loginPassword,
                      controller: _passwordController,
                      validator: Validators.password,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      enabled: !isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    LoadingButton(
                      label: strings.loginSubmit,
                      onPressed: _submit,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => context
                              .read<AuthBloc>()
                              .add(AuthGoogleSignInRequested(
                                selectedRole: _pickedRole!,
                              )),
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 26),
                      label: Text(strings.loginGoogle),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.push(
                                AppConstants.routeRegister,
                                extra: role,
                              ),
                      child: Text(strings.loginRegisterLink),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}

class _RoleChoiceCard extends StatelessWidget {
  const _RoleChoiceCard({
    required this.selected,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.tagColor,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<String> tags;
  final Color tagColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: selected ? colors.primary : tokens.border,
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Icon(icon, color: iconColor, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: text.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: text.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags
                    .map(
                      (t) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          t,
                          style: text.labelMedium?.copyWith(
                            color: tagColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

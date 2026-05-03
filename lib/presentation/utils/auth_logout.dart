import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../blocs/auth/auth_bloc.dart';

/// Подтверждение и выход из аккаунта (очистка сессии в [AuthBloc]).
Future<void> showConfirmLogout(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.authLogoutTitle),
      content: Text(l10n.authLogoutMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.authLogoutConfirm),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }
}

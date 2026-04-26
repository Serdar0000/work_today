import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';

/// Подтверждение и выход из аккаунта (очистка сессии в [AuthBloc]).
Future<void> showConfirmLogout(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Выйти из аккаунта?'),
      content: const Text(
        'Сессия будет завершена. Чтобы снова открыть приложение под своим логином, потребуется войти.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Выйти'),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }
}

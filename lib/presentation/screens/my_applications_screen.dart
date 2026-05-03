import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/user.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/auth/auth_bloc.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  static const List<String> _editableStatuses = [
    'Новый',
    'В работе',
    'Принят',
    'Отклонен',
  ];

  Future<void> _editApplication(String docId, Map<String, dynamic> app) async {
    final l10n = AppLocalizations.of(context);
    final noteController = TextEditingController(text: app['note'] as String);
    String selectedStatus = app['status'] as String;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) => AlertDialog(
            title: Text(l10n.myApplicationsEditTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: l10n.myApplicationsStatusLabel,
                  ),
                  items: _editableStatuses
                      .map(
                        (status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setModalState(() => selectedStatus = value);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.myApplicationsNoteLabel,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('applications')
                      .doc(docId)
                      .update({
                    'status': selectedStatus,
                    'note': noteController.text.trim(),
                    'updatedAt': Timestamp.fromDate(DateTime.now()),
                  });
                  Navigator.pop(ctx);
                },
                child: Text(l10n.commonSave),
              ),
            ],
          ),
        );
      },
    );

    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthAuthenticated ||
        authState.user.activeContext != UserRole.worker ||
        (authState.user.authUid?.isEmpty ?? true)) {
      return AppSafeScaffold(
        backgroundColor: tokens.background,
        body: Center(
          child: Text(l10n.myApplicationsWorkerOnly),
        ),
      );
    }
    final uid = authState.user.authUid!;
    final stream = FirebaseFirestore.instance
        .collection('applications')
        .where('workerUid', isEqualTo: uid)
        .snapshots();

    return AppSafeScaffold(
      backgroundColor: tokens.background,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                l10n.errorWithMessage('${snapshot.error}'),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs.toList()
            ..sort((a, b) {
              final aTs = a.data()['updatedAt'] as Timestamp?;
              final bTs = b.data()['updatedAt'] as Timestamp?;
              final aDt = aTs?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bDt = bTs?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bDt.compareTo(aDt);
            });
          return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: tokens.border),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.myApplicationsTitle,
                    style: text.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.myApplicationsCount(docs.length),
                    style: TextStyle(
                      fontSize: AppTypography.body,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: docs.isEmpty
                  ? Center(
                      child: Text(
                        l10n.myApplicationsEmpty,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final app = doc.data();
                        final note = app['note'] as String;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.fromLTRB(16, 14, 10, 12),
                          decoration: BoxDecoration(
                            color: tokens.card,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            boxShadow: [
                              BoxShadow(
                                color: tokens.foreground.withValues(alpha: 0.05),
                                blurRadius: 14,
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
                                  Expanded(
                                    child: Text(
                                      (app['vacancyTitle'] as String?) ??
                                          l10n.myApplicationsUntitledVacancy,
                                      style: text.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert_rounded),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editApplication(doc.id, app);
                                        return;
                                      }

                                      if (value == 'delete') {
                                        FirebaseFirestore.instance
                                            .collection('applications')
                                            .doc(doc.id)
                                            .delete();
                                      }
                                    },
                                    itemBuilder: (menuCtx) => [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text(
                                          AppLocalizations.of(menuCtx)
                                              .myApplicationsChange,
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text(
                                          AppLocalizations.of(menuCtx)
                                              .myApplicationsDelete,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              _StatusChip(status: app['status'] as String),
                              if (note.trim().isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 18,
                                      color: tokens.mutedForeground,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        note,
                                        style: TextStyle(
                                          fontSize: AppTypography.bodySmall,
                                          color: tokens.mutedForeground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 18,
                                    color: tokens.mutedForeground,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${l10n.myApplicationsUpdatedPrefix} ${_formatDate(app['updatedAt'])}',
                                    style: TextStyle(
                                      fontSize: AppTypography.bodySmall,
                                      color: tokens.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
        },
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
              selected: true,
              onTap: () {},
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
              selected: false,
              onTap: () => context.go(AppConstants.routeProfile),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(Object? raw) {
    DateTime value = DateTime.now();
    if (raw is Timestamp) {
      value = raw.toDate();
    }
    return DateFormat('dd.MM.yyyy HH:mm').format(value);
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = switch (status) {
      'Новый' => (tokens.primary, tokens.primary.withValues(alpha: 0.12)),
      'В работе' => (tokens.warning, tokens.warning.withValues(alpha: 0.15)),
      'Принят' => (tokens.success, tokens.success.withValues(alpha: 0.14)),
      'Отклонен' => (
          tokens.destructive,
          tokens.destructive.withValues(alpha: 0.12),
        ),
      _ => (tokens.foreground, tokens.muted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$2,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: colors.$1.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colors.$1,
          fontSize: AppTypography.caption,
          fontWeight: FontWeight.w600,
        ),
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

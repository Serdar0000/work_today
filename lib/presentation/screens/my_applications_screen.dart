import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  final List<Map<String, dynamic>> _applications = [
    {
      'vacancyId': 'vac-001',
      'title': 'Сборщик заказов',
      'status': 'Новый',
      'note': 'Могу выходить в ночные смены',
      'timestamp': '2026-04-21 18:30',
    },
    {
      'vacancyId': 'vac-002',
      'title': 'Курьер на вечерние смены',
      'status': 'В работе',
      'note': 'Есть личный велосипед',
      'timestamp': '2026-04-22 10:15',
    },
    {
      'vacancyId': 'vac-003',
      'title': 'Кассир выходного дня',
      'status': 'Принят',
      'note': 'Опыт работы на кассе 2 года',
      'timestamp': '2026-04-20 14:00',
    },
    {
      'vacancyId': 'vac-004',
      'title': 'Промоутер',
      'status': 'Отклонен',
      'note': '',
      'timestamp': '2026-04-19 09:45',
    },
  ];

  static const List<String> _statuses = [
    'Новый',
    'В работе',
    'Принят',
    'Отклонен',
  ];

  Future<void> _editApplication(int index) async {
    final app = _applications[index];
    final noteController = TextEditingController(text: app['note'] as String);
    String selectedStatus = app['status'] as String;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) => AlertDialog(
            title: const Text('Редактировать отклик'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Статус'),
                  items: _statuses
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
                  decoration: const InputDecoration(
                    labelText: 'Заметка',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _applications[index] = {
                      ...app,
                      'status': selectedStatus,
                      'note': noteController.text.trim(),
                    };
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Сохранить'),
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
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
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
                    'Мои отклики',
                    style: text.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_applications.length} заявок',
                    style: TextStyle(
                      fontSize: AppTypography.body,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _applications.isEmpty
                  ? Center(
                      child: Text(
                        'Пока нет откликов',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
                      itemCount: _applications.length,
                      itemBuilder: (context, index) {
                        final app = _applications[index];
                        final note = app['note'] as String;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.fromLTRB(16, 14, 10, 12),
                          decoration: BoxDecoration(
                            color: tokens.card,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            boxShadow: [
                              BoxShadow(
                                color: tokens.foreground.withOpacity(0.05),
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
                                      app['title'] as String,
                                      style: text.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert_rounded),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editApplication(index);
                                        return;
                                      }

                                      if (value == 'delete') {
                                        setState(
                                          () => _applications.removeAt(index),
                                        );
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Изменить'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Удалить'),
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
                                    'Обновлено: ${app['timestamp']}',
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
              selected: true,
              onTap: () {},
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
              selected: false,
              onTap: () => context.go(AppConstants.routeProfile),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = switch (status) {
      'Новый' => (tokens.primary, tokens.primary.withOpacity(0.12)),
      'В работе' => (tokens.warning, tokens.warning.withOpacity(0.15)),
      'Принят' => (tokens.success, tokens.success.withOpacity(0.14)),
      'Отклонен' => (tokens.destructive, tokens.destructive.withOpacity(0.12)),
      _ => (tokens.foreground, tokens.muted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$2,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: colors.$1.withOpacity(0.3)),
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

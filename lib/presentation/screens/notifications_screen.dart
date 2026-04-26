import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../core/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Ваш отклик принят!',
      'message': 'Компания FastLine приняла вашу заявку на позицию Курьер',
      'time': '5 мин назад',
      'icon': Icons.work_outline_rounded,
      'iconColorRole': 'primary',
      'isRead': false,
    },
    {
      'title': 'Новое сообщение',
      'message':
          'HR Market Hub: Здравствуйте! Когда вам удобно пройти собеседование?',
      'time': '1 час назад',
      'icon': Icons.chat_bubble_outline_rounded,
      'iconColorRole': 'primary',
      'isRead': false,
    },
    {
      'title': 'Новые вакансии для вас',
      'message': '15 новых вакансий в категории Курьер в вашем городе',
      'time': '3 часа назад',
      'icon': Icons.redeem_outlined,
      'iconColorRole': 'accent',
      'isRead': false,
    },
    {
      'title': 'Статус изменён',
      'message':
          'Ваш отклик на Сборщик заказов в FoodTown переведён в статус В работе',
      'time': 'Вчера',
      'icon': Icons.work_outline_rounded,
      'iconColorRole': 'primary',
      'isRead': true,
    },
    {
      'title': 'Заполните профиль',
      'message': 'Добавьте опыт работы, чтобы повысить шансы на отклик',
      'time': '2 дня назад',
      'icon': Icons.star_border_rounded,
      'iconColorRole': 'muted',
      'isRead': true,
    },
  ];

  int get _unreadCount =>
      _notifications.where((item) => !(item['isRead'] as bool)).length;

  void _markAllRead() {
    setState(() {
      for (final item in _notifications) {
        item['isRead'] = true;
      }
    });
  }

  void _markRead(int index) {
    if (_notifications[index]['isRead'] == true) {
      return;
    }

    setState(() {
      _notifications[index]['isRead'] = true;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

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
                    icon:
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  ),
                  Text(
                    'Уведомления',
                    style:
                        text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  if (_unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        _unreadCount.toString(),
                        style: text.bodySmall?.copyWith(
                          color: tokens.card,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _unreadCount == 0 ? null : _markAllRead,
                icon: Icon(Icons.done_all_rounded, color: colors.primary),
                label: Text(
                  'Прочитать все',
                  style: text.bodyMedium?.copyWith(color: colors.primary),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 14),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final item = _notifications[index];
                  final isRead = item['isRead'] as bool;
                  final colorRole = item['iconColorRole'] as String;

                  final iconColor = switch (colorRole) {
                    'accent' => tokens.accent,
                    'muted' => tokens.mutedForeground,
                    _ => colors.primary,
                  };

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: tokens.card,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(color: tokens.border),
                      boxShadow: [
                        BoxShadow(
                          color: tokens.foreground.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            decoration: BoxDecoration(
                              color:
                                  isRead ? Colors.transparent : colors.primary,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(AppRadius.xl),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: tokens.muted,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          item['icon'] as IconData,
                                          size: 20,
                                          color: iconColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item['title'] as String,
                                          style: text.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item['time'] as String,
                                        style: text.bodySmall?.copyWith(
                                          color: tokens.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 48),
                                    child: Text(
                                      item['message'] as String,
                                      style: text.bodyMedium?.copyWith(
                                        color: tokens.mutedForeground,
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (!isRead)
                                        TextButton.icon(
                                          onPressed: () => _markRead(index),
                                          icon: Icon(
                                            Icons.done_rounded,
                                            size: 16,
                                            color: colors.primary,
                                          ),
                                          label: Text(
                                            'Прочитано',
                                            style: text.bodySmall?.copyWith(
                                              color: colors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      IconButton(
                                        onPressed: () => _deleteItem(index),
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          color: tokens.destructive,
                                        ),
                                        tooltip: 'Удалить',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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

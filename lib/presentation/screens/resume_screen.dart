import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key});

  static const List<(IconData, String, String)> _personalData = [
    (Icons.person_outline_rounded, 'ФИО', 'Алексей Ким'),
    (Icons.phone_rounded, 'Телефон', '+7 (777) 123-45-67'),
    (Icons.mail_outline_rounded, 'Email', 'alexey.kim@email.com'),
    (Icons.location_on_outlined, 'Город', 'Алматы, Казахстан'),
    (Icons.calendar_month_outlined, 'Дата рождения', '15 мая 1998'),
  ];

  static const List<String> _skills = [
    'Курьер',
    'Сборщик',
    'Кассир',
    'Грузчик',
    'Официант',
  ];

  static const List<(String, String, String, String)> _workExperience = [
    (
      'Курьер',
      'Glovo',
      'Март 2025 - Настоящее время',
      'Доставка заказов на личном транспорте',
    ),
    (
      'Сборщик заказов',
      'Kaspi Магазин',
      'Январь 2025 - Март 2025',
      'Сборка и упаковка онлайн-заказов',
    ),
  ];

  static const List<(String, String)> _languages = [
    ('Русский', 'Родной'),
    ('Казахский', 'Свободно'),
    ('Английский', 'Базовый'),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
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
                  Expanded(
                    child: Text(
                      'Моё резюме',
                      style: text.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Изменить'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: tokens.border),
                      backgroundColor: tokens.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
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
                    title: 'Личные данные',
                    icon: Icons.person_outline_rounded,
                    child: Column(
                      children: _personalData
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: tokens.muted,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(item.$1,
                                        size: 16, color: colors.primary),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.$2,
                                          style: TextStyle(
                                            color: tokens.mutedForeground,
                                            fontSize: AppTypography.caption,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          item.$3,
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
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SectionCard(
                    title: 'О себе',
                    icon: Icons.info_outline_rounded,
                    child: Text(
                      'Ответственный, пунктуальный, есть личный транспорт. Готов к сменному графику и работе в выходные дни.',
                      style: text.bodyMedium?.copyWith(
                        color: tokens.mutedForeground,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SectionCard(
                    title: 'Навыки',
                    icon: Icons.psychology_alt_outlined,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _skills
                          .map(
                            (skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: tokens.muted,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                skill,
                                style: text.bodySmall?.copyWith(
                                  color: tokens.foreground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SectionCard(
                    title: 'Опыт работы',
                    icon: Icons.work_outline_rounded,
                    child: Column(
                      children: List.generate(_workExperience.length, (index) {
                        final exp = _workExperience[index];
                        final isLast = index == _workExperience.length - 1;

                        return Container(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                          margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
                          decoration: BoxDecoration(
                            border: isLast
                                ? null
                                : Border(
                                    bottom: BorderSide(color: tokens.border)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exp.$1,
                                style: text.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: tokens.foreground,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                exp.$2,
                                style: text.bodySmall?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                exp.$3,
                                style: text.bodySmall?.copyWith(
                                  color: tokens.mutedForeground,
                                  fontSize: AppTypography.caption,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                exp.$4,
                                style: text.bodySmall?.copyWith(
                                  color: tokens.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SectionCard(
                    title: 'Языки',
                    icon: Icons.translate_rounded,
                    child: Column(
                      children: _languages
                          .map(
                            (lang) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      lang.$1,
                                      style: text.bodyMedium?.copyWith(
                                        color: tokens.foreground,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: tokens.muted,
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.pill),
                                    ),
                                    child: Text(
                                      lang.$2,
                                      style: text.bodySmall?.copyWith(
                                        fontSize: AppTypography.caption,
                                        color: tokens.foreground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
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
            color: tokens.foreground.withOpacity(0.04),
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
              Text(
                title,
                style: text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
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

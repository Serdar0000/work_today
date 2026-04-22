// Слой: presentation | Назначение: экран статистики откликов с fl_chart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  static const List<(IconData, String, String, String, bool)> _kpiCards = [
    (
      Icons.visibility_outlined,
      '47',
      'Просмотров',
      '+12%',
      true,
    ),
    (
      Icons.send_outlined,
      '28',
      'Откликов',
      '+8%',
      true,
    ),
    (
      Icons.task_alt_rounded,
      '5',
      'Принято',
      '+2',
      true,
    ),
    (
      Icons.radio_button_checked_outlined,
      '3',
      'Отклонено',
      '-1',
      false,
    ),
  ];

  static const List<(String, double)> _applicationsByStatus = [
    ('Новые', 12),
    ('В работе', 8),
    ('Приняты', 5),
    ('Отклонены', 3),
  ];

  static const List<(String, double)> _categories = [
    ('Курьер', 35),
    ('Склад', 30),
    ('Касса', 20),
    ('Другое', 15),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    final chartColors = [
      tokens.chart1,
      tokens.chart2,
      tokens.chart3,
      tokens.chart4,
    ];

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: tokens.border),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статистика',
                    style: text.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Ваша активность за месяц',
                    style:
                        text.bodySmall?.copyWith(color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _kpiCards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final card = _kpiCards[index];
                      return _KpiCard(
                        icon: card.$1,
                        value: card.$2,
                        label: card.$3,
                        delta: card.$4,
                        deltaColor:
                            card.$5 ? tokens.success : tokens.destructive,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Распределение по статусам',
                          style: text.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Статусы ваших откликов',
                          style: TextStyle(
                            color: tokens.mutedForeground,
                            fontSize: AppTypography.caption,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 180,
                          child: BarChart(
                            BarChartData(
                              minY: 0,
                              maxY: 12,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 22,
                                    interval: 3,
                                    getTitlesWidget: (value, meta) => Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: AppTypography.caption,
                                      ),
                                    ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final i = value.toInt();
                                      if (i < 0 ||
                                          i >= _applicationsByStatus.length) {
                                        return const SizedBox.shrink();
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          _applicationsByStatus[i].$1,
                                          style: const TextStyle(
                                            fontSize: AppTypography.caption,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(
                                show: false,
                              ),
                              barGroups: List.generate(
                                _applicationsByStatus.length,
                                (i) => BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: _applicationsByStatus[i].$2,
                                      color: tokens.chart1,
                                      width: 24,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(AppRadius.sm),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                        Text(
                          'По категориям',
                          style: text.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'На какие вакансии откликаетесь',
                          style: TextStyle(
                            color: tokens.mutedForeground,
                            fontSize: AppTypography.caption,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SizedBox(
                              width: 118,
                              height: 118,
                              child: PieChart(
                                PieChartData(
                                  centerSpaceRadius: 28,
                                  sectionsSpace: 2,
                                  borderData: FlBorderData(show: false),
                                  sections: _categories
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => PieChartSectionData(
                                          value: entry.value.$2,
                                          color: chartColors[
                                              entry.key % chartColors.length],
                                          radius: 30,
                                          title: '',
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _categories
                                    .map(
                                      (item) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6),
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: colorScheme.onSurface,
                                              fontSize: AppTypography.body,
                                            ),
                                            children: [
                                              TextSpan(text: '${item.$1}  '),
                                              TextSpan(
                                                text: '${item.$2.toInt()}%',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
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
              selected: false,
              onTap: () => context.go(AppConstants.routeMyApplications),
            ),
            _BottomNavItem(
              icon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart_rounded,
              label: 'Статистика',
              selected: true,
              onTap: () {},
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
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: tokens.foreground.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.delta,
    required this.deltaColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final String delta;
  final Color deltaColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tokens = context.appColors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: tokens.foreground.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: tokens.muted,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: colorScheme.primary),
              ),
              const Spacer(),
              Text(
                '↗ $delta',
                style: TextStyle(
                  color: deltaColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppTypography.caption,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppTypography.sectionTitle,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.caption,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
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

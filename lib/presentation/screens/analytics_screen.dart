import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../domain/entities/user.dart';
import '../blocs/auth/auth_bloc.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    if (authState is! AuthAuthenticated ||
        authState.user.activeContext != UserRole.worker ||
        (authState.user.authUid?.isEmpty ?? true)) {
      return AppSafeScaffold(
        backgroundColor: tokens.background,
        body: const Center(child: Text('Статистика доступна соискателю')),
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
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final stats = _WorkerStats.from(docs);
          final colorScheme = Theme.of(context).colorScheme;
          final chartColors = [tokens.chart1, tokens.chart2, tokens.chart3, tokens.chart4];

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: tokens.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Статистика',
                      style: text.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Реальные данные по вашим откликам',
                      style: text.bodySmall?.copyWith(color: tokens.mutedForeground),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.2,
                      children: [
                        _KpiCard(
                          icon: Icons.send_outlined,
                          value: '${stats.total}',
                          label: 'Откликов',
                          delta: 'всего',
                          deltaColor: tokens.mutedForeground,
                        ),
                        _KpiCard(
                          icon: Icons.pending_actions_outlined,
                          value: '${stats.inProgress}',
                          label: 'В работе',
                          delta: 'активные',
                          deltaColor: tokens.warning,
                        ),
                        _KpiCard(
                          icon: Icons.task_alt_rounded,
                          value: '${stats.accepted}',
                          label: 'Принято',
                          delta: '${stats.acceptedRate}%',
                          deltaColor: tokens.success,
                        ),
                        _KpiCard(
                          icon: Icons.cancel_outlined,
                          value: '${stats.rejected}',
                          label: 'Отклонено',
                          delta: '${stats.rejectedRate}%',
                          deltaColor: tokens.destructive,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Распределение по статусам',
                            style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
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
                                maxY: stats.statusMaxY,
                                barTouchData: BarTouchData(enabled: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 22,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) => Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: AppTypography.caption),
                                      ),
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final i = value.toInt();
                                        if (i < 0 || i >= stats.statusBars.length) {
                                          return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            stats.statusBars[i].$1,
                                            style: const TextStyle(fontSize: AppTypography.caption),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles:
                                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles:
                                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: false),
                                barGroups: List.generate(
                                  stats.statusBars.length,
                                  (i) => BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: stats.statusBars[i].$2.toDouble(),
                                        color: tokens.chart1,
                                        width: 24,
                                        borderRadius:
                                            const BorderRadius.vertical(top: Radius.circular(6)),
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
                            'По вакансиям',
                            style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Куда вы чаще откликаетесь',
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
                                    sections: stats.topVacancies
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => PieChartSectionData(
                                            value: entry.value.$2.toDouble(),
                                            color: chartColors[entry.key % chartColors.length],
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
                                  children: stats.topVacancies
                                      .map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                                fontSize: AppTypography.body,
                                              ),
                                              children: [
                                                TextSpan(text: '${item.$1}  '),
                                                TextSpan(
                                                  text: '${item.$2}',
                                                  style: const TextStyle(fontWeight: FontWeight.w700),
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
          );
        },
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

class _WorkerStats {
  _WorkerStats({
    required this.total,
    required this.inProgress,
    required this.accepted,
    required this.rejected,
    required this.acceptedRate,
    required this.rejectedRate,
    required this.statusBars,
    required this.statusMaxY,
    required this.topVacancies,
  });

  final int total;
  final int inProgress;
  final int accepted;
  final int rejected;
  final int acceptedRate;
  final int rejectedRate;
  final List<(String, int)> statusBars;
  final double statusMaxY;
  final List<(String, int)> topVacancies;

  static _WorkerStats from(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    int countStatus(String s) =>
        docs.where((d) => (d.data()['status'] as String?) == s).length;

    final total = docs.length;
    final accepted = countStatus('Принят');
    final rejected = countStatus('Отклонен');
    final inProgress = countStatus('Новый') +
        countStatus('В работе') +
        countStatus('На рассмотрении') +
        countStatus('Собеседование');
    final acceptedRate = total == 0 ? 0 : ((accepted / total) * 100).round();
    final rejectedRate = total == 0 ? 0 : ((rejected / total) * 100).round();

    final statusBars = <(String, int)>[
      ('Новые', countStatus('Новый')),
      ('В работе', countStatus('В работе') + countStatus('На рассмотрении')),
      ('Приняты', accepted),
      ('Отклонены', rejected),
    ];
    final maxBar = statusBars.fold<int>(0, (m, e) => m > e.$2 ? m : e.$2);
    final statusMaxY = (maxBar < 4 ? 4 : maxBar + 1).toDouble();

    final byVacancy = <String, int>{};
    for (final d in docs) {
      final title = (d.data()['vacancyTitle'] as String?)?.trim();
      if (title == null || title.isEmpty) continue;
      byVacancy[title] = (byVacancy[title] ?? 0) + 1;
    }
    final topVacancies = byVacancy.entries
        .map((e) => (e.key, e.value))
        .toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));

    return _WorkerStats(
      total: total,
      inProgress: inProgress,
      accepted: accepted,
      rejected: rejected,
      acceptedRate: acceptedRate,
      rejectedRate: rejectedRate,
      statusBars: statusBars,
      statusMaxY: statusMaxY,
      topVacancies: topVacancies.isEmpty ? [('Нет данных', 1)] : topVacancies.take(4).toList(),
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
            color: tokens.foreground.withValues(alpha: 0.04),
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
                decoration: BoxDecoration(color: tokens.muted, shape: BoxShape.circle),
                child: Icon(icon, size: 14, color: colorScheme.primary),
              ),
              const Spacer(),
              Text(
                delta,
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
            color: selected ? colors.primary.withValues(alpha: 0.12) : Colors.transparent,
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

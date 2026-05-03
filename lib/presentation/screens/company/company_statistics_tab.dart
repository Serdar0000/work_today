import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/auth/auth_bloc.dart';

const Color _chartBlue = Color(0xFF2563EB);
const Color _chartRed = Color(0xFFDC2626);
const Color _donutBlue = Color(0xFF2563EB);
const Color _donutYellow = Color(0xFFEAB308);
const Color _donutPurple = Color(0xFF7C3AED);
const Color _donutGreen = Color(0xFF22C55E);
const Color _donutRed = Color(0xFFEF4444);

class CompanyStatisticsTab extends StatelessWidget {
  const CompanyStatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    final authState = context.watch<AuthBloc>().state;

    if (authState is! AuthAuthenticated ||
        authState.user.activeContext != UserRole.company ||
        (authState.user.authUid?.isEmpty ?? true)) {
      return Center(
        child: Text(AppLocalizations.of(context).companyStatisticsCompanyOnly),
      );
    }
    final uid = authState.user.authUid!;

    final vacanciesStream = FirebaseFirestore.instance
        .collection('vacancies')
        .where('ownerUid', isEqualTo: uid)
        .snapshots();
    final applicationsStream = FirebaseFirestore.instance
        .collection('applications')
        .where('companyUid', isEqualTo: uid)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: vacanciesStream,
      builder: (context, vacanciesSnapshot) {
        if (vacanciesSnapshot.hasError) {
          return Center(
            child: Text(
              AppLocalizations.of(context).companyStatisticsVacanciesError(
                '${vacanciesSnapshot.error}',
              ),
            ),
          );
        }
        if (!vacanciesSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final vacancies = vacanciesSnapshot.data!.docs;

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: applicationsStream,
          builder: (context, appsSnapshot) {
            if (appsSnapshot.hasError) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)
                      .companyStatisticsApplicationsError(
                    '${appsSnapshot.error}',
                  ),
                ),
              );
            }
            if (!appsSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final applications = appsSnapshot.data!.docs;
            final stats = _CompanyStats.from(vacancies, applications);

            return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Text(
              AppLocalizations.of(context).companyStatisticsFirestoreHint,
              style: text.bodyMedium?.copyWith(
                color: tokens.mutedForeground,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverToBoxAdapter(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: [
                _KpiTile(
                  icon: Icons.visibility_outlined,
                  value: '${stats.totalViews}',
                  label: 'Просмотры',
                  sub: 'Сумма по вакансиям',
                  subPositive: null,
                ),
                _KpiTile(
                  icon: Icons.person_add_alt_1_outlined,
                  value: '${stats.totalApplications}',
                  label: 'Отклики',
                  sub: 'Всего заявок',
                  subPositive: null,
                ),
                _KpiTile(
                  icon: Icons.verified_user_outlined,
                  value: '${stats.acceptedCount}',
                  label: 'Приняты',
                  sub: '${stats.conversionPercent}% конверсия',
                  subPositive: null,
                ),
                _KpiTile(
                  icon: Icons.schedule_outlined,
                  value: '${stats.activeVacancies}',
                  label: 'Активные',
                  sub: 'Вакансии в работе',
                  subPositive: null,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _Section(
              tokens: tokens,
              text: text,
              title: 'Динамика за неделю',
              subtitle: 'Публикации и отклики по дням',
              child: SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: stats.weekMaxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 15,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: tokens.border.withValues(alpha: 0.6),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 15,
                          getTitlesWidget: (v, _) => Text(
                            v.toInt().toString(),
                            style: text.bodySmall?.copyWith(
                              color: tokens.mutedForeground,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (v, _) {
                            const days = [
                              'Пн',
                              'Вт',
                              'Ср',
                              'Чт',
                              'Пт',
                              'Сб',
                              'Вс',
                            ];
                            final i = v.toInt().clamp(0, 6);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                days[i],
                                style: text.bodySmall?.copyWith(
                                  color: tokens.mutedForeground,
                                  fontSize: 11,
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
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: stats.weekVacanciesSpots,
                        isCurved: true,
                        color: _chartBlue,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: _chartBlue.withValues(alpha: 0.08),
                        ),
                      ),
                      LineChartBarData(
                        spots: stats.weekApplicationsSpots,
                        isCurved: true,
                        color: _chartRed,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: _chartRed.withValues(alpha: 0.06),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: _chartBlue, label: 'Просмотры', text: text),
                _LegendDot(color: _chartBlue, label: 'Публикации', text: text),
                const SizedBox(width: 20),
                _LegendDot(color: _chartRed, label: 'Отклики', text: text),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _Section(
              tokens: tokens,
              text: text,
              title: 'Отклики по вакансиям',
              subtitle: 'Сравнение охвата и откликов',
              child: Column(
                children: stats.byVacancy.map((e) {
                  final maxV = (stats.maxVacancyMetric <= 0 ? 1 : stats.maxVacancyMetric).toDouble();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _HBar(
                          label: 'Просмотры',
                          value: e.views.toDouble(),
                          max: maxV,
                          color: _chartBlue,
                          tokens: tokens,
                          text: text,
                        ),
                        const SizedBox(height: 4),
                        _HBar(
                          label: 'Отклики',
                          value: e.apps.toDouble(),
                          max: maxV,
                          color: _chartRed,
                          tokens: tokens,
                          text: text,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _Section(
              tokens: tokens,
              text: text,
              title: 'Распределение по статусам',
              subtitle: 'Все отклики за период',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 44,
                        borderData: FlBorderData(show: false),
                        sections: stats.donutSections,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: stats.statusDonut.map((s) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: s.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.label,
                                  style: text.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${s.count}',
                                style: text.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _Section(
              tokens: tokens,
              text: text,
              title: 'Лучшие вакансии по конверсии',
              subtitle: 'Доля откликов к просмотрам',
              child: Column(
                children: List.generate(stats.bestConversion.length, (i) {
                  final e = stats.bestConversion[i];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i == stats.bestConversion.length - 1 ? 0 : 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${i + 1}.',
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: tokens.mutedForeground,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            e.title,
                            style: text.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          e.up
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: e.up ? tokens.success : tokens.destructive,
                          size: 22,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${e.percent}%',
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: e.up ? tokens.success : tokens.destructive,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          sliver: SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tokens.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: tokens.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline_rounded,
                          color: tokens.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Инсайты',
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: tokens.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InsightLine(
                    text: text,
                    body:
                        'Всего активных вакансий: ${stats.activeVacancies}, суммарно просмотров: ${stats.totalViews}.',
                  ),
                  _InsightLine(
                    text: text,
                    body:
                        'Текущая конверсия в принятие: ${stats.conversionPercent}%.',
                  ),
                  _InsightLine(
                    text: text,
                    body:
                        'Новые отклики: ${stats.newCount}, в работе: ${stats.reviewCount}.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
          },
        );
      },
    );
  }
}

class _CompanyStats {
  _CompanyStats({
    required this.totalViews,
    required this.totalApplications,
    required this.acceptedCount,
    required this.activeVacancies,
    required this.conversionPercent,
    required this.weekVacanciesSpots,
    required this.weekApplicationsSpots,
    required this.weekMaxY,
    required this.byVacancy,
    required this.maxVacancyMetric,
    required this.statusDonut,
    required this.bestConversion,
    required this.newCount,
    required this.reviewCount,
  });

  final int totalViews;
  final int totalApplications;
  final int acceptedCount;
  final int activeVacancies;
  final int conversionPercent;
  final List<FlSpot> weekVacanciesSpots;
  final List<FlSpot> weekApplicationsSpots;
  final double weekMaxY;
  final List<({String title, int views, int apps})> byVacancy;
  final int maxVacancyMetric;
  final List<({String label, int count, Color color})> statusDonut;
  final List<({String title, int percent, bool up})> bestConversion;
  final int newCount;
  final int reviewCount;

  List<PieChartSectionData> get donutSections => statusDonut
      .map(
        (s) => PieChartSectionData(
          value: s.count.toDouble(),
          color: s.color,
          radius: 22,
          title: '',
        ),
      )
      .toList();

  static _CompanyStats from(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> vacancies,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> applications,
  ) {
    final totalViews = vacancies.fold<int>(
      0,
      (sum, v) => sum + ((v.data()['viewsCount'] as num?)?.toInt() ?? 0),
    );
    final totalApplications = applications.length;
    final acceptedCount = applications
        .where((a) => (a.data()['status'] as String?) == 'Принят')
        .length;
    final reviewCount = applications
        .where((a) => (a.data()['status'] as String?) == 'На рассмотрении')
        .length;
    final newCount = applications
        .where((a) => (a.data()['status'] as String?) == 'Новый')
        .length;
    final activeVacancies = vacancies
        .where((v) => ((v.data()['status'] as num?)?.toInt() ?? 0) == 0)
        .length;

    final conversionPercent = totalApplications == 0
        ? 0
        : ((acceptedCount / totalApplications) * 100).round();

    final now = DateTime.now();
    DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
    final weekDays = List.generate(
      7,
      (i) => _day(now.subtract(Duration(days: 6 - i))),
    );

    final vacancyByDay = <DateTime, int>{for (final d in weekDays) d: 0};
    for (final v in vacancies) {
      final t = v.data()['createdAt'];
      final date = t is Timestamp ? _day(t.toDate()) : null;
      if (date != null && vacancyByDay.containsKey(date)) {
        vacancyByDay[date] = (vacancyByDay[date] ?? 0) + 1;
      }
    }
    final appByDay = <DateTime, int>{for (final d in weekDays) d: 0};
    for (final a in applications) {
      final t = a.data()['createdAt'];
      final date = t is Timestamp ? _day(t.toDate()) : null;
      if (date != null && appByDay.containsKey(date)) {
        appByDay[date] = (appByDay[date] ?? 0) + 1;
      }
    }
    final weekVacanciesSpots = List.generate(
      7,
      (i) => FlSpot(i.toDouble(), (vacancyByDay[weekDays[i]] ?? 0).toDouble()),
    );
    final weekApplicationsSpots = List.generate(
      7,
      (i) => FlSpot(i.toDouble(), (appByDay[weekDays[i]] ?? 0).toDouble()),
    );
    final weekMaxVal = [
      ...weekVacanciesSpots.map((e) => e.y),
      ...weekApplicationsSpots.map((e) => e.y),
    ].fold<double>(0, (a, b) => a > b ? a : b);
    final weekMaxY = (weekMaxVal < 4 ? 4.0 : weekMaxVal + 1.0);

    final appsByVacancy = <int, int>{};
    for (final a in applications) {
      final vacancyId = (a.data()['vacancyId'] as num?)?.toInt();
      if (vacancyId == null) continue;
      appsByVacancy[vacancyId] = (appsByVacancy[vacancyId] ?? 0) + 1;
    }
    final byVacancy = vacancies.map((v) {
      final data = v.data();
      final id = (data['id'] as num?)?.toInt() ?? 0;
      final title = (data['title'] as String?) ?? 'Вакансия';
      final views = (data['viewsCount'] as num?)?.toInt() ?? 0;
      final apps = appsByVacancy[id] ?? 0;
      return (title: title, views: views, apps: apps);
    }).toList()
      ..sort((a, b) => b.apps.compareTo(a.apps));
    final maxVacancyMetric = byVacancy.fold<int>(
      0,
      (m, e) => [m, e.views, e.apps].reduce((a, b) => a > b ? a : b),
    );

    final statusDonut = <({String label, int count, Color color})>[
      (label: 'Новые', count: newCount, color: _donutBlue),
      (label: 'В работе', count: reviewCount, color: _donutYellow),
      (
        label: 'Собеседование',
        count: applications
            .where((a) => (a.data()['status'] as String?) == 'Собеседование')
            .length,
        color: _donutPurple,
      ),
      (label: 'Приняты', count: acceptedCount, color: _donutGreen),
      (
        label: 'Отклонены',
        count:
            applications.where((a) => (a.data()['status'] as String?) == 'Отклонен').length,
        color: _donutRed,
      ),
    ];

    final bestConversion = byVacancy.take(3).map((v) {
      final p = v.views == 0 ? 0 : ((v.apps / v.views) * 100).round();
      return (title: v.title, percent: p, up: p >= 15);
    }).toList();

    return _CompanyStats(
      totalViews: totalViews,
      totalApplications: totalApplications,
      acceptedCount: acceptedCount,
      activeVacancies: activeVacancies,
      conversionPercent: conversionPercent,
      weekVacanciesSpots: weekVacanciesSpots,
      weekApplicationsSpots: weekApplicationsSpots,
      weekMaxY: weekMaxY,
      byVacancy: byVacancy,
      maxVacancyMetric: maxVacancyMetric,
      statusDonut: statusDonut,
      bestConversion: bestConversion,
      newCount: newCount,
      reviewCount: reviewCount,
    );
  }
}

class _InsightLine extends StatelessWidget {
  const _InsightLine({required this.text, required this.body});

  final TextTheme text;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: text.bodyMedium),
          Expanded(
            child: Text(body, style: text.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    required this.text,
  });

  final Color color;
  final String label;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: text.bodySmall),
      ],
    );
  }
}

class _HBar extends StatelessWidget {
  const _HBar({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    required this.tokens,
    required this.text,
  });

  final String label;
  final double value;
  final double max;
  final Color color;
  final AppColors tokens;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    final t = (value / max).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: text.bodySmall?.copyWith(
              color: tokens.mutedForeground,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: t,
              minHeight: 8,
              backgroundColor: tokens.muted,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value.toInt().toString(),
          style: text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.sub,
    this.subPositive,
  });

  final IconData icon;
  final String value;
  final String label;
  final String sub;
  /// null — нейтральный цвет подписи
  final bool? subPositive;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    final subColor = subPositive == null
        ? tokens.mutedForeground
        : (subPositive! ? tokens.success : tokens.destructive);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: tokens.primary),
          const Spacer(),
          Text(
            value,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: text.bodySmall?.copyWith(color: tokens.mutedForeground),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: text.labelSmall?.copyWith(
              color: subColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.tokens,
    required this.text,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final AppColors tokens;
  final TextTheme text;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: text.bodySmall?.copyWith(color: tokens.mutedForeground),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

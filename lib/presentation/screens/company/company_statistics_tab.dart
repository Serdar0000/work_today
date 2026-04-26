// Слой: presentation | Назначение: таб «Статистика» компании — дашборд за 30 дней (mock; дальше Firestore/агрегации)

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

const Color _chartBlue = Color(0xFF2563EB);
const Color _chartRed = Color(0xFFDC2626);
const Color _donutBlue = Color(0xFF2563EB);
const Color _donutYellow = Color(0xFFEAB308);
const Color _donutPurple = Color(0xFF7C3AED);
const Color _donutGreen = Color(0xFF22C55E);
const Color _donutRed = Color(0xFFEF4444);

class CompanyStatisticsTab extends StatelessWidget {
  const CompanyStatisticsTab({super.key});

  static const List<FlSpot> _viewsWeek = [
    FlSpot(0, 38),
    FlSpot(1, 45),
    FlSpot(2, 42),
    FlSpot(3, 55),
    FlSpot(4, 48),
    FlSpot(5, 52),
    FlSpot(6, 44),
  ];

  static const List<FlSpot> _appsWeek = [
    FlSpot(0, 8),
    FlSpot(1, 10),
    FlSpot(2, 7),
    FlSpot(3, 14),
    FlSpot(4, 11),
    FlSpot(5, 9),
    FlSpot(6, 10),
  ];

  static const List<({String title, double views, double apps})> _byVacancy = [
    (title: 'Курьер', views: 48, apps: 22),
    (title: 'Сборщик', views: 40, apps: 18),
    (title: 'Кассир', views: 32, apps: 12),
    (title: 'Клининг', views: 24, apps: 8),
  ];

  static const List<({String label, int count, Color color})> _statusDonut = [
    (label: 'Новые', count: 15, color: _donutBlue),
    (label: 'В работе', count: 22, color: _donutYellow),
    (label: 'Собеседование', count: 8, color: _donutPurple),
    (label: 'Приняты', count: 11, color: _donutGreen),
    (label: 'Отклонены', count: 6, color: _donutRed),
  ];

  static const List<({String title, int percent, bool up})> _bestConversion = [
    (title: 'Курьер вечерний', percent: 21, up: true),
    (title: 'Сборщик заказов', percent: 17, up: true),
    (title: 'Кассир выходных', percent: 15, up: false),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Аналитика за последние 30 дней',
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
              children: const [
                _KpiTile(
                  icon: Icons.visibility_outlined,
                  value: '331',
                  label: 'Просмотры',
                  sub: '+12% за неделю',
                  subPositive: true,
                ),
                _KpiTile(
                  icon: Icons.person_add_alt_1_outlined,
                  value: '62',
                  label: 'Отклики',
                  sub: '+8% за неделю',
                  subPositive: true,
                ),
                _KpiTile(
                  icon: Icons.verified_user_outlined,
                  value: '11',
                  label: 'Приняты',
                  sub: '18% конверсия',
                  subPositive: null,
                ),
                _KpiTile(
                  icon: Icons.schedule_outlined,
                  value: '2.3ч',
                  label: 'Время ответа',
                  sub: '-15% быстрее',
                  subPositive: true,
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
              subtitle: 'Просмотры и отклики по дням',
              child: SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 60,
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
                        spots: _viewsWeek,
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
                        spots: _appsWeek,
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
                children: _byVacancy.map((e) {
                  const maxV = 50.0;
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
                          value: e.views,
                          max: maxV,
                          color: _chartBlue,
                          tokens: tokens,
                          text: text,
                        ),
                        const SizedBox(height: 4),
                        _HBar(
                          label: 'Отклики',
                          value: e.apps,
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
                        sections: _donutSections,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _statusDonut.map((s) {
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
                children: List.generate(_bestConversion.length, (i) {
                  final e = _bestConversion[i];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i == _bestConversion.length - 1 ? 0 : 12,
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
                        'Больше всего откликов приходит в четверг — усильте публикации в середине недели.',
                  ),
                  _InsightLine(
                    text: text,
                    body:
                        'У вакансий «курьер» самая высокая конверсия из просмотра в отклик.',
                  ),
                  _InsightLine(
                    text: text,
                    body:
                        'Среднее время от первого отклика до найма — около 5 дней.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static List<PieChartSectionData> get _donutSections {
    return _statusDonut
        .map(
          (s) => PieChartSectionData(
            value: s.count.toDouble(),
            color: s.color,
            radius: 22,
            title: '',
          ),
        )
        .toList();
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

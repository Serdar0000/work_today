// Слой: presentation | Назначение: таб «Кандидаты» — отклики (пока mock; дальше: Firestore applications по companyId)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';

/// Стадия отклика — для бейджей и фильтра.
enum CandidateApplicationStatus {
  newApp,
  reviewing,
  interview,
  accepted,
}

extension on CandidateApplicationStatus {
  String get shortLabel {
    return switch (this) {
      CandidateApplicationStatus.newApp => 'Новый',
      CandidateApplicationStatus.reviewing => 'На рассмотрении',
      CandidateApplicationStatus.interview => 'Собеседование',
      CandidateApplicationStatus.accepted => 'Принят',
    };
  }
}

@immutable
class _CandidateItem {
  const _CandidateItem({
    required this.id,
    required this.name,
    required this.status,
    required this.rating,
    required this.vacancyTitle,
    required this.city,
    required this.appliedAt,
    this.quote,
  });

  final String id;
  final String name;
  final CandidateApplicationStatus status;
  final double rating;
  final String vacancyTitle;
  final String city;
  final DateTime appliedAt;
  final String? quote;
}

class CompanyCandidatesTab extends StatefulWidget {
  const CompanyCandidatesTab({super.key});

  @override
  State<CompanyCandidatesTab> createState() => _CompanyCandidatesTabState();
}

class _CompanyCandidatesTabState extends State<CompanyCandidatesTab> {
  final _searchController = TextEditingController();
  // ignore: prefer_final_fields
  Set<CandidateApplicationStatus>? _statusFilter; // null = все

  static final List<_CandidateItem> _mock = [
    _CandidateItem(
      id: '1',
      name: 'Алексей Иванов',
      status: CandidateApplicationStatus.newApp,
      rating: 4.8,
      vacancyTitle: 'Курьер на вечерние смены',
      city: 'Алматы',
      appliedAt: DateTime(2025, 4, 25),
      quote: 'Могу выходить в ночные смены',
    ),
    _CandidateItem(
      id: '2',
      name: 'Мария Сидорова',
      status: CandidateApplicationStatus.reviewing,
      rating: 4.5,
      vacancyTitle: 'Курьер на вечерние смены',
      city: 'Алматы',
      appliedAt: DateTime(2025, 4, 24),
    ),
    _CandidateItem(
      id: '3',
      name: 'Даулет Касымов',
      status: CandidateApplicationStatus.interview,
      rating: 4.9,
      vacancyTitle: 'Курьер на вечерние смены',
      city: 'Алматы',
      appliedAt: DateTime(2025, 4, 20),
    ),
    _CandidateItem(
      id: '4',
      name: 'Елена Петрова',
      status: CandidateApplicationStatus.accepted,
      rating: 4.2,
      vacancyTitle: 'Комплектовщик (склад)',
      city: 'Алматы',
      appliedAt: DateTime(2025, 4, 15),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CandidateItem> get _filtered {
    var list = _mock;
    if (_searchController.text.trim().isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      list = list
          .where(
            (e) =>
                e.name.toLowerCase().contains(q) ||
                e.vacancyTitle.toLowerCase().contains(q),
          )
          .toList();
    }
    if (_statusFilter != null && _statusFilter!.isNotEmpty) {
      list = list
          .where((e) => _statusFilter!.contains(e.status))
          .toList();
    }
    return list;
  }

  int get _totalApplications => _mock.length;

  int get _newCount => _mock
      .where((e) => e.status == CandidateApplicationStatus.newApp)
      .length;

  void _openFilter() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: const Text('Все стадии'),
                trailing: _statusFilter == null
                    ? const Icon(Icons.check, size: 20)
                    : null,
                onTap: () {
                  setState(() => _statusFilter = null);
                  Navigator.pop(ctx);
                },
              ),
              ...CandidateApplicationStatus.values.map((s) {
                final sel = _statusFilter?.contains(s) ?? false;
                return ListTile(
                  title: Text(s.shortLabel),
                  trailing: sel ? const Icon(Icons.check, size: 20) : null,
                  onTap: () {
                    setState(() {
                      _statusFilter = {s};
                    });
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    final list = _filtered;
    const blueNew = Color(0xFF2563EB);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Все кандидаты',
                    style: text.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _openFilter,
                  icon: const Icon(Icons.filter_list_rounded, size: 20),
                  label: const Text('Фильтр'),
                  style: TextButton.styleFrom(foregroundColor: tokens.primary),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverToBoxAdapter(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Поиск кандидатов...',
                prefixIcon: const Icon(Icons.search_rounded, size: 22),
                filled: true,
                fillColor: tokens.muted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Всего откликов',
                    value: '$_totalApplications',
                    valueColor: tokens.foreground,
                    tokens: tokens,
                    text: text,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Новых',
                    value: '$_newCount',
                    valueColor: blueNew,
                    tokens: tokens,
                    text: text,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (list.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'Нет кандидатов по запросу',
                style: text.bodyLarge?.copyWith(
                  color: tokens.mutedForeground,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _CandidateCard(
                  item: list[i],
                  tokens: tokens,
                  text: text,
                ),
                childCount: list.length,
              ),
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.tokens,
    required this.text,
  });

  final String label;
  final String value;
  final Color valueColor;
  final AppColors tokens;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: tokens.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: text.bodySmall?.copyWith(
                color: tokens.mutedForeground,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: text.headlineSmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.item,
    required this.tokens,
    required this.text,
  });

  final _CandidateItem item;
  final AppColors tokens;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDateRu(item.appliedAt);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: () {
            // TODO: детали отклика
          },
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: tokens.border),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: tokens.muted,
                  child: Icon(
                    Icons.person_rounded,
                    color: tokens.mutedForeground,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.name,
                              style: text.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusPill(
                            status: item.status,
                            text: text,
                            tokens: tokens,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Color(0xFFEAB308),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            item.rating.toStringAsFixed(1),
                            style: text.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.vacancyTitle,
                        style: text.bodySmall?.copyWith(
                          color: tokens.mutedForeground,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$dateStr  ·  ${item.city}',
                        style: text.bodySmall?.copyWith(
                          color: tokens.mutedForeground,
                          fontSize: 12,
                        ),
                      ),
                      if (item.quote != null && item.quote!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          '«${item.quote}»',
                          style: text.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: tokens.foreground,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: tokens.mutedForeground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateRu(DateTime d) {
    final s = DateFormat('d MMM', 'ru').format(d);
    if (s.endsWith('м.')) {
      return s; // e.g. 25 апр.
    }
    return s.replaceAll('.', ''); // подстраховка
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.status,
    required this.text,
    required this.tokens,
  });

  final CandidateApplicationStatus status;
  final TextTheme text;
  final AppColors tokens;

  (Color bg, Color fg) _colors() {
    return switch (status) {
      CandidateApplicationStatus.newApp => (
          const Color(0xFFDBEAFE),
          const Color(0xFF1D4ED8),
        ),
      CandidateApplicationStatus.reviewing => (
          const Color(0xFFFEF3C7),
          const Color(0xFFD97706),
        ),
      CandidateApplicationStatus.interview => (
          const Color(0xFFEDE9FE),
          const Color(0xFF6D28D9),
        ),
      CandidateApplicationStatus.accepted => (
          tokens.success.withValues(alpha: 0.2),
          tokens.success,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        status.shortLabel,
        style: text.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

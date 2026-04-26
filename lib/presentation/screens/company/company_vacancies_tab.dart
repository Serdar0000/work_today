// Слой: presentation | Назначение: таб «Вакансии» — список, поиск, фильтры (данные: mock / позже Firestore)

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Упрощённая модель карточки (позже — сущность + репозиторий).
@immutable
class _VacancyListItem {
  const _VacancyListItem({
    required this.id,
    required this.title,
    required this.isActive,
    required this.salaryFrom,
    required this.salaryTo,
    required this.views,
    required this.applications,
    required this.tag,
  });

  final String id;
  final String title;
  final bool isActive;
  final int salaryFrom;
  final int salaryTo;
  final int views;
  final int applications;
  final String tag;
}

class CompanyVacanciesTab extends StatefulWidget {
  const CompanyVacanciesTab({super.key, this.onCreateTap});

  final VoidCallback? onCreateTap;

  @override
  State<CompanyVacanciesTab> createState() => _CompanyVacanciesTabState();
}

class _CompanyVacanciesTabState extends State<CompanyVacanciesTab> {
  final _searchController = TextEditingController();

  /// 0: все, 1: активные, 2: на паузе
  int _filterIndex = 0;

  static const List<_VacancyListItem> _mock = [
    _VacancyListItem(
      id: '1',
      title: 'Курьер на вечерние смены',
      isActive: true,
      salaryFrom: 200000,
      salaryTo: 320000,
      views: 156,
      applications: 24,
      tag: 'Курьер',
    ),
    _VacancyListItem(
      id: '2',
      title: 'Комплектовщик (склад)',
      isActive: false,
      salaryFrom: 180000,
      salaryTo: 250000,
      views: 89,
      applications: 12,
      tag: 'Склад',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_VacancyListItem> get _filtered {
    var list = _mock;
    if (_searchController.text.trim().isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      list = list
          .where((e) => e.title.toLowerCase().contains(q))
          .toList();
    }
    switch (_filterIndex) {
      case 1:
        return list.where((e) => e.isActive).toList();
      case 2:
        return list.where((e) => !e.isActive).toList();
      default:
        return list;
    }
  }

  int get _activeCount => _mock.where((e) => e.isActive).length;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    const brandRed = Color(0xFFDC2626);
    final list = _filtered;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Мои вакансии',
                        style: text.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_activeCount ${_pluralActive(_activeCount)}',
                        style: text.bodyMedium?.copyWith(
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonal(
                  onPressed: widget.onCreateTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: tokens.primary.withValues(alpha: 0.12),
                    foregroundColor: tokens.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                  ),
                  child: const Text('+ Создать'),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          sliver: SliverToBoxAdapter(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Поиск вакансий...',
                prefixIcon: const Icon(Icons.search_rounded, size: 22),
                filled: true,
                fillColor: tokens.muted,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'Все',
                  selected: _filterIndex == 0,
                  selectedColor: brandRed,
                  onTap: () => setState(() => _filterIndex = 0),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Активные',
                  selected: _filterIndex == 1,
                  selectedColor: brandRed,
                  onTap: () => setState(() => _filterIndex = 1),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'На паузе',
                  selected: _filterIndex == 2,
                  selectedColor: brandRed,
                  onTap: () => setState(() => _filterIndex = 2),
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
                'Нет вакансий по фильтру',
                style: text.bodyLarge?.copyWith(
                  color: tokens.mutedForeground,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final v = list[i];
                  return _VacancyCard(
                    item: v,
                    tokens: tokens,
                    text: text,
                    accent: themeAccent(context),
                  );
                },
                childCount: list.length,
              ),
            ),
          ),
      ],
    );
  }

  String _pluralActive(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod100 >= 11 && mod100 <= 19) {
      return 'активных';
    }
    if (mod10 == 1) {
      return 'активная';
    }
    if (mod10 >= 2 && mod10 <= 4) {
      return 'активных';
    }
    return 'активных';
  }

  static Color themeAccent(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    return Material(
      color: selected ? selectedColor : tokens.muted,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : tokens.mutedForeground,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _VacancyCard extends StatelessWidget {
  const _VacancyCard({
    required this.item,
    required this.tokens,
    required this.text,
    required this.accent,
  });

  final _VacancyListItem item;
  final AppColors tokens;
  final TextTheme text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        elevation: 0.5,
        shadowColor: Colors.black26,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: tokens.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusBadge(
                            isActive: item.isActive,
                            tokens: tokens,
                            text: text,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: меню правки / паузы
                      },
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_fmt(item.salaryFrom)} - ${_fmt(item.salaryTo)} тг',
                  style: text.titleSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined,
                        size: 18, color: tokens.mutedForeground),
                    const SizedBox(width: 4),
                    Text('${item.views}', style: text.bodySmall),
                    const SizedBox(width: 20),
                    Icon(Icons.people_outline_rounded,
                        size: 18, color: tokens.mutedForeground),
                    const SizedBox(width: 4),
                    Text(
                      '${item.applications} отклик${item.applications == 1 ? '' : (item.applications < 5 ? 'а' : 'ов')}',
                      style: text.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tokens.muted,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    item.tag,
                    style: text.bodySmall,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: отклики
                    },
                    child: Text(
                        'Смотреть отклики (${item.applications})'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        b.write(' ');
      }
      b.write(s[i]);
    }
    return b.toString();
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.isActive,
    required this.tokens,
    required this.text,
  });

  final bool isActive;
  final AppColors tokens;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    final label = isActive ? 'Активна' : 'На паузе';
    final bg = isActive
        ? tokens.success.withValues(alpha: 0.12)
        : const Color(0xFFFFF7ED);
    final fg = isActive
        ? tokens.success
        : const Color(0xFFEA580C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: text.bodySmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

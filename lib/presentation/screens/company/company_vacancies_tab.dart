import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/item.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/item/item_bloc.dart';

class CompanyVacanciesTab extends StatefulWidget {
  const CompanyVacanciesTab({super.key, required this.onOpenCandidates});

  final VoidCallback onOpenCandidates;

  @override
  State<CompanyVacanciesTab> createState() => _CompanyVacanciesTabState();
}

class _CompanyVacanciesTabState extends State<CompanyVacanciesTab> {
  final _searchController = TextEditingController();
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(const ItemLoaded());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _filtered(List<Item> source) {
    var list = source;
    if (_searchController.text.trim().isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      list = list.where((e) => e.title.toLowerCase().contains(q)).toList();
    }
    switch (_filterIndex) {
      case 1:
        return list.where((e) => e.status == ItemStatus.active).toList();
      case 2:
        return list.where((e) => e.status != ItemStatus.active).toList();
      default:
        return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    const brandRed = Color(0xFFDC2626);

    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        if (state is ItemLoading || state is ItemInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ItemFailure) {
          return Center(child: Text(l10n.errorWithMessage(state.message)));
        }

        final authState = context.read<AuthBloc>().state;
        final uid =
            authState is AuthAuthenticated ? (authState.user.authUid ?? '') : '';
        final items = state is ItemSuccess ? state.items : <Item>[];
        final companyItems = uid.isEmpty
            ? items
            : items.where((item) => item.ownerUid == uid).toList();
        final list = _filtered(companyItems);
        final activeCount =
            companyItems.where((e) => e.status == ItemStatus.active).length;

        final applicationsStream = uid.isEmpty
            ? const Stream<QuerySnapshot<Map<String, dynamic>>>.empty()
            : FirebaseFirestore.instance
                .collection('applications')
                .where('companyUid', isEqualTo: uid)
                .snapshots();

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: applicationsStream,
          builder: (context, applicationsSnapshot) {
            final countsByVacancy = <int, int>{};
            if (applicationsSnapshot.hasData) {
              for (final doc in applicationsSnapshot.data!.docs) {
                final vacancyId = (doc.data()['vacancyId'] as num?)?.toInt();
                if (vacancyId == null) continue;
                countsByVacancy[vacancyId] =
                    (countsByVacancy[vacancyId] ?? 0) + 1;
              }
            }

            return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  l10n.companyVacanciesActiveSummary(activeCount),
                  style: text.bodyMedium?.copyWith(
                    color: tokens.mutedForeground,
                  ),
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
                    hintText: l10n.companyVacanciesSearchHint,
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
                      label: l10n.homeFilterAll,
                      selected: _filterIndex == 0,
                      selectedColor: brandRed,
                      onTap: () => setState(() => _filterIndex = 0),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.companyVacancyFilterActive,
                      selected: _filterIndex == 1,
                      selectedColor: brandRed,
                      onTap: () => setState(() => _filterIndex = 1),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.companyVacancyFilterPaused,
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
                    l10n.companyVacanciesEmptyFilter,
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
                        applicationsCount:
                            countsByVacancy[v.id] ?? v.applicationsCount,
                        tokens: tokens,
                        text: text,
                        l10n: l10n,
                        accent: Theme.of(context).colorScheme.secondary,
                        onOpenCandidates: widget.onOpenCandidates,
                      );
                    },
                    childCount: list.length,
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
    required this.applicationsCount,
    required this.tokens,
    required this.text,
    required this.l10n,
    required this.accent,
    required this.onOpenCandidates,
  });

  final Item item;
  final int applicationsCount;
  final AppColors tokens;
  final TextTheme text;
  final AppLocalizations l10n;
  final Color accent;
  final VoidCallback onOpenCandidates;

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
                            isActive: item.status == ItemStatus.active,
                            tokens: tokens,
                            text: text,
                            l10n: l10n,
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
                  _salaryLabel(item, l10n),
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
                    Text('${item.viewsCount}', style: text.bodySmall),
                    const SizedBox(width: 20),
                    Icon(Icons.people_outline_rounded,
                        size: 18, color: tokens.mutedForeground),
                    const SizedBox(width: 4),
                    Text(
                      l10n.companyApplicationsShort(applicationsCount),
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
                    item.category.isEmpty
                        ? l10n.vacancyNoCategory
                        : item.category,
                    style: text.bodySmall,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onOpenCandidates,
                    child: Text(
                      l10n.companyVacanciesViewApplications(
                        applicationsCount,
                      ),
                    ),
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

  String _salaryLabel(Item item, AppLocalizations l10n) {
    final cur = l10n.homeCurrencyTenge;
    if (item.salaryFrom == null && item.salaryTo == null) {
      return l10n.homeSalaryNotSpecified;
    }
    final from = item.salaryFrom ?? item.salaryTo ?? 0;
    final to = item.salaryTo;
    if (to == null) {
      return l10n.homeSalaryFromFormatted(_fmt(from), cur);
    }
    return l10n.homeSalaryRangeFormatted(_fmt(from), _fmt(to), cur);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.isActive,
    required this.tokens,
    required this.text,
    required this.l10n,
  });

  final bool isActive;
  final AppColors tokens;
  final TextTheme text;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final label = isActive
        ? l10n.companyVacancyCardStatusActive
        : l10n.companyVacancyCardStatusPaused;
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

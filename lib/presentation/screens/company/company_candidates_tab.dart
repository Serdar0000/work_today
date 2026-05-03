import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/auth/auth_bloc.dart';

class CompanyCandidatesTab extends StatefulWidget {
  const CompanyCandidatesTab({super.key});

  @override
  State<CompanyCandidatesTab> createState() => _CompanyCandidatesTabState();
}

class _CompanyCandidatesTabState extends State<CompanyCandidatesTab> {
  final _searchController = TextEditingController();
  String? _statusFilter;

  static const List<String> _statuses = [
    'Новый',
    'На рассмотрении',
    'Собеседование',
    'Принят',
    'Отклонен',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilter() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.companyCandidatesAllStages),
                trailing:
                    _statusFilter == null ? const Icon(Icons.check, size: 20) : null,
                onTap: () {
                  setState(() => _statusFilter = null);
                  Navigator.pop(ctx);
                },
              ),
              ..._statuses.map((status) => ListTile(
                    title: Text(status),
                    trailing: _statusFilter == status
                        ? const Icon(Icons.check, size: 20)
                        : null,
                    onTap: () {
                      setState(() => _statusFilter = status);
                      Navigator.pop(ctx);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;
    final authState = context.watch<AuthBloc>().state;

    if (authState is! AuthAuthenticated ||
        authState.user.activeContext != UserRole.company ||
        (authState.user.authUid?.isEmpty ?? true)) {
      return Center(child: Text(l10n.companySectionCompanyOnly));
    }

    final uid = authState.user.authUid!;
    final stream = FirebaseFirestore.instance
        .collection('applications')
        .where('companyUid', isEqualTo: uid)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(l10n.errorWithMessage('${snapshot.error}')),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = snapshot.data!.docs.toList()
          ..sort((a, b) {
            final aTs = a.data()['updatedAt'] as Timestamp?;
            final bTs = b.data()['updatedAt'] as Timestamp?;
            final aDt = aTs?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDt = bTs?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDt.compareTo(aDt);
          });
        final list = all.where((doc) {
          final data = doc.data();
          final q = _searchController.text.trim().toLowerCase();
          final byQuery = q.isEmpty ||
              ((data['workerName'] as String? ?? '').toLowerCase().contains(q)) ||
              ((data['vacancyTitle'] as String? ?? '')
                  .toLowerCase()
                  .contains(q));
          final byStatus = _statusFilter == null || data['status'] == _statusFilter;
          return byQuery && byStatus;
        }).toList();

        final newCount =
            all.where((doc) => (doc.data()['status'] as String?) == 'Новый').length;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
              sliver: SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _openFilter,
                    icon: const Icon(Icons.filter_list_rounded, size: 20),
                    label: Text(l10n.companyFilter),
                    style: TextButton.styleFrom(foregroundColor: tokens.primary),
                  ),
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
                    hintText: l10n.companyCandidatesSearchHint,
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
                        label: l10n.companyCandidatesStatTotal,
                        value: '${all.length}',
                        valueColor: tokens.foreground,
                        tokens: tokens,
                        text: text,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: l10n.companyCandidatesStatNew,
                        value: '$newCount',
                        valueColor: const Color(0xFF2563EB),
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
                    l10n.companyCandidatesEmptyQuery,
                    style: text.bodyLarge?.copyWith(color: tokens.mutedForeground),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _CandidateCard(
                      docId: list[i].id,
                      data: list[i].data(),
                      tokens: tokens,
                      text: text,
                    ),
                    childCount: list.length,
                  ),
                ),
              ),
          ],
        );
      },
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
            Text(label,
                style: text.bodySmall?.copyWith(color: tokens.mutedForeground)),
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
    required this.docId,
    required this.data,
    required this.tokens,
    required this.text,
  });

  final String docId;
  final Map<String, dynamic> data;
  final AppColors tokens;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    final appliedAt = data['createdAt'];
    final applied = appliedAt is Timestamp ? appliedAt.toDate() : DateTime.now();
    final status = (data['status'] as String?) ?? 'Новый';
    final workerName = (data['workerName'] as String?) ?? 'Кандидат';
    final vacancyTitle = (data['vacancyTitle'] as String?) ?? 'Без вакансии';
    final city = (data['city'] as String?) ?? '';
    final quote = (data['note'] as String?) ?? '';
    final dateStr = DateFormat('d MMM', 'ru').format(applied);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: tokens.card,
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
                child: Icon(Icons.person_rounded, color: tokens.mutedForeground),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            workerName,
                            style: text.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        _StatusPill(status: status, text: text, tokens: tokens),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(vacancyTitle,
                        style: text.bodySmall
                            ?.copyWith(color: tokens.mutedForeground)),
                    const SizedBox(height: 4),
                    Text(
                      '$dateStr${city.isNotEmpty ? '  ·  $city' : ''}',
                      style: text.bodySmall?.copyWith(
                        color: tokens.mutedForeground,
                        fontSize: 12,
                      ),
                    ),
                    if (quote.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        '«$quote»',
                        style: text.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: tokens.foreground,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _StatusAction(
                          label: 'Резюме',
                          onTap: () => _openResume(context),
                        ),
                        _StatusAction(
                          label: 'На рассмотрении',
                          onTap: () => _updateStatus('На рассмотрении'),
                        ),
                        _StatusAction(
                          label: 'Собеседование',
                          onTap: () => _updateStatus('Собеседование'),
                        ),
                        _StatusAction(
                          label: 'Принят',
                          onTap: () => _updateStatus('Принят'),
                        ),
                        _StatusAction(
                          label: 'Отклонен',
                          onTap: () => _updateStatus('Отклонен'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateStatus(String status) {
    return FirebaseFirestore.instance.collection('applications').doc(docId).update({
      'status': status,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> _openResume(BuildContext context) async {
    final workerUid = (data['workerUid'] as String?) ?? '';
    if (workerUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).companyCandidateNoResume),
        ),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('resumes')
          .doc(workerUid)
          .get();
      final resume = doc.data();
      if (resume == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).companyResumeNotFound),
          ),
        );
        return;
      }

      if (!context.mounted) return;
      FirebaseFirestore.instance.collection('resumes').doc(workerUid).update({
        'viewsCount': FieldValue.increment(1),
      }).catchError((_) {});
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (ctx) => _ResumePreviewSheet(
          name: (resume['name'] as String?) ??
              AppLocalizations.of(ctx).resumePreviewNoName,
          title: (resume['title'] as String?) ??
              AppLocalizations.of(ctx).roleWorker,
          about: (resume['about'] as String?) ?? '',
          phone: (resume['phone'] as String?) ?? '',
          email: (resume['email'] as String?) ?? '',
          city: (resume['city'] as String?) ?? '',
          skills: (resume['skills'] as List<dynamic>? ?? const [])
              .map((e) => e.toString())
              .toList(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).companyOpenResumeError('$e'),
          ),
        ),
      );
    }
  }
}

class _StatusAction extends StatelessWidget {
  const _StatusAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      child: Text(label),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.status,
    required this.text,
    required this.tokens,
  });

  final String status;
  final TextTheme text;
  final AppColors tokens;

  (Color, Color) _colors() {
    return switch (status) {
      'Новый' => (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
      'На рассмотрении' => (const Color(0xFFFEF3C7), const Color(0xFFD97706)),
      'Собеседование' => (const Color(0xFFEDE9FE), const Color(0xFF6D28D9)),
      'Принят' => (tokens.success.withValues(alpha: 0.2), tokens.success),
      'Отклонен' => (
          tokens.destructive.withValues(alpha: 0.16),
          tokens.destructive,
        ),
      _ => (tokens.muted, tokens.foreground),
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
        status,
        style: text.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ResumePreviewSheet extends StatelessWidget {
  const _ResumePreviewSheet({
    required this.name,
    required this.title,
    required this.about,
    required this.phone,
    required this.email,
    required this.city,
    required this.skills,
  });

  final String name;
  final String title;
  final String about;
  final String phone;
  final String email;
  final String city;
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(name, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(title, style: text.bodyMedium),
            const SizedBox(height: 12),
            if (city.isNotEmpty)
              Text(l10n.resumeLineCity(city), style: text.bodyMedium),
            if (phone.isNotEmpty)
              Text(l10n.resumeLinePhone(phone), style: text.bodyMedium),
            if (email.isNotEmpty)
              Text(l10n.resumeLineEmail(email), style: text.bodyMedium),
            if (about.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.resumeSectionAbout, style: text.titleMedium),
              const SizedBox(height: 4),
              Text(about, style: text.bodyMedium),
            ],
            if (skills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.resumeSectionSkills, style: text.titleMedium),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: skills.map((s) => Chip(label: Text(s))).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

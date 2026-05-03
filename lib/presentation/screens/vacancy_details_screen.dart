import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/user.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/item/item_bloc.dart';

class VacancyDetailsScreen extends StatefulWidget {
  const VacancyDetailsScreen({super.key, required this.vacancyId});

  final int vacancyId;

  @override
  State<VacancyDetailsScreen> createState() => _VacancyDetailsScreenState();
}

class _VacancyDetailsScreenState extends State<VacancyDetailsScreen> {
  bool _viewCounted = false;

  String _formatNumber(int value) {
    final text = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemBloc = context.read<ItemBloc>();
    if (itemBloc.state is ItemInitial) {
      itemBloc.add(const ItemLoaded());
    }

    return AppSafeScaffold(
      appBar: AppBar(title: Text(l10n.vacancyDetailsTitle)),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading || state is ItemInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ItemFailure) {
            return Center(
              child: Text(l10n.errorWithMessage(state.message)),
            );
          }
          final items = state is ItemSuccess ? state.items : <Item>[];
          Item? vacancy;
          for (final item in items) {
            if (item.id == widget.vacancyId) {
              vacancy = item;
              break;
            }
          }
          if (vacancy == null) {
            return Center(child: Text(l10n.vacancyNotFound));
          }
          _countViewOnce(vacancy.id);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vacancy.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.apartment_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(vacancy.companyName.isEmpty
                              ? l10n.homeCompanyUnknown
                              : vacancy.companyName),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.payments_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _salaryLabel(vacancy, l10n),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.category_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(vacancy.category.isEmpty
                              ? l10n.vacancyNoCategory
                              : vacancy.category),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              vacancy.location.trim().isEmpty
                                  ? l10n.homeCityUnknown
                                  : vacancy.location.trim(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.vacancyDescriptionHeading,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                vacancy.description?.trim().isNotEmpty == true
                    ? vacancy.description!
                    : l10n.vacancyNoDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _apply(context, vacancy!),
                icon: const Icon(Icons.send_rounded),
                label: Text(l10n.vacancyApply),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.vacancyBack),
              ),
            ],
          );
        },
      ),
    );
  }

  String _salaryLabel(Item vacancy, AppLocalizations l10n) {
    final from = vacancy.salaryFrom;
    final to = vacancy.salaryTo;
    final cur = l10n.homeCurrencyTenge;
    if (from == null && to == null) {
      return l10n.homeSalaryNotSpecified;
    }
    if (from != null && to != null) {
      return l10n.homeSalaryRangeFormatted(
        _formatNumber(from),
        _formatNumber(to),
        cur,
      );
    }
    final v = from ?? to!;
    return l10n.homeSalaryFromFormatted(_formatNumber(v), cur);
  }

  Future<void> _apply(BuildContext context, Item vacancy) async {
    final l10n = AppLocalizations.of(context);
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vacancyNeedLogin)),
      );
      return;
    }
    final user = authState.user;
    if (user.activeContext != UserRole.worker) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vacancyWorkerOnly)),
      );
      return;
    }
    final uid = user.authUid;
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vacancyUidMissing)),
      );
      return;
    }

    final docId = '${vacancy.id}_$uid';
    final now = Timestamp.fromDate(DateTime.now());
    await FirebaseFirestore.instance.collection('applications').doc(docId).set({
      'workerUid': uid,
      'workerName': user.name,
      'companyUid': vacancy.ownerUid,
      'vacancyId': vacancy.id,
      'vacancyTitle': vacancy.title,
      'status': 'Новый',
      'note': '',
      'city': vacancy.location,
      'createdAt': now,
      'updatedAt': now,
    }, SetOptions(merge: true));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.vacancyApplySent)),
    );
    context.push(AppConstants.routeMyApplications);
  }

  void _countViewOnce(int vacancyId) {
    if (_viewCounted) return;
    _viewCounted = true;
    FirebaseFirestore.instance
        .collection('vacancies')
        .doc(vacancyId.toString())
        .update({'viewsCount': FieldValue.increment(1)}).catchError((_) {});
  }
}

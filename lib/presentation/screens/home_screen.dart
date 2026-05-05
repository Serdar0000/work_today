// Слой: presentation | Назначение: главный экран вакансий EasyShift

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/kazakhstan_major_cities.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/item.dart';
import '../blocs/item/item_bloc.dart';
import '../utils/auth_logout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  static const String _allCategoryValue = 'Все';

  String _selectedCategory = _allCategoryValue;
  String _selectedCity = kKazakhstanAllCitiesLabel;

  /// `date` — новые сверху; `city` — по алфавиту города, затем по дате.
  String _sortMode = 'date';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  /// true когда есть хотя бы один не-none канал (wifi/mobile/…).
  bool _hasNetwork = true;

  /// Пользователь закрыл баннер до появления сети.
  bool _offlineBannerDismissed = false;

  static const List<String> _categories = [
    _allCategoryValue,
    'Склад',
    'Курьер',
    'Касса',
    'Клининг',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(const ItemLoaded());
    // Плагин требует полной пересборки; до этого listen/check дают MissingPluginException.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadPreferredCityFilter();
      _initConnectivity();
      _subscribeConnectivitySafe();
    });
  }

  Future<void> _loadPreferredCityFilter() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.kPreferredCityKey)?.trim() ?? '';
    if (!mounted) return;
    if (raw.isEmpty || !kKazakhstanMajorCities.contains(raw)) return;
    setState(() => _selectedCity = raw);
  }

  void _subscribeConnectivitySafe() {
    if (_connectivitySub != null) return;
    try {
      _connectivitySub = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (_) {
          if (!mounted) return;
          setState(() => _hasNetwork = true);
        },
        cancelOnError: false,
      );
    } on MissingPluginException {
      _connectivitySub = null;
    } catch (_) {
      _connectivitySub = null;
    }
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _applyConnectivity(result);
    } on MissingPluginException {
      if (mounted) setState(() => _hasNetwork = true);
    } catch (_) {
      if (mounted) setState(() => _hasNetwork = true);
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    _applyConnectivity(result);
  }

  void _applyConnectivity(List<ConnectivityResult> result) {
    final online = result.any((r) => r != ConnectivityResult.none);
    if (!mounted) return;
    setState(() {
      _hasNetwork = online;
      if (online) {
        _offlineBannerDismissed = false;
      }
    });
  }

  bool get _showOfflineBanner => !_hasNetwork && !_offlineBannerDismissed;

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _filterVacancies(List<Item> source) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = source.where((vacancy) {
      final inCategory = _selectedCategory == _allCategoryValue ||
          vacancy.category == _selectedCategory;
      final inCity = kKazakhstanCityMatchesFilter(
        vacancy.location,
        _selectedCity,
      );
      final inSearch = query.isEmpty ||
          vacancy.title.toLowerCase().contains(query) ||
          vacancy.companyName.toLowerCase().contains(query) ||
          vacancy.location.toLowerCase().contains(query);
      return inCategory && inCity && inSearch;
    }).toList();

    if (_sortMode == 'city') {
      filtered.sort((a, b) {
        final la = a.location.trim().toLowerCase();
        final lb = b.location.trim().toLowerCase();
        final byCity = la.compareTo(lb);
        if (byCity != 0) return byCity;
        return b.createdAt.compareTo(a.createdAt);
      });
    } else {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return filtered;
  }

  String _categoryChipLabel(BuildContext context, String code) {
    if (code == _allCategoryValue) {
      return AppLocalizations.of(context).homeFilterAll;
    }
    return code;
  }

  Future<void> _onRefresh() async {
    context.read<ItemBloc>().add(const ItemLoaded());
    // Даём время на загрузку
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final tokens = context.appColors;
    final text = Theme.of(context).textTheme;

    return AppSafeScaffold(
      backgroundColor: tokens.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.appName,
                      style: text.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: _hasNetwork
                        ? l10n.homeOnlineTooltip
                        : l10n.homeOfflineTooltip,
                    child: Icon(
                      _hasNetwork ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                      color: _hasNetwork ? colors.primary : colors.error,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    tooltip: l10n.homeAccountTooltip,
                    child: const Icon(Icons.account_circle_outlined),
                    onSelected: (value) {
                      if (value == 'profile') {
                        context.push(AppConstants.routeProfile);
                      } else if (value == 'logout') {
                        showConfirmLogout(context);
                      }
                    },
                    itemBuilder: (menuCtx) {
                      final menuL10n = AppLocalizations.of(menuCtx);
                      return [
                        PopupMenuItem(
                          value: 'profile',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.person_outline),
                            title: Text(menuL10n.bottomNavProfile),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.logout_rounded),
                            title: Text(menuL10n.authLogoutConfirm),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
            if (_showOfflineBanner)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: tokens.muted,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off_rounded,
                          color: colors.onSurfaceVariant),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.homeOfflineBanner,
                          style: text.bodyLarge,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(
                          () => _offlineBannerDismissed = true,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: Container(
                decoration: BoxDecoration(
                  color: tokens.muted,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.homeSearchHint,
                    hintStyle: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: AppTypography.body,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
              child: Row(
                children: [
                  Text(
                    l10n.homeSortLabel,
                    style: text.labelLarge?.copyWith(
                      color: tokens.mutedForeground,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: [
                        ButtonSegment<String>(
                          value: 'date',
                          label: Text(l10n.homeSortByDate),
                          icon: const Icon(Icons.schedule_rounded, size: 18),
                        ),
                        ButtonSegment<String>(
                          value: 'city',
                          label: Text(l10n.homeSortByCity),
                          icon:
                              const Icon(Icons.location_city_rounded, size: 18),
                        ),
                      ],
                      selected: {_sortMode},
                      onSelectionChanged: (Set<String> next) {
                        if (next.isEmpty) return;
                        setState(() => _sortMode = next.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _selectedCategory = category),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? colors.primary : tokens.background,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isSelected ? colors.primary : tokens.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (isSelected) ...[
                              Icon(Icons.check, size: 18, color: tokens.card),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              _categoryChipLabel(context, category),
                              style: TextStyle(
                                color:
                                    isSelected ? tokens.card : colors.onSurface,
                                fontSize: AppTypography.bodySmall,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.homeCityHeader,
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: tokens.mutedForeground,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: kKazakhstanCityFilterChips.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final city = kKazakhstanCityFilterChips[index];
                  final isSelected = _selectedCity == city;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _selectedCity = city),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? colors.primary : tokens.background,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isSelected ? colors.primary : tokens.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (isSelected) ...[
                              Icon(Icons.check, size: 18, color: tokens.card),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              city,
                              style: TextStyle(
                                color:
                                    isSelected ? tokens.card : colors.onSurface,
                                fontSize: AppTypography.bodySmall,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  if (state is ItemLoading || state is ItemInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ItemFailure) {
                    return Center(
                      child: Text(
                        l10n.homeVacanciesError(state.message),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  final source = state is ItemSuccess ? state.items : <Item>[];
                  final vacancies = _filterVacancies(source);
                  if (vacancies.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.homeVacanciesNotFound,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                    itemCount: vacancies.length,
                    itemBuilder: (context, index) {
                      final vacancy = vacancies[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: tokens.card,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: [
                            BoxShadow(
                              color: tokens.foreground.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 14, 12, 12),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  vacancy.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppTypography.cardTitle,
                                  ),
                                ),
                              ),
                              if (vacancy.isHot)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tokens.destructive
                                        .withValues(alpha: 0.12),
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.pill),
                                  ),
                                  child: Text(
                                    l10n.homeHotVacancy,
                                    style: TextStyle(
                                      color: tokens.destructive,
                                      fontSize: AppTypography.caption,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.business_outlined,
                                      size: 18,
                                      color: colors.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      vacancy.companyName.isEmpty
                                          ? l10n.homeCompanyUnknown
                                          : vacancy.companyName,
                                      style: TextStyle(
                                        fontSize: AppTypography.cardTitle,
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet_outlined,
                                      size: 18,
                                      color: colors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _salaryLabel(vacancy, l10n),
                                      style: TextStyle(
                                        color: colors.primary,
                                        fontSize: AppTypography.sectionTitle,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                      color: colors.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        vacancy.location.trim().isEmpty
                                            ? l10n.homeCityUnknown
                                            : vacancy.location.trim(),
                                        style: TextStyle(
                                          fontSize: AppTypography.bodySmall,
                                          color: colors.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule_outlined,
                                      size: 18,
                                      color: colors.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      vacancy.schedule.isEmpty
                                          ? l10n.homeScheduleUnknown
                                          : vacancy.schedule,
                                      style: TextStyle(
                                        fontSize: AppTypography.bodySmall,
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            size: 28,
                            color: colors.onSurfaceVariant,
                          ),
                          onTap: () => context.push(
                            AppConstants.routeVacancyDetails,
                            extra: vacancy.id,
                          ),
                        ),
                      );
                    },
                  );
                },
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
              label: l10n.bottomNavVacancies,
              selected: true,
              onTap: () {},
            ),
            _BottomNavItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description_rounded,
              label: l10n.bottomNavApplications,
              selected: false,
              onTap: () => context.go(AppConstants.routeMyApplications),
            ),
            _BottomNavItem(
              icon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart_rounded,
              label: l10n.bottomNavStats,
              selected: false,
              onTap: () => context.go(AppConstants.routeStatistics),
            ),
            _BottomNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: l10n.bottomNavProfile,
              selected: false,
              onTap: () => context.go(AppConstants.routeProfile),
            ),
          ],
        ),
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
    final value = from ?? to!;
    return l10n.homeSalaryFromFormatted(_formatNumber(value), cur);
  }

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
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? colors.primary.withValues(alpha: 0.12)
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

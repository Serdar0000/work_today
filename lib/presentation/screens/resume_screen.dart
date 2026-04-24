// Слой: presentation | Назначение: редактирование резюме (Firestore или локальный fallback)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/resume.dart';
import '../blocs/resume/resume_bloc.dart';

const _languageLevels = [
  'Родной',
  'Свободно',
  'Средний',
  'Базовый',
];

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  final _headlineCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();

  final List<String> _skills = [];
  final List<WorkExperienceItem> _workItems = [];
  final List<LanguageItem> _langItems = [];

  bool _isPublic = true;
  bool _hydratedFromBloc = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    _birthDateCtrl.dispose();
    _headlineCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  void _applyResumeToFields(Resume r) {
    _fullNameCtrl.text = r.fullName;
    _phoneCtrl.text = r.phone;
    _emailCtrl.text = r.email;
    _cityCtrl.text = r.city;
    _birthDateCtrl.text = r.birthDate;
    _headlineCtrl.text = r.headline;
    _aboutCtrl.text = r.about;
    _isPublic = r.isPublic;
    _skills
      ..clear()
      ..addAll(r.skills);
    _workItems
      ..clear()
      ..addAll(r.workExperience);
    _langItems
      ..clear()
      ..addAll(r.languages);
  }

  Resume _buildResumeFromFields() {
    return Resume(
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      birthDate: _birthDateCtrl.text.trim(),
      headline: _headlineCtrl.text.trim().isEmpty
          ? 'Соискатель'
          : _headlineCtrl.text.trim(),
      about: _aboutCtrl.text.trim(),
      skills: List<String>.from(_skills),
      workExperience: List<WorkExperienceItem>.from(_workItems),
      languages: List<LanguageItem>.from(_langItems),
      isPublic: _isPublic,
    );
  }

  Future<void> _promptSkill() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Навык'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Например: Курьер'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Добавить')),
        ],
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty) {
      setState(() => _skills.add(ctrl.text.trim()));
    }
  }

  Future<void> _editWork({WorkExperienceItem? item, int? index}) async {
    final titleC = TextEditingController(text: item?.title ?? '');
    final companyC = TextEditingController(text: item?.company ?? '');
    final startC = TextEditingController(text: item?.periodStartText ?? '');
    final endC = TextEditingController(text: item?.periodEndText ?? '');
    final descC = TextEditingController(text: item?.description ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item == null ? 'Опыт работы' : 'Редактировать опыт'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleC,
                decoration: const InputDecoration(labelText: 'Должность'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: companyC,
                decoration: const InputDecoration(labelText: 'Компания'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: startC,
                decoration: const InputDecoration(
                  labelText: 'Период с',
                  hintText: 'Март 2025',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: endC,
                decoration: const InputDecoration(
                  labelText: 'Период по (пусто — по наст. время)',
                  hintText: 'Оставьте пустым',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descC,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Сохранить')),
        ],
      ),
    );

    if (ok != true) return;
    final id = item?.id ?? '${DateTime.now().microsecondsSinceEpoch}';
    final next = WorkExperienceItem(
      id: id,
      title: titleC.text.trim(),
      company: companyC.text.trim(),
      periodStartText: startC.text.trim(),
      periodEndText: endC.text.trim(),
      description: descC.text.trim(),
    );
    setState(() {
      if (index != null) {
        _workItems[index] = next;
      } else {
        _workItems.add(next);
      }
    });
  }

  Future<void> _editLanguage({LanguageItem? item, int? index}) async {
    final nameC = TextEditingController(text: item?.name ?? '');
    var level = item?.level ?? _languageLevels.first;
    if (!_languageLevels.contains(level)) {
      level = _languageLevels.first;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: Text(item == null ? 'Язык' : 'Редактировать язык'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: 'Язык'),
              ),
              const SizedBox(height: 8),
              Text(
                'Уровень',
                style: Theme.of(ctx).textTheme.labelLarge,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _languageLevels.map((lvl) {
                  return ChoiceChip(
                    label: Text(lvl),
                    selected: level == lvl,
                    onSelected: (_) => setModal(() => level = lvl),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Сохранить')),
          ],
        ),
      ),
    );

    if (ok != true || nameC.text.trim().isEmpty) return;
    final id = item?.id ?? '${DateTime.now().microsecondsSinceEpoch}';
    final next = LanguageItem(id: id, name: nameC.text.trim(), level: level);
    setState(() {
      if (index != null) {
        _langItems[index] = next;
      } else {
        _langItems.add(next);
      }
    });
  }

  String _periodLine(WorkExperienceItem e) {
    final end = e.periodEndText.trim().isEmpty ? 'Настоящее время' : e.periodEndText.trim();
    return '${e.periodStartText.trim()} — $end';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return BlocConsumer<ResumeBloc, ResumeState>(
      listenWhen: (prev, curr) {
        if (curr.successSaved != prev.successSaved) return true;
        if (curr.errorMessage != prev.errorMessage) return true;
        if (!_hydratedFromBloc && curr.status == ResumeViewStatus.ready) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.successSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Резюме сохранено')),
          );
          context.read<ResumeBloc>().add(const ResumeToastConsumed());
        }
        if (state.errorMessage != null &&
            state.errorMessage!.isNotEmpty &&
            state.status == ResumeViewStatus.ready) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.status == ResumeViewStatus.ready && !_hydratedFromBloc) {
          _hydratedFromBloc = true;
          _applyResumeToFields(state.resume);
          setState(() {});
        }
      },
      builder: (context, state) {
        final saving = state.status == ResumeViewStatus.saving;
        final loading = state.status == ResumeViewStatus.loading;

        return Scaffold(
          backgroundColor: tokens.background,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: tokens.border)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      ),
                      Expanded(
                        child: Text(
                          'Моё резюме',
                          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: saving || loading
                            ? null
                            : () {
                                context.read<ResumeBloc>().add(
                                      ResumeSaveRequested(_buildResumeFromFields()),
                                    );
                              },
                        icon: saving
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.primary,
                                ),
                              )
                            : const Icon(Icons.save_outlined, size: 20),
                        label: Text(saving ? 'Сохранение…' : 'Сохранить'),
                      ),
                    ],
                  ),
                ),
                if (state.status == ResumeViewStatus.loading)
                  const LinearProgressIndicator(minHeight: 2),
                if (state.status == ResumeViewStatus.failure)
                  MaterialBanner(
                    content: Text(
                      state.errorMessage ?? 'Не удалось загрузить резюме',
                    ),
                    leading: const Icon(Icons.error_outline),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() => _hydratedFromBloc = false);
                          context.read<ResumeBloc>().add(const ResumeLoadRequested());
                        },
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
                    children: [
                      _SectionCard(
                        title: 'Личные данные',
                        icon: Icons.person_outline_rounded,
                        child: Column(
                          children: [
                            _LabeledField(
                              icon: Icons.person_outline_rounded,
                              label: 'ФИО',
                              controller: _fullNameCtrl,
                            ),
                            _LabeledField(
                              icon: Icons.phone_rounded,
                              label: 'Телефон',
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                            ),
                            _LabeledField(
                              icon: Icons.mail_outline_rounded,
                              label: 'Email',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            _LabeledField(
                              icon: Icons.location_on_outlined,
                              label: 'Город',
                              controller: _cityCtrl,
                            ),
                            _LabeledField(
                              icon: Icons.calendar_month_outlined,
                              label: 'Дата рождения',
                              controller: _birthDateCtrl,
                              hint: '15.05.1998',
                            ),
                            _LabeledField(
                              icon: Icons.work_outline_rounded,
                              label: 'Желаемая позиция',
                              controller: _headlineCtrl,
                              hint: 'Соискатель',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SectionCard(
                        title: 'О себе',
                        icon: Icons.info_outline_rounded,
                        child: TextFormField(
                          controller: _aboutCtrl,
                          minLines: 4,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            hintText: 'Расскажите о себе…',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SectionCard(
                        title: 'Навыки',
                        icon: Icons.psychology_alt_outlined,
                        headerAction: TextButton.icon(
                          onPressed: _promptSkill,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Добавить'),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _skills.map((skill) {
                            return InputChip(
                              label: Text(skill),
                              onDeleted: () =>
                                  setState(() => _skills.remove(skill)),
                              deleteIcon:
                                  Icon(Icons.close, size: 16, color: colors.error),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SectionCard(
                        title: 'Опыт работы',
                        icon: Icons.work_outline_rounded,
                        headerAction: TextButton.icon(
                          onPressed: () => _editWork(),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Добавить'),
                        ),
                        child: Column(
                          children: List.generate(_workItems.length, (index) {
                            final exp = _workItems[index];
                            final isLast = index == _workItems.length - 1;
                            return Container(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                              margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
                              decoration: BoxDecoration(
                                border: isLast
                                    ? null
                                    : Border(bottom: BorderSide(color: tokens.border)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exp.title,
                                          style: text.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: tokens.foreground,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          exp.company,
                                          style: text.bodySmall?.copyWith(
                                            color: colors.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _periodLine(exp),
                                          style: text.bodySmall?.copyWith(
                                            color: tokens.mutedForeground,
                                            fontSize: AppTypography.caption,
                                          ),
                                        ),
                                        if (exp.description.trim().isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            exp.description,
                                            style: text.bodySmall?.copyWith(
                                              color: tokens.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Изменить',
                                    icon: Icon(Icons.edit_outlined, color: tokens.mutedForeground),
                                    onPressed: () => _editWork(item: exp, index: index),
                                  ),
                                  IconButton(
                                    tooltip: 'Удалить',
                                    icon: Icon(Icons.delete_outline, color: colors.error),
                                    onPressed: () => setState(() => _workItems.removeAt(index)),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SectionCard(
                        title: 'Языки',
                        icon: Icons.translate_rounded,
                        headerAction: TextButton.icon(
                          onPressed: () => _editLanguage(),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Добавить'),
                        ),
                        child: Column(
                          children: List.generate(_langItems.length, (index) {
                            final lang = _langItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      lang.name,
                                      style: text.bodyMedium?.copyWith(
                                        color: tokens.foreground,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: tokens.muted,
                                      borderRadius: BorderRadius.circular(AppRadius.pill),
                                    ),
                                    child: Text(
                                      lang.level,
                                      style: text.bodySmall?.copyWith(
                                        fontSize: AppTypography.caption,
                                        color: tokens.foreground,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined, size: 20, color: tokens.mutedForeground),
                                    onPressed: () => _editLanguage(item: lang, index: index),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, size: 20, color: colors.error),
                                    onPressed: () => setState(() => _langItems.removeAt(index)),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SectionCard(
                        title: 'Видимость',
                        icon: Icons.visibility_outlined,
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Показывать резюме компаниям'),
                          subtitle: const Text(
                            'Если выключено, кабинет компании не увидит ваше резюме в общей ленте.',
                          ),
                          value: _isPublic,
                          onChanged: (v) => setState(() => _isPublic = v),
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
                  selected: false,
                  onTap: () => context.go(AppConstants.routeStatistics),
                ),
                _BottomNavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Профиль',
                  selected: true,
                  onTap: () => context.go(AppConstants.routeProfile),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.hint,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: tokens.muted,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: colors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: tokens.mutedForeground,
                    fontSize: AppTypography.caption,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hint,
                    isDense: true,
                  ),
                  style: text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: tokens.foreground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.headerAction,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? headerAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: tokens.foreground.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (headerAction != null) headerAction!,
            ],
          ),
          const SizedBox(height: 10),
          child,
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

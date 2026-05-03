import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/kazakhstan_major_cities.dart';
import '../../../core/widgets/app_safe_scaffold.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/item/item_bloc.dart';

class CreateVacancyScreen extends StatefulWidget {
  const CreateVacancyScreen({super.key});

  @override
  State<CreateVacancyScreen> createState() => _CreateVacancyScreenState();
}

class _CreateVacancyScreenState extends State<CreateVacancyScreen> {
  final _titleController = TextEditingController();
  final _salaryFromController = TextEditingController();
  final _salaryToController = TextEditingController();
  final _scheduleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = const [
    'Курьер',
    'Склад',
    'Касса',
    'Клининг',
    'Охрана',
    'Промоутер',
    'Официант',
    'Водитель',
  ];

  String? _selectedCategory;
  String? _selectedCity;
  int _selectedSlots = 1;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _salaryFromController.dispose();
    _salaryToController.dispose();
    _scheduleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppSafeScaffold(
      appBar: AppBar(title: Text(l10n.createVacancyTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _StepProgress(),
          const SizedBox(height: 18),
          Text(
            l10n.createVacancyStepIntro,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.createVacancyTitleLabel,
              hintText: l10n.createVacancyTitleHint,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.createVacancyCategory,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              final selected = _selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: selected,
                onSelected: (_) => setState(() => _selectedCategory = category),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.createVacancyOpenings,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [1, 2, 3, 5, 10].map((slots) {
              final selected = _selectedSlots == slots;
              return ChoiceChip(
                label: Text(slots == 10 ? '10+' : '$slots'),
                selected: selected,
                onSelected: (_) => setState(() => _selectedSlots = slots),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _salaryFromController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.createVacancySalaryFromLabel,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _salaryToController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.createVacancySalaryToLabel,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _scheduleController,
            decoration: InputDecoration(
              labelText: l10n.createVacancyScheduleLabel,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.createVacancyCitySectionTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            decoration: InputDecoration(
              labelText: l10n.createVacancyCityFieldLabel,
              hintText: l10n.createVacancyCityHint,
            ),
            items: kKazakhstanMajorCities
                .map(
                  (c) => DropdownMenuItem<String>(
                    value: c,
                    child: Text(c),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _selectedCity = v),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: l10n.createVacancyDescriptionLabel,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: Text(
              _isSubmitting
                  ? l10n.createVacancySubmitting
                  : l10n.createVacancySubmitButton,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty ||
        _selectedCategory == null ||
        _selectedCity == null ||
        _selectedCity!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.createVacancyFillRequired),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final authState = context.read<AuthBloc>().state;
    final companyName = authState is AuthAuthenticated
        ? authState.user.name
        : l10n.companyDefaultName;
    final salaryFrom = int.tryParse(_salaryFromController.text.trim());
    final salaryTo = int.tryParse(_salaryToController.text.trim());
    final schedule = _scheduleController.text.trim();
    final location = _selectedCity!.trim();
    final description = _descriptionController.text.trim();
    final slotsStr = _selectedSlots == 10 ? '10+' : '$_selectedSlots';
    final openingsLine = l10n.createVacancyOpeningsSuffix(slotsStr);

    context.read<ItemBloc>().add(
          ItemCreated(
            title: title,
            description: description.isEmpty
                ? openingsLine
                : '$description\n$openingsLine',
            category: _selectedCategory,
            salaryFrom: salaryFrom,
            salaryTo: salaryTo,
            schedule: schedule,
            location: location,
            companyName: companyName,
            isHot: false,
          ),
        );

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.createVacancySubmitted)),
    );
  }
}

class _StepProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      children: List.generate(
        4,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == 3 ? 0 : 8),
            height: 4,
            decoration: BoxDecoration(
              color: index == 0 ? color : color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      ),
    );
  }
}

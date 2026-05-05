import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/kazakhstan_major_cities.dart';
import '../../../core/widgets/app_safe_scaffold.dart';
import '../../../domain/entities/item.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/item/item_bloc.dart';

class EditVacancyScreen extends StatefulWidget {
  const EditVacancyScreen({
    super.key,
    required this.vacancy,
  });

  final Item vacancy;

  @override
  State<EditVacancyScreen> createState() => _EditVacancyScreenState();
}

class _EditVacancyScreenState extends State<EditVacancyScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _salaryFromController;
  late final TextEditingController _salaryToController;
  late final TextEditingController _scheduleController;
  late final TextEditingController _descriptionController;

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

  late String? _selectedCategory;
  late String? _selectedCity;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.vacancy.title);
    _salaryFromController = TextEditingController(
      text: widget.vacancy.salaryFrom?.toString() ?? '',
    );
    _salaryToController = TextEditingController(
      text: widget.vacancy.salaryTo?.toString() ?? '',
    );
    _scheduleController = TextEditingController(
      text: widget.vacancy.schedule,
    );
    _descriptionController = TextEditingController(
      text: widget.vacancy.description ?? '',
    );
    _selectedCategory = widget.vacancy.category.isEmpty
        ? null
        : widget.vacancy.category;
    _selectedCity = widget.vacancy.location;
  }

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
      appBar: AppBar(title: Text(l10n.vacancyEditTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
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
                  : l10n.commonSave,
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

    final salaryFrom = int.tryParse(_salaryFromController.text.trim());
    final salaryTo = int.tryParse(_salaryToController.text.trim());
    final schedule = _scheduleController.text.trim();
    final location = _selectedCity!.trim();
    final description = _descriptionController.text.trim();

    final updatedVacancy = widget.vacancy.copyWith(
      title: title,
      description: description,
      category: _selectedCategory ?? '',
      salaryFrom: salaryFrom,
      salaryTo: salaryTo,
      schedule: schedule,
      location: location,
    );

    context.read<ItemBloc>().add(ItemUpdated(updatedVacancy));

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.vacancyUpdatedSuccess)),
    );
  }
}

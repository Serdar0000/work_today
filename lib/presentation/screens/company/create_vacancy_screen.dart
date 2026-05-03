import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/kazakhstan_major_cities.dart';
import '../../../core/widgets/app_safe_scaffold.dart';
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
    return AppSafeScaffold(
      appBar: AppBar(title: const Text('Новая вакансия')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _StepProgress(),
          const SizedBox(height: 18),
          const Text(
            'Укажите название и категорию вакансии',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Название вакансии',
              hintText: 'Например: Курьер на вечерние смены',
            ),
          ),
          const SizedBox(height: 16),
          const Text('Категория',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
          const Text('Количество мест',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
            decoration: const InputDecoration(labelText: 'Зарплата от (тг)'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _salaryToController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Зарплата до (тг)'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _scheduleController,
            decoration: const InputDecoration(labelText: 'График'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Город',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            decoration: const InputDecoration(
              labelText: 'Город вакансии',
              hintText: 'Выберите город',
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
            decoration: const InputDecoration(labelText: 'Описание'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: Text(_isSubmitting ? 'Сохранение...' : 'Создать вакансию'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty ||
        _selectedCategory == null ||
        _selectedCity == null ||
        _selectedCity!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните название, категорию и город'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final authState = context.read<AuthBloc>().state;
    final companyName =
        authState is AuthAuthenticated ? authState.user.name : 'Компания';
    final salaryFrom = int.tryParse(_salaryFromController.text.trim());
    final salaryTo = int.tryParse(_salaryToController.text.trim());
    final schedule = _scheduleController.text.trim();
    final location = _selectedCity!.trim();
    final description = _descriptionController.text.trim();

    context.read<ItemBloc>().add(
          ItemCreated(
            title: title,
            description: description.isEmpty
                ? 'Количество мест: ${_selectedSlots == 10 ? '10+' : _selectedSlots}'
                : '$description\nКоличество мест: ${_selectedSlots == 10 ? '10+' : _selectedSlots}',
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
      const SnackBar(content: Text('Вакансия отправлена на публикацию')),
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

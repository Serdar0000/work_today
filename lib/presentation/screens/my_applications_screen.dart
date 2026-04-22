import 'package:flutter/material.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  final List<Map<String, dynamic>> _applications = [
    {
      'vacancyId': 'vac-001',
      'title': 'Сборщик заказов',
      'status': 'Новый',
      'note': 'Могу выходить в ночные смены',
      'timestamp': '2026-04-21 18:30',
    },
    {
      'vacancyId': 'vac-002',
      'title': 'Курьер на вечерние смены',
      'status': 'В работе',
      'note': 'Есть личный велосипед',
      'timestamp': '2026-04-22 10:15',
    },
  ];

  static const List<String> _statuses = [
    'Новый',
    'В работе',
    'Принят',
    'Отклонен',
  ];

  Future<void> _editApplication(int index) async {
    final app = _applications[index];
    final noteController = TextEditingController(text: app['note'] as String);
    String selectedStatus = app['status'] as String;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) => AlertDialog(
            title: const Text('Редактировать отклик'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Статус'),
                  items: _statuses
                      .map(
                        (status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setModalState(() => selectedStatus = value);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Заметка',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _applications[index] = {
                      ...app,
                      'status': selectedStatus,
                      'note': noteController.text.trim(),
                    };
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        );
      },
    );

    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои отклики')),
      body: _applications.isEmpty
          ? Center(
              child: Text(
                'Пока нет откликов',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _applications.length,
              itemBuilder: (context, index) {
                final app = _applications[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(app['title'] as String),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Статус: ${app['status']}'),
                          const SizedBox(height: 2),
                          Text('Заметка: ${app['note']}'),
                          const SizedBox(height: 2),
                          Text(
                            'Обновлено: ${app['timestamp']}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editApplication(index);
                          return;
                        }

                        if (value == 'delete') {
                          setState(() => _applications.removeAt(index));
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Изменить'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Удалить'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

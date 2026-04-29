// Слой: domain | Назначение: чистая сущность элемента списка (без Flutter-зависимостей)

import 'package:equatable/equatable.dart';

enum ItemStatus { active, archived }

class Item extends Equatable {
  const Item({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.ownerUid = '',
    this.companyName = '',
    this.salaryFrom,
    this.salaryTo,
    this.category = '',
    this.schedule = '',
    this.location = '',
    this.isHot = false,
    this.viewsCount = 0,
    this.applicationsCount = 0,
  });

  final int id;
  final String title;
  final String? description;
  final ItemStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String ownerUid;
  final String companyName;
  final int? salaryFrom;
  final int? salaryTo;
  final String category;
  final String schedule;
  final String location;
  final bool isHot;
  final int viewsCount;
  final int applicationsCount;

  Item copyWith({
    int? id,
    String? title,
    String? description,
    ItemStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerUid,
    String? companyName,
    int? salaryFrom,
    int? salaryTo,
    String? category,
    String? schedule,
    String? location,
    bool? isHot,
    int? viewsCount,
    int? applicationsCount,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerUid: ownerUid ?? this.ownerUid,
      companyName: companyName ?? this.companyName,
      salaryFrom: salaryFrom ?? this.salaryFrom,
      salaryTo: salaryTo ?? this.salaryTo,
      category: category ?? this.category,
      schedule: schedule ?? this.schedule,
      location: location ?? this.location,
      isHot: isHot ?? this.isHot,
      viewsCount: viewsCount ?? this.viewsCount,
      applicationsCount: applicationsCount ?? this.applicationsCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        createdAt,
        updatedAt,
        ownerUid,
        companyName,
        salaryFrom,
        salaryTo,
        category,
        schedule,
        location,
        isHot,
        viewsCount,
        applicationsCount,
      ];
}

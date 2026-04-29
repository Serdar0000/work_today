// Слой: domain | Назначение: use case создания нового элемента

import 'package:equatable/equatable.dart';
import '../entities/item.dart';
import '../repositories/item_repository.dart';
import 'base_usecase.dart';

class CreateItemUseCase implements UseCase<Item, CreateItemParams> {
  CreateItemUseCase(this._repository);

  final ItemRepository _repository;

  @override
  Future<Item> call(CreateItemParams params) {
    return _repository.create(
      title: params.title,
      description: params.description,
      companyName: params.companyName,
      salaryFrom: params.salaryFrom,
      salaryTo: params.salaryTo,
      category: params.category,
      schedule: params.schedule,
      location: params.location,
      isHot: params.isHot,
    );
  }
}

class CreateItemParams extends Equatable {
  const CreateItemParams({
    required this.title,
    this.description,
    this.companyName,
    this.salaryFrom,
    this.salaryTo,
    this.category,
    this.schedule,
    this.location,
    this.isHot,
  });

  final String title;
  final String? description;
  final String? companyName;
  final int? salaryFrom;
  final int? salaryTo;
  final String? category;
  final String? schedule;
  final String? location;
  final bool? isHot;

  @override
  List<Object?> get props => [
        title,
        description,
        companyName,
        salaryFrom,
        salaryTo,
        category,
        schedule,
        location,
        isHot,
      ];
}

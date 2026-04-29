import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/item_remote_datasource.dart';

class ItemRepositoryRemoteImpl implements ItemRepository {
  ItemRepositoryRemoteImpl(this._remoteDatasource);

  final ItemRemoteDatasource _remoteDatasource;

  @override
  Future<List<Item>> getAll() => _remoteDatasource.getAll();

  @override
  Future<Item?> getById(int id) => _remoteDatasource.getById(id);

  @override
  Future<Item> create({
    required String title,
    String? description,
    String? companyName,
    int? salaryFrom,
    int? salaryTo,
    String? category,
    String? schedule,
    String? location,
    bool? isHot,
  }) {
    return _remoteDatasource.create(
      title: title,
      description: description,
      companyName: companyName,
      salaryFrom: salaryFrom,
      salaryTo: salaryTo,
      category: category,
      schedule: schedule,
      location: location,
      isHot: isHot,
    );
  }

  @override
  Future<Item> update(Item item) => _remoteDatasource.update(item);

  @override
  Future<void> delete(int id) => _remoteDatasource.delete(id);

  @override
  Future<List<Item>> search(String query) => _remoteDatasource.search(query);

  @override
  Future<List<Item>> filterByStatus(ItemStatus status) {
    return _remoteDatasource.filterByStatus(status);
  }
}

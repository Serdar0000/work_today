import '../../domain/entities/item.dart' as item_entity;
import '../../domain/entities/user.dart' as user_entity;
import '../datasources/app_database.dart' as db;

extension UserDataMapper on db.User {
  user_entity.User toEntity() => user_entity.User(
        id: id,
        authUid: null,
        email: email,
        name: name,
        role: _mapRole(role),
        createdAt: createdAt,
      );
}

extension ItemDataMapper on db.Item {
  item_entity.Item toEntity() => item_entity.Item(
        id: id,
        title: title,
        description: description,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

user_entity.UserRole _mapRole(String value) {
  switch (value) {
    case 'company':
      return user_entity.UserRole.company;
    case 'worker':
    default:
      return user_entity.UserRole.worker;
  }
}

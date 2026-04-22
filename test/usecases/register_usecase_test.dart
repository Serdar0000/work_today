// Тесты: RegisterUseCase — успешная регистрация и дублирующийся email

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template/domain/entities/user.dart';
import 'package:template/domain/repositories/auth_repository.dart';
import 'package:template/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late RegisterUseCase registerUseCase;

  final testUser = User(
    id: 2,
    email: 'new@example.com',
    name: 'Новый Пользователь',
    role: UserRole.worker,
    createdAt: DateTime(2024),
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    test('успешная регистрация возвращает нового User', () async {
      when(
        () => mockRepository.register(
          name: 'Новый Пользователь',
          email: 'new@example.com',
          password: 'securepass',
          role: UserRole.worker,
        ),
      ).thenAnswer((_) async => testUser);

      final result = await registerUseCase(
        const RegisterParams(
          name: 'Новый Пользователь',
          email: 'new@example.com',
          password: 'securepass',
          role: UserRole.worker,
        ),
      );

      expect(result, equals(testUser));
      expect(result.email, equals('new@example.com'));
    });

    test('выбрасывает исключение при дублирующемся email', () async {
      when(
        () => mockRepository.register(
          name: any(named: 'name'),
          email: 'existing@example.com',
          password: any(named: 'password'),
          role: UserRole.worker,
        ),
      ).thenThrow(
        Exception('Пользователь с email existing@example.com уже существует'),
      );

      expect(
        () => registerUseCase(
          const RegisterParams(
            name: 'Кто-то',
            email: 'existing@example.com',
            password: 'pass123',
            role: UserRole.worker,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}

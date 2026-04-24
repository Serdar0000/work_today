import '../../core/debug/debug_auth_config.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryRemoteImpl implements AuthRepository {
  AuthRepositoryRemoteImpl(this._remoteDatasource);

  final AuthRemoteDatasource _remoteDatasource;

  @override
  Future<User> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final user = await _remoteDatasource.login(
      email: email,
      password: password,
      role: role,
    );
    await _remoteDatasource.saveSession(user);
    return user;
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final user = await _remoteDatasource.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    await _remoteDatasource.saveSession(user);
    return user;
  }

  @override
  Future<User> signInWithGoogle({required UserRole role}) async {
    final user = await _remoteDatasource.signInWithGoogle(role: role);
    await _remoteDatasource.saveSession(user);
    return user;
  }

  @override
  Future<User?> checkSession() async {
    if (DebugAuthConfig.isBypassEnabled) {
      return DebugAuthConfig.bypassUser();
    }
    return _remoteDatasource.loadSession();
  }

  @override
  Future<void> logout() => _remoteDatasource.clearSession();
}

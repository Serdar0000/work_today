import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart' as user_entity;

class AuthRemoteDatasource {
  AuthRemoteDatasource({
    FirebaseFirestore? firestore,
    fb_auth.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? fb_auth.FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final fb_auth.FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _profiles =>
      _firestore.collection('profiles');
  CollectionReference<Map<String, dynamic>> get _resumes =>
      _firestore.collection('resumes');

  Future<user_entity.User> register({
    required String name,
    required String email,
    required String password,
    required user_entity.UserRole role,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Не удалось создать пользователя в Firebase Auth');
      }

      await firebaseUser.updateDisplayName(name.trim());
      await _upsertUserAndProfile(
        uid: firebaseUser.uid,
        email: normalizedEmail,
        name: name.trim(),
        role: role,
      );
      if (role == user_entity.UserRole.worker) {
        await _upsertDefaultResume(
          uid: firebaseUser.uid,
          name: name.trim(),
          email: normalizedEmail,
        );
      }

      return _toEntityFromValues(
        uid: firebaseUser.uid,
        email: normalizedEmail,
        name: name.trim(),
        role: role,
        createdAt: DateTime.now(),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Пользователь с таким email уже существует');
      }
      if (e.code == 'weak-password') {
        throw Exception('Слишком простой пароль');
      }
      throw Exception('Ошибка регистрации: ${e.message ?? e.code}');
    }
  }

  Future<user_entity.User> login({
    required String email,
    required String password,
    required user_entity.UserRole role,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Не удалось выполнить вход');
      }

      return _loadUserByUidAndRole(firebaseUser.uid, role);
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        throw Exception('Неверный email или пароль');
      }
      if (e.code == 'user-not-found') {
        throw Exception('Пользователь не найден');
      }
      throw Exception('Ошибка входа: ${e.message ?? e.code}');
    }
  }

  Future<user_entity.User> signInWithGoogle({
    required user_entity.UserRole role,
  }) async {
    try {
      final googleProvider = fb_auth.GoogleAuthProvider();
      final credential = await _auth.signInWithProvider(googleProvider);
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Не удалось выполнить вход через Google');
      }

      final userDoc = await _users.doc(firebaseUser.uid).get();
      if (!userDoc.exists) {
        final name = firebaseUser.displayName?.trim().isNotEmpty == true
            ? firebaseUser.displayName!.trim()
            : 'Пользователь Google';
        final email = (firebaseUser.email ?? '').trim().toLowerCase();

        await _upsertUserAndProfile(
          uid: firebaseUser.uid,
          email: email,
          name: name,
          role: role,
        );

        if (role == user_entity.UserRole.worker) {
          await _upsertDefaultResume(
            uid: firebaseUser.uid,
            name: name,
            email: email,
          );
        }
      }

      return _loadUserByUidAndRole(firebaseUser.uid, role);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw Exception('Ошибка Google входа: ${e.message ?? e.code}');
    }
  }

  Future<void> saveSession(user_entity.User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.kSessionKey, user.id);
    await prefs.setString(
      AppConstants.kSessionAuthUidKey,
      user.authUid ?? '',
    );
    await prefs.setString(AppConstants.kUserEmailKey, user.email);
    await prefs.setString(AppConstants.kUserRoleKey, user.role.name);
  }

  Future<user_entity.User?> loadSession() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    final doc = await _users.doc(firebaseUser.uid).get();
    final data = doc.data();
    if (data == null) {
      return null;
    }
    return _mapUser(data);
  }

  Future<void> clearSession() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.kSessionKey);
    await prefs.remove(AppConstants.kSessionAuthUidKey);
    await prefs.remove(AppConstants.kUserEmailKey);
    await prefs.remove(AppConstants.kUserRoleKey);
  }

  Future<user_entity.User> _loadUserByUidAndRole(
    String uid,
    user_entity.UserRole requestedRole,
  ) async {
    final doc = await _users.doc(uid).get();
    final data = doc.data();
    if (data == null) {
      throw Exception('Профиль пользователя не найден');
    }

    final user = _mapUser(data);
    if (user.role != requestedRole) {
      final requestedRoleLabel = requestedRole == user_entity.UserRole.company
          ? 'компания'
          : 'соискатель';
      throw Exception('Этот аккаунт не относится к роли "$requestedRoleLabel"');
    }

    await _upsertUserAndProfile(
      uid: uid,
      email: user.email,
      name: user.name,
      role: user.role,
    );
    if (user.role == user_entity.UserRole.worker) {
      await _upsertDefaultResume(
        uid: uid,
        name: user.name,
        email: user.email,
      );
    }

    return user;
  }

  Future<void> _upsertUserAndProfile({
    required String uid,
    required String email,
    required String name,
    required user_entity.UserRole role,
  }) async {
    final now = Timestamp.fromDate(DateTime.now());
    await _users.doc(uid).set({
      'uid': uid,
      'id': _stableIdFromUid(uid),
      'email': email,
      'name': name,
      'role': role.name,
      'createdAt': now,
      'updatedAt': now,
    }, SetOptions(merge: true));

    await _profiles.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'role': role.name,
      'phone': '',
      'city': '',
      'createdAt': now,
      'updatedAt': now,
    }, SetOptions(merge: true));
  }

  Future<void> _upsertDefaultResume({
    required String uid,
    required String name,
    required String email,
  }) async {
    final now = Timestamp.fromDate(DateTime.now());
    await _resumes.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'title': 'Соискатель',
      'about': '',
      'skills': <String>[],
      'phone': '',
      'city': '',
      'isPublic': true,
      'createdAt': now,
      'updatedAt': now,
    }, SetOptions(merge: true));
  }

  user_entity.User _mapUser(Map<String, dynamic> data) {
    final createdAtRaw = data['createdAt'];
    final createdAt = createdAtRaw is Timestamp
        ? createdAtRaw.toDate()
        : DateTime.tryParse(createdAtRaw?.toString() ?? '') ?? DateTime.now();

    final roleRaw = data['role'] as String? ?? user_entity.UserRole.worker.name;
    final role = roleRaw == user_entity.UserRole.company.name
        ? user_entity.UserRole.company
        : user_entity.UserRole.worker;

    final uid = (data['uid'] as String?) ?? '';
    return _toEntityFromValues(
      uid: uid,
      email: (data['email'] as String?) ?? '',
      name: (data['name'] as String?) ?? '',
      role: role,
      createdAt: createdAt,
    );
  }

  user_entity.User _toEntityFromValues({
    required String uid,
    required String email,
    required String name,
    required user_entity.UserRole role,
    required DateTime createdAt,
  }) {
    return user_entity.User(
      id: _stableIdFromUid(uid),
      authUid: uid,
      email: email,
      name: name,
      role: role,
      createdAt: createdAt,
    );
  }

  int _stableIdFromUid(String uid) {
    if (uid.isEmpty) {
      return DateTime.now().microsecondsSinceEpoch;
    }
    return uid.hashCode & 0x7fffffff;
  }
}

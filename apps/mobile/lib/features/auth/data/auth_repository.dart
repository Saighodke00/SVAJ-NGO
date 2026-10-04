import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savj_mobile/core/api/providers.dart';
import 'package:savj_mobile/features/auth/domain/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
});

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository(this._dio, this._storage);

  Future<User?> login(String email, String password) async {
    try {
      final response = await _dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200 && response.data['success'] == true) {
        return User.fromJson(response.data['user']);
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
    return null;
  }

  Future<User?> register(String email, String password, String fullName) async {
    try {
      final response = await _dio.post('/api/auth/register', data: {
        'email': email,
        'password': password,
        'fullName': fullName,
      });
      if (response.statusCode == 200 && response.data['success'] == true) {
        return User.fromJson(response.data['user']);
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
    return null;
  }

  Future<User?> checkAuth() async {
    try {
      final response = await _dio.get('/api/auth/me');
      if (response.statusCode == 200 && response.data['user'] != null) {
        return User.fromJson(response.data['user']);
      }
    } catch (e) {
      await _storage.delete(key: 'session_id');
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/auth/logout');
    } catch (_) {}
    await _storage.delete(key: 'session_id');
  }
}

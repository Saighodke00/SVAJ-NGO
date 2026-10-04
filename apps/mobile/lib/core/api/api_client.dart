import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'https://savj-web.vercel.app';
  static const _storage = FlutterSecureStorage();

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final sessionId = await _storage.read(key: 'session_id');
        if (sessionId != null) {
          options.headers['Cookie'] = 'session_id=$sessionId';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Extract and store session cookie from response
        final setCookie = response.headers['set-cookie'];
        if (setCookie != null) {
          for (final cookie in setCookie) {
            if (cookie.startsWith('session_id=')) {
              final value = cookie.split(';')[0].split('=')[1];
              _storage.write(key: 'session_id', value: value);
            }
          }
        }
        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  Future<void> clearSession() async {
    await _storage.delete(key: 'session_id');
  }
}

final apiClient = ApiClient();

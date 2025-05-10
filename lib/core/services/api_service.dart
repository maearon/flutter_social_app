import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_social_app/core/models/auth.dart';
import 'package:flutter_social_app/features/auth/providers/auth_provider.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Singleton constructor
  ApiService._internal() {
    _initDio();
  }

  void _initDio() {
    final baseUrl = kDebugMode
        ? 'http://192.168.1.7:3000/api'
        : 'https://ruby-rails-boilerplate-3s9t.onrender.com/api';

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'x-lang': 'EN',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to request if available
          final token = await _secureStorage.read(key: 'token');
          final rememberToken = await _secureStorage.read(key: 'remember_token');

          if (token != null && token != 'undefined') {
            options.headers['Authorization'] = 'Bearer $token ${rememberToken ?? ''}';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Handle 401 errors (except for auth endpoints)
          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains('/sessions') &&
              !error.requestOptions.path.contains('/refresh')) {
            try {
              final refreshToken = await _secureStorage.read(key: 'refresh_token');

              if (refreshToken != null) {
                final refreshResponse = await _dio.post(
                  '/refresh',
                  data: {'refresh_token': refreshToken},
                );

                final tokens = refreshResponse.data['tokens']['access'];
                final newToken = tokens['token'];
                final newRememberToken = tokens['remember_token'];

                await _secureStorage.write(key: 'token', value: newToken);
                if (newRememberToken != null) {
                  await _secureStorage.write(key: 'remember_token', value: newRememberToken);
                }

                // Update auth provider
                AuthProvider.instance.setTokens(
                  accessToken: newToken,
                  refreshToken: newRememberToken ?? '',
                );

                // Retry the original request with new token
                final opts = Options(
                  method: error.requestOptions.method,
                  headers: {
                    ...error.requestOptions.headers,
                    'Authorization': 'Bearer $newToken ${newRememberToken ?? ''}',
                  },
                );

                final response = await _dio.request(
                  error.requestOptions.path,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                  options: opts,
                );

                return handler.resolve(response);
              }
            } catch (e) {
              debugPrint('API Error in refresh token: $e');
              // Logout user on refresh token failure
              AuthProvider.instance.logout();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Generic GET method
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic POST method
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic PATCH method
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic DELETE method
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Error handling
  Future<T> _handleError<T>(DioException error) async {
    if (error.response != null) {
      debugPrint('API Error: ${error.response?.statusCode} - ${error.response?.data}');
      
      if (error.response?.statusCode == 401 && error.requestOptions.path.contains('/sessions')) {
        debugPrint('Handling 401 error silently for auth check');
        return {'user': null, 'loggedIn': false} as T;
      }

      try {
        final errorData = error.response?.data;
        throw errorData;
      } catch (e) {
        throw error;
      }
    }
    throw error;
  }
}

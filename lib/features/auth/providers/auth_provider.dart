import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_social_app/core/models/auth.dart';
import 'package:flutter_social_app/core/models/user.dart';
import 'package:flutter_social_app/features/auth/services/auth_service.dart';

class AuthState {
  final User? user;
  final bool isLoggedIn;
  final bool isLoading;
  final dynamic error;
  final bool initialized;
  final String? accessToken;
  final String? refreshToken;

  AuthState({
    this.user,
    this.isLoggedIn = false,
    this.isLoading = false,
    this.error,
    this.initialized = false,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthState.initial() => AuthState();

  AuthState copyWith({
    User? user,
    bool? isLoggedIn,
    bool? isLoading,
    dynamic error,
    bool? initialized,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      initialized: initialized ?? this.initialized,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final FlutterSecureStorage _secureStorage;

  static AuthNotifier? _instance;

  static AuthNotifier get instance {
    _instance ??= AuthNotifier(AuthService(), const FlutterSecureStorage());
    return _instance!;
  }

  AuthNotifier(this._authService, this._secureStorage)
      : super(AuthState.initial()) {
    checkAuthStatus();
  }

  bool get initialized => state.initialized;
  bool get isLoggedIn => state.isLoggedIn;

  Future<void> login(LoginCredentials credentials) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.login(credentials);

      if (response.tokens.access.token.isNotEmpty) {
        final accessToken = response.tokens.access.token;
        final refreshToken = response.tokens.refresh.token;

        if (credentials.rememberMe) {
          await _secureStorage.write(key: 'token', value: accessToken);
          await _secureStorage.write(key: 'remember_token', value: refreshToken);
        }

        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          user: response.user,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
      throw error;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (error) {
      debugPrint('Logout error: $error');
    } finally {
      await _secureStorage.delete(key: 'token');
      await _secureStorage.delete(key: 'remember_token');

      state = state.copyWith(
        isLoggedIn: false,
        user: null,
        accessToken: null,
        refreshToken: null,
      );
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await _secureStorage.read(key: 'token');

    if (token == null) {
      state = state.copyWith(isLoggedIn: false, user: null, initialized: true);
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final response = await _authService.checkSession();

      if (response.user != null) {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          user: response.user,
          initialized: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: false,
          user: null,
          initialized: true,
        );
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        user: null,
        initialized: true,
      );
    }
  }

  void setTokens({required String accessToken, required String refreshToken}) {
    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier.instance;
});

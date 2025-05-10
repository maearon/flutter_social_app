import 'package:flutter_social_app/core/models/auth.dart';
import 'package:flutter_social_app/core/models/user.dart';
import 'package:flutter_social_app/core/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<LoginResponse> login(LoginCredentials credentials) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/login',
      data: {'session': credentials.toJson()},
    );
    
    return LoginResponse.fromJson(response);
  }

  Future<void> logout() async {
    await _apiService.delete('logout');
  }

  Future<SessionResponse> checkSession() async {
    final response = await _apiService.get<Map<String, dynamic>>('sessions');
    return SessionResponse.fromJson(response);
  }
}

class SessionResponse {
  final User? user;

  SessionResponse({
    this.user,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

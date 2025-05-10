import 'package:flutter_social_app/core/models/api_response.dart';
import 'package:flutter_social_app/core/services/api_service.dart';

class PasswordResetService {
  final ApiService _apiService = ApiService();

  Future<PasswordResetCreateResponse> requestPasswordReset(String email) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      'password_resets',
      data: {'password_reset': {'email': email}},
    );
    
    return PasswordResetCreateResponse.fromJson(response);
  }

  Future<PasswordResetUpdateResponse> resetPassword(
    String token,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await _apiService.patch<Map<String, dynamic>>(
      'password_resets/$token',
      data: {
        'email': email,
        'user': {
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      },
    );
    
    return PasswordResetUpdateResponse.fromJson(response);
  }
}

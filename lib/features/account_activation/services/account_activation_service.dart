import 'package:flutter_social_app/core/models/api_response.dart';
import 'package:flutter_social_app/core/services/api_service.dart';

class AccountActivationService {
  final ApiService _apiService = ApiService();

  Future<ActivationResponse> resendActivationEmail(String email) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      'account_activations',
      data: {'resend_activation_email': {'email': email}},
    );
    
    return ActivationResponse.fromJson(response);
  }

  Future<ActivationUpdateResponse> activateAccount(String token, String email) async {
    final response = await _apiService.patch<Map<String, dynamic>>(
      'account_activations/$token',
      data: {'email': email},
    );
    
    return ActivationUpdateResponse.fromJson(response);
  }
}

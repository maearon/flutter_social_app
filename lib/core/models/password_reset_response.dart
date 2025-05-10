// lib/core/models/password_reset_response.dart
class PasswordResetResponse {
  final String? successMessage;
  final String? errorMessage;

  PasswordResetResponse({this.successMessage, this.errorMessage});

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('flash')) {
      return PasswordResetResponse(successMessage: json['flash'][1]);
    } else if (json.containsKey('error')) {
      final error = json['error'];
      return PasswordResetResponse(
        errorMessage: error is List ? error[0] : error.toString(),
      );
    }
    return PasswordResetResponse(errorMessage: 'Unknown error');
  }
}

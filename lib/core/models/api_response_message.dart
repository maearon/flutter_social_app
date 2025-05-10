class ApiResponseMessage {
  final String? success;
  final String? error;

  ApiResponseMessage({this.success, this.error});

  factory ApiResponseMessage.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('flash')) {
      return ApiResponseMessage(success: json['flash'][1]);
    } else if (json.containsKey('error')) {
      final error = json['error'];
      return ApiResponseMessage(
        error: error is List ? error.first.toString() : error.toString(),
      );
    }
    return ApiResponseMessage(error: 'Unexpected response');
  }
}

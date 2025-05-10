// lib/core/models/user_request.dart

class UserRequest {
  final int page;

  UserRequest({required this.page});

  Map<String, dynamic> toJson() {
    return {
      'page': page,
    };
  }
}

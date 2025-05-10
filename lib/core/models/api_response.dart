class ApiResponse<T> {
  final T? data;
  final List<String>? flash;
  final dynamic error;
  final int? status;
  final String? message;
  final Map<String, List<String>>? errors;

  ApiResponse({
    this.data,
    this.flash,
    this.error,
    this.status,
    this.message,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse(
      data: json['data'] != null ? fromJson(json['data']) : null,
      flash: json['flash'] != null ? List<String>.from(json['flash']) : null,
      error: json['error'],
      status: json['status'],
      message: json['message'],
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(json['errors'].map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            ))
          : null,
    );
  }
}

class ListParams {
  final int? page;
  final Map<String, dynamic> additionalParams;

  ListParams({
    this.page,
    this.additionalParams = const {},
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> params = {};
    if (page != null) {
      params['page'] = page.toString();
    }
    params.addAll(additionalParams);
    return params;
  }
}

class ListResponse<T> {
  final List<T> items;
  final int totalCount;

  ListResponse({
    required this.items,
    required this.totalCount,
  });

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ListResponse(
      items: (json['items'] as List).map((item) => fromJson(item)).toList(),
      totalCount: json['total_count'],
    );
  }
}

class MicropostListResponse {
  final List<dynamic> feedItems;
  final int followers;
  final int following;
  final String gravatar;
  final int micropost;
  final int totalCount;

  MicropostListResponse({
    required this.feedItems,
    required this.followers,
    required this.following,
    required this.gravatar,
    required this.micropost,
    required this.totalCount,
  });

  factory MicropostListResponse.fromJson(Map<String, dynamic> json) {
    return MicropostListResponse(
      feedItems: json['feed_items'] ?? [],
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      gravatar: json['gravatar'] ?? '',
      micropost: json['micropost'] ?? 0,
      totalCount: json['total_count'] ?? 0,
    );
  }
}

class UserListResponse {
  final List<dynamic> users;
  final int totalCount;

  UserListResponse({
    required this.users,
    required this.totalCount,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      users: json['users'] ?? [],
      totalCount: json['total_count'] ?? 0,
    );
  }
}

class UserShowResponse {
  final dynamic user;
  final int? idRelationships;
  final List<dynamic> microposts;
  final int totalCount;

  UserShowResponse({
    required this.user,
    this.idRelationships,
    required this.microposts,
    required this.totalCount,
  });

  factory UserShowResponse.fromJson(Map<String, dynamic> json) {
    return UserShowResponse(
      user: json['user'],
      idRelationships: json['id_relationships'],
      microposts: json['microposts'] ?? [],
      totalCount: json['total_count'] ?? 0,
    );
  }
}

class UserEditResponse {
  final dynamic user;
  final String gravatar;
  final List<String>? flash;

  UserEditResponse({
    required this.user,
    required this.gravatar,
    this.flash,
  });

  factory UserEditResponse.fromJson(Map<String, dynamic> json) {
    return UserEditResponse(
      user: json['user'],
      gravatar: json['gravatar'] ?? '',
      flash: json['flash'] != null ? List<String>.from(json['flash']) : null,
    );
  }
}

class UserUpdateResponse {
  final List<String>? flashSuccess;
  final dynamic error;

  UserUpdateResponse({
    this.flashSuccess,
    this.error,
  });

  factory UserUpdateResponse.fromJson(Map<String, dynamic> json) {
    return UserUpdateResponse(
      flashSuccess: json['flash_success'] != null ? List<String>.from(json['flash_success']) : null,
      error: json['error'],
    );
  }
}

class UserCreateResponse {
  final dynamic user;
  final List<String>? flash;
  final dynamic error;
  final int? status;
  final String? message;
  final Map<String, List<String>>? errors;

  UserCreateResponse({
    this.user,
    this.flash,
    this.error,
    this.status,
    this.message,
    this.errors,
  });

  factory UserCreateResponse.fromJson(Map<String, dynamic> json) {
    return UserCreateResponse(
      user: json['user'],
      flash: json['flash'] != null ? List<String>.from(json['flash']) : null,
      error: json['error'],
      status: json['status'],
      message: json['message'],
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(json['errors'].map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            ))
          : null,
    );
  }
}

class FollowResponse {
  final List<dynamic> users;
  final int totalCount;
  final Map<String, dynamic> user;

  FollowResponse({
    required this.users,
    required this.totalCount,
    required this.user,
  });

  factory FollowResponse.fromJson(Map<String, dynamic> json) {
    return FollowResponse(
      users: json['users'] ?? [],
      totalCount: json['total_count'] ?? 0,
      user: json['user'] ?? {},
    );
  }
}

class CreateRelationshipResponse {
  final bool follow;

  CreateRelationshipResponse({
    required this.follow,
  });

  factory CreateRelationshipResponse.fromJson(Map<String, dynamic> json) {
    return CreateRelationshipResponse(
      follow: json['follow'] ?? false,
    );
  }
}

class DestroyRelationshipResponse {
  final bool unfollow;

  DestroyRelationshipResponse({
    required this.unfollow,
  });

  factory DestroyRelationshipResponse.fromJson(Map<String, dynamic> json) {
    return DestroyRelationshipResponse(
      unfollow: json['unfollow'] ?? false,
    );
  }
}

class MicropostResponse {
  final List<String>? flash;
  final dynamic error;

  MicropostResponse({
    this.flash,
    this.error,
  });

  factory MicropostResponse.fromJson(Map<String, dynamic> json) {
    return MicropostResponse(
      flash: json['flash'] != null ? List<String>.from(json['flash']) : null,
      error: json['error'],
    );
  }
}

class PasswordResetCreateResponse {
  final List<String> flash;

  PasswordResetCreateResponse({
    required this.flash,
  });

  factory PasswordResetCreateResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetCreateResponse(
      flash: List<String>.from(json['flash']),
    );
  }
}

class PasswordResetUpdateResponse {
  final String? userId;
  final List<String>? flash;
  final dynamic error;

  PasswordResetUpdateResponse({
    this.userId,
    this.flash,
    this.error,
  });

  factory PasswordResetUpdateResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetUpdateResponse(
      userId: json['user_id'],
      flash: json['flash'] != null ? List<String>.from(json['flash']) : null,
      error: json['error'],
    );
  }
}

class ActivationResponse {
  final String? userId;
  final List<String>? flash;
  final dynamic error;

  ActivationResponse({
    this.userId,
    this.flash,
    this.error,
  });

  factory ActivationResponse.fromJson(Map<String, dynamic> json) {
    return ActivationResponse(
      userId: json['user_id'],
      flash: json['flash'] != null ? List<String>.from(json['flash']) : null,
      error: json['error'],
    );
  }
}

class ActivationUpdateResponse {
  final dynamic user;
  final String? jwt;
  final String? token;
  final List<String> flash;
  final dynamic error;

  ActivationUpdateResponse({
    this.user,
    this.jwt,
    this.token,
    required this.flash,
    this.error,
  });

  factory ActivationUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ActivationUpdateResponse(
      user: json['user'],
      jwt: json['jwt'],
      token: json['token'],
      flash: List<String>.from(json['flash']),
      error: json['error'],
    );
  }
}

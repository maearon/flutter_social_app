import 'package:flutter_social_app/core/models/user.dart';

class LoginCredentials {
  final String email;
  final String password;
  final bool rememberMe;

  LoginCredentials({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'remember_me': rememberMe,
    };
  }
}

class AuthTokens {
  final AccessToken access;
  final RefreshToken refresh;

  AuthTokens({
    required this.access,
    required this.refresh,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      access: AccessToken.fromJson(json['access']),
      refresh: RefreshToken.fromJson(json['refresh']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access.toJson(),
      'refresh': refresh.toJson(),
    };
  }
}

class AccessToken {
  final String token;
  final String expires;

  AccessToken({
    required this.token,
    required this.expires,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      token: json['token'],
      expires: json['expires'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expires': expires,
    };
  }
}

class RefreshToken {
  final String token;
  final String expires;

  RefreshToken({
    required this.token,
    required this.expires,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) {
    return RefreshToken(
      token: json['token'],
      expires: json['expires'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expires': expires,
    };
  }
}

class LoginResponse {
  final User user;
  final AuthTokens tokens;
  final List<String>? flash;

  LoginResponse({
    required this.user,
    required this.tokens,
    this.flash,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user']),
      tokens: AuthTokens.fromJson(json['tokens']),
      flash: json['flash'] != null ? List<String>.from(json['flash']) : null,
    );
  }
}

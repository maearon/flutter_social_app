class PasswordResetUpdateParams {
  final String email;
  final PasswordUpdate user;

  PasswordResetUpdateParams({
    required this.email,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'user': user.toJson(),
    };
  }
}

class PasswordUpdate {
  final String password;
  final String passwordConfirmation;

  PasswordUpdate({
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

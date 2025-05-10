class User {
  final String id;
  final String name;
  final String email;
  final String? gravatarId;
  final int? size;
  final int? following;
  final int? followers;
  final bool? currentUserFollowingUser;
  final bool? admin;
  final bool? activated;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.gravatarId,
    this.size,
    this.following,
    this.followers,
    this.currentUserFollowingUser,
    this.admin,
    this.activated,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      gravatarId: json['gravatar_id'],
      size: json['size'],
      following: json['following'],
      followers: json['followers'],
      currentUserFollowingUser: json['current_user_following_user'],
      admin: json['admin'],
      activated: json['activated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gravatar_id': gravatarId,
      'size': size,
      'following': following,
      'followers': followers,
      'current_user_following_user': currentUserFollowingUser,
      'admin': admin,
      'activated': activated,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? gravatarId,
    int? size,
    int? following,
    int? followers,
    bool? currentUserFollowingUser,
    bool? admin,
    bool? activated,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gravatarId: gravatarId ?? this.gravatarId,
      size: size ?? this.size,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      currentUserFollowingUser: currentUserFollowingUser ?? this.currentUserFollowingUser,
      admin: admin ?? this.admin,
      activated: activated ?? this.activated,
    );
  }
}

class UserShow extends User {
  UserShow({
    required String id,
    required String name,
    required String email,
    required int following,
    required int followers,
    required bool currentUserFollowingUser,
    String? gravatarId,
    int? size,
    bool? admin,
    bool? activated,
  }) : super(
          id: id,
          name: name,
          email: email,
          gravatarId: gravatarId,
          size: size,
          following: following,
          followers: followers,
          currentUserFollowingUser: currentUserFollowingUser,
          admin: admin,
          activated: activated,
        );

  factory UserShow.fromJson(Map<String, dynamic> json) {
    return UserShow(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      gravatarId: json['gravatar_id'],
      size: json['size'],
      following: json['following'],
      followers: json['followers'],
      currentUserFollowingUser: json['current_user_following_user'],
      admin: json['admin'],
      activated: json['activated'],
    );
  }
}

class UserEdit {
  final String id;
  final String name;
  final String email;

  UserEdit({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserEdit.fromJson(Map<String, dynamic> json) {
    return UserEdit(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class UserCreateParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  UserCreateParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

class UserUpdateParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  UserUpdateParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

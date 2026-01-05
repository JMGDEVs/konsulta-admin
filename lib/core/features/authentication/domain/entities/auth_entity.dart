class AuthEntity {
  final bool? success;
  final String? message;
  final String? token;
  final UserEntity? user;

  const AuthEntity({
    this.success,
    this.message,
    this.token,
    this.user,
  });

  AuthEntity copyWith({
    bool? success,
    String? message,
    String? token,
    UserEntity? user,
  }) {
    return AuthEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

class UserEntity {
  final int? adminUserId;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? role;

  const UserEntity({
    this.adminUserId,
    this.username,
    this.firstName,
    this.lastName,
    this.role,
  });

  UserEntity copyWith({
    int? adminUserId,
    String? username,
    String? firstName,
    String? lastName,
    String? role,
  }) {
    return UserEntity(
      adminUserId: adminUserId ?? this.adminUserId,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
    );
  }
}


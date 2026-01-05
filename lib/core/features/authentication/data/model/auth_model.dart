import 'package:konsulta_admin/core/features/authentication/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    super.success,
    super.message,
    super.token,
    UserModel? super.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      token: json['token'] as String?,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'user': (user as UserModel?)?.toJson(),
    };
  }
}



class UserModel extends UserEntity {
  const UserModel({
    super.adminUserId,
    super.username,
    super.firstName,
    super.lastName,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      adminUserId: json['admin_user_id'] as int?,
      username: json['username'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_user_id': adminUserId,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
    };
  }

  @override
  UserModel copyWith({
    int? adminUserId,
    String? username,
    String? firstName,
    String? lastName,
    String? role,
  }) {
    return UserModel(
      adminUserId: adminUserId ?? this.adminUserId,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
    );
  }
}

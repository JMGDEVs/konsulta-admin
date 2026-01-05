import 'package:konsulta_admin/core/features/authentication/domain/entities/auth_entity.dart';

abstract class AuthenticationRepo {
  Future<AuthEntity> loginUser(String username, String password);
}
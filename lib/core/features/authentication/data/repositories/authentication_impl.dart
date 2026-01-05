import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/authentication/data/model/auth_model.dart';
import 'package:konsulta_admin/core/features/authentication/domain/entities/auth_entity.dart';
import 'package:konsulta_admin/core/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:konsulta_admin/core/service/api_service/api_paths.dart';
import 'package:konsulta_admin/core/service/api_service/konsulta_admin_api.dart';

@LazySingleton(as: AuthenticationRepo)
class AuthenticationImpl implements AuthenticationRepo {
  final KonsultaProApi api;

  AuthenticationImpl(this.api);

  @override
  Future<AuthEntity> loginUser(String username, String password) async {
    final result = await api.post(
      ApiPath.loginUserPath,
      body: {
        "username": username,
        "password": password,
      },
    );

    if (!result.isSuccess) {
      return AuthModel.fromJson(result.data);
    }


    return AuthModel.fromJson(result.data);
  }
}

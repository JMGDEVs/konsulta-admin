import 'package:injectable/injectable.dart';
import 'package:konsulta_admin/core/features/authentication/domain/entities/auth_entity.dart';
import 'package:konsulta_admin/core/features/authentication/domain/repositories/authentication_repo.dart';

@injectable
class AuthUseCase {
  final AuthenticationRepo _userRepository;

  AuthUseCase(this._userRepository);

  Future<AuthEntity> call(String username, String password) async {
    return await _userRepository.loginUser(username, password);
  }
}
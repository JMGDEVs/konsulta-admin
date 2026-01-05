import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsulta_admin/core/features/authentication/domain/use_case/auth_use_case.dart';
import 'package:konsulta_admin/core/features/router/app_router.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc(
    this.authUseCase
  ) : super(AuthInitialState()) { 
    final secureStorage = FlutterSecureStorage();

    on<OnLogin>((event, emit) async {
      emit(ButtonLoading());

      final result = await authUseCase.call(event.username, event.password);

      if(result.success == true) {
        emit(SuccessLogin());
        await secureStorage.write(key: 'token', value: result.token);
        await AppRouter.checkAuthState();
        
      } else {
        emit(
          LoginFailed(
            result.message ?? ''

          )
        );
      }

      // if(result.)
    });
  }
}
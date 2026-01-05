import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsulta_admin/app_state.dart';
import 'package:konsulta_admin/core/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:konsulta_admin/core/features/router/app_router.dart';
import 'package:konsulta_admin/core/service/dependency_injection/injection.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await AppRouter.checkAuthState();
  setPathUrlStrategy();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: AppState()
    )
  );
}
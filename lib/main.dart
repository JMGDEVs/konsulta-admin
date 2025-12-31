import 'package:flutter/material.dart';
import 'package:konsulta_admin/app_state.dart';
import 'package:konsulta_admin/core/features/router/app_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppRouter.checkAuthState();
  setPathUrlStrategy();
  
  runApp(
    AppState()
  );
}
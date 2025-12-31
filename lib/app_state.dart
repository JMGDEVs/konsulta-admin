import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/features/router/app_router.dart';
import 'package:konsulta_admin/core/theme/custom_theme.dart';

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
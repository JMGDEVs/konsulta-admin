import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:konsulta_admin/core/features/router/route_base.dart';
import 'route_paths.dart';

class AppRouter {
  static final _secureStorage = const FlutterSecureStorage();
  static final ValueNotifier<bool> authStateNotifier = ValueNotifier(false);

  /// Checks the stored token and updates the authentication state.
  static Future<void> checkAuthState() async {
    final token = await _secureStorage.read(key: 'token');

    if (token == null || token.isEmpty) {
      authStateNotifier.value = false;
      return;
    }

    final isExpired = JwtDecoder.isExpired(token);
    
    if (isExpired) {
      await _secureStorage.delete(key: 'token');
      authStateNotifier.value = false;
    } else {
      authStateNotifier.value = true;
    }
  }

  /// Main app router with authentication-aware redirect logic.
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.dashboard,
    routes: RoutePages().routes,
    refreshListenable: authStateNotifier,
    redirect: (context, state) async {
      final isLoggedIn = authStateNotifier.value;

      if(!isLoggedIn) {
        return RoutePaths.login;
      }

      return RoutePaths.dashboard;
    }
  );
}
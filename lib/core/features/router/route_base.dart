import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konsulta_admin/core/features/authentication/presentation/pages/login_layout.dart';
import 'package:konsulta_admin/core/features/home_controller/home_state_controller.dart';
import 'package:konsulta_admin/core/features/router/route_paths.dart';

class RoutePages {
  List<RouteBase> get routes => [
        GoRoute(
          name: '/',
          path: RoutePaths.login,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginLayout(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          name: '/dashboard',
          path: RoutePaths.dashboard,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeStateController(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        
      ];
}

class CustomTransitionPage<T> extends Page<T> {
  const CustomTransitionPage({
    required this.child,
    this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 400),
    this.reverseTransitionDuration = const Duration(milliseconds: 200),
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  )? transitionsBuilder;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, _) => child,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionsBuilder: transitionsBuilder ??
          (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
    );
  }
}

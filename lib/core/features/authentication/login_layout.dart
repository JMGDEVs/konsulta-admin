import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/features/authentication/login_mobile_screen.dart';
import 'package:konsulta_admin/core/features/authentication/login_tablet_screen.dart';
import 'package:konsulta_admin/core/features/authentication/login_web_screen.dart';
import 'package:konsulta_admin/core/widgets/repsonsive.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout({super.key});

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: LoginMobileScreen(),
        tablet: LoginTabletScreen(),
        desktop: LoginWebScreen(),
        desktopTablet: LoginWebScreen()
      ),
    );
  }
}
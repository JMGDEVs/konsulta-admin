import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/features/authentication/presentation/pages/login_web_screen.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout({super.key});

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginWebScreen()
    );
  }
}
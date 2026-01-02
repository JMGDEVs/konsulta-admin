import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/widgets/layout/layout_container.dart';

class HomeStateWeb extends StatefulWidget {
  const HomeStateWeb({super.key});

  @override
  State<HomeStateWeb> createState() => _HomeStateWebState();
}

class _HomeStateWebState extends State<HomeStateWeb> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Center(
        child: Text(
          'Welcome to the Dashboard!',
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/features/dashboard/dashboard_web.dart';
import 'package:konsulta_admin/core/widgets/repsonsive.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Center(
        child: Text(
          'Welcome to the Dashboard! (Mobile)',
        ),
      ),
      tablet: Center(
        child: Text(
          'Welcome to the Dashboard! (Tablet)',
        ),
      ),
      desktop: HomeStateWeb(),
      desktopTablet: HomeStateWeb()
    );
  }
}
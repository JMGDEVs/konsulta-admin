import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final Widget desktopTablet;

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    required this.desktopTablet,
  });

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1440;

  static bool isDesktopTablet(BuildContext context) => MediaQuery.of(context).size.width >= 1100 && MediaQuery.of(context).size.width < 1440;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        
        if (constraints.maxWidth >= 1440) {
          return desktop;  // Normal web screens (1920px, etc.)
        } else if (constraints.maxWidth >= 1100) {
          return desktopTablet;  // Tablet in landscape (1280px)
        } else if (constraints.maxWidth >= 650) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
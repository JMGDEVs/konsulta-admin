import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFFC107);
  static const Color lightGray =
      Color.from(alpha: 1, red: 0.435, green: 0.435, blue: 0.435);
  static const Color gray = Color(0xFFE9E9E9);
  static const Color divider = Color(0xFFBABABA);
  static const Color grayText = Color(0xFF6F6F6F);
  static const Color lighterGray = Color(0xFFE6E6E6);
  static const Color lightGrayText = Color(0xFFD9D9D9);
  static const Color darkPrimary = Color(0xFFFF9B06);
  static const Color green = Color(0xFF00C217);
  static const Color red = Color(0xFFFB4545);
  static const Color blue = Color(0xFF2196F3);
  static const Color lightPrimary = Color(0xFFFFF4D3);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundColorGrey = Color(0xFFF6F6F6);
  static const Color switchGreen = Color(0xFF21DA00);
  static const Color hoverColor = Color(0xFFF1F1F1);
  static const Color darkgreyColor = Color(0xFF1A1A1A);

  static LinearGradient primaryGradientTopToBottom = const LinearGradient(
    colors: [
      Color.fromARGB(255, 244, 214, 123),
      primary,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient primaryGradientLeftToRight = const LinearGradient(
    colors: [
      Color(0xFFFF9807),
      primary,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient primaryDarkGradientLeftToRight = const LinearGradient(
    colors: [primary, darkPrimary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

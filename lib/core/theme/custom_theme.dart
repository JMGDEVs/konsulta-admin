import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // --- Colors ---
  static const primaryColor = Color(0xFFFFC107);
  static const secondaryColor = Colors.black;
  static const tertiaryColor = Color(0xFF6F6F6F);
  static const backgroundColor = Colors.white;

  // --- Base Theme Builder ---
  static ThemeData _baseTheme({
    required Brightness brightness,
  }) {
    final isLight = brightness == Brightness.light;

    const double negativeSpacing = 0;

    // interTextTheme
    final interTextTheme = TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.bold, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w600, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w500, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w500, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w300, color: isLight ? tertiaryColor : Colors.grey[300], letterSpacing: negativeSpacing),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: negativeSpacing),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: isLight ? secondaryColor : Colors.white, letterSpacing: negativeSpacing),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: isLight ? tertiaryColor : Colors.grey[300], letterSpacing: negativeSpacing),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: backgroundColor,
        onSurface: secondaryColor,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: interTextTheme,

      // APPBAR
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: secondaryColor,
        elevation: 5,
        titleTextStyle: interTextTheme.headlineSmall?.copyWith(color: secondaryColor),
        iconTheme: const IconThemeData(color: secondaryColor),
        surfaceTintColor: backgroundColor
      ),

      // BUTTONS
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: interTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: interTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // DIALOG
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: interTextTheme.headlineSmall,
        contentTextStyle: interTextTheme.bodyMedium,
      ),
      dialogBackgroundColor: backgroundColor,

      // INPUT
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.inter(fontSize: 14, color: secondaryColor, letterSpacing: negativeSpacing),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: tertiaryColor.withOpacity(0.6), letterSpacing: negativeSpacing),
        helperStyle: GoogleFonts.inter(fontSize: 12, color: tertiaryColor.withOpacity(0.8), letterSpacing: negativeSpacing),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2), borderRadius: BorderRadius.circular(8)),
      ),

      // SWITCH
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? primaryColor : Colors.grey),
        trackColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? primaryColor.withOpacity(0.5) : Colors.grey.withOpacity(0.3)),
      ),

      // TOGGLE BUTTONS
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: secondaryColor,
        selectedColor: Colors.white,
        fillColor: primaryColor,
        borderRadius: BorderRadius.circular(8),
        borderColor: tertiaryColor.withOpacity(0.4),
        selectedBorderColor: primaryColor,
        textStyle: interTextTheme.labelMedium,
      ),

      // ICONS
      iconTheme: IconThemeData(color: secondaryColor),

      // DIVIDER
      dividerColor: Colors.grey.shade300,
    );
  }

  // LIGHT THEME
  static final ThemeData lightTheme = _baseTheme(brightness: Brightness.light);

  // DARK THEME
  static final ThemeData darkTheme = _baseTheme(brightness: Brightness.dark);
}

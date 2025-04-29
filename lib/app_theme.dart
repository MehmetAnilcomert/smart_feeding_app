import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryBrown = Color(0xFF8D6E63);
  static const Color primaryDarkBrown = Color(0xFF5D4037);
  static const Color primaryLightBrown = Color(0xFFBCAAA4);

  // Accent colors
  static const Color accentAmber = Color(0xFFFFB300);
  static const Color accentGreen = Color(0xFF66BB6A);
  static const Color accentRed = Color(0xFFEF5350);

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF303030);

  // Text colors
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFFF5F5F5);

  // Card colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF424242);

  // Gradient colors
  static const List<Color> temperatureGradientCold = [
    Color(0xFF64B5F6),
    Color(0xFF42A5F5),
  ];
  static const List<Color> temperatureGradientWarm = [
    Color(0xFFFFB74D),
    Color(0xFFFF9800),
  ];
  static const List<Color> temperatureGradientHot = [
    Color(0xFFEF5350),
    Color(0xFFE53935),
  ];

  // Border radius
  static const double borderRadius = 16.0;

  // Spacing
  static const double spacing = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;

  // Elevation
  static const double cardElevation = 4.0;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryBrown,
      secondary: accentAmber,
      background: backgroundLight,
      surface: cardLight,
      onPrimary: textLight,
      onSecondary: textDark,
      onBackground: textDark,
      onSurface: textDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBrown,
      foregroundColor: textLight,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: cardLight,
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBrown,
        foregroundColor: textLight,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: spacing * 1.5,
          vertical: spacingSmall,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: primaryBrown, width: 2),
      ),
      filled: true,
      fillColor: cardLight,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardLight,
      selectedItemColor: primaryBrown,
      unselectedItemColor: textDark.withOpacity(0.6),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: cardLight,
      collapsedBackgroundColor: cardLight,
      textColor: primaryBrown,
      iconColor: primaryBrown,
      childrenPadding: EdgeInsets.all(spacing),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryLightBrown,
      secondary: accentAmber,
      background: backgroundDark,
      surface: cardDark,
      onPrimary: textDark,
      onSecondary: textLight,
      onBackground: textLight,
      onSurface: textLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDarkBrown,
      foregroundColor: textLight,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: cardDark,
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLightBrown,
        foregroundColor: textDark,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: spacing * 1.5,
          vertical: spacingSmall,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: primaryLightBrown, width: 2),
      ),
      filled: true,
      fillColor: cardDark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardDark,
      selectedItemColor: primaryLightBrown,
      unselectedItemColor: textLight.withOpacity(0.6),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: cardDark,
      collapsedBackgroundColor: cardDark,
      textColor: primaryLightBrown,
      iconColor: primaryLightBrown,
      childrenPadding: EdgeInsets.all(spacing),
    ),
  );
}

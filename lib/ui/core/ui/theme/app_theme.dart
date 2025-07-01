// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color Palette
  static const Color _primaryBlue = Color(0xFF1E40AF); // Primary blue
  static const Color _primaryBlueLight = Color(0xFF3B82F6); // Lighter blue
  static const Color _primaryBlueDark = Color(0xFF1E3A8A); // Darker blue

  static const Color _accentGreen = Color(0xFF10B981); // Success/profit green
  static const Color _accentRed = Color(0xFFEF4444); // Error/loss red
  static const Color _accentYellow = Color(0xFFF59E0B,); // Warning/pending yellow
  static const Color _accentPurple = Color(0xFF8B5CF6); // Premium purple

  // Neutral colors
  static const Color _neutralWhite = Color(0xFFFFFFFF);
  static const Color _neutralGray50 = Color(0xFFF9FAFB);
  static const Color _neutralGray100 = Color(0xFFF3F4F6);
  static const Color _neutralGray200 = Color(0xFFE5E7EB);
  static const Color _neutralGray300 = Color(0xFFD1D5DB);
  static const Color _neutralGray400 = Color(0xFF9CA3AF);
  static const Color _neutralGray500 = Color(0xFF6B7280);
  static const Color _neutralGray600 = Color(0xFF4B5563);
  static const Color _neutralGray700 = Color(0xFF374151);
  static const Color _neutralGray800 = Color(0xFF1F2937);
  static const Color _neutralGray900 = Color(0xFF111827);
  static const Color _neutralBlack = Color(0xFF000000);

  // Dark theme colors
  static const Color _darkBackground = Color(0xFF0F172A);
  static const Color _darkSurface = Color(0xFF1E293B);
  static const Color _darkSurfaceVariant = Color(0xFF334155);

  // Custom ColorScheme for fintech
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _primaryBlue,
    onPrimary: _neutralWhite,
    primaryContainer: Color(0xFFDDEAFE),
    onPrimaryContainer: _primaryBlueDark,
    secondary: _accentGreen,
    onSecondary: _neutralWhite,
    secondaryContainer: Color(0xFFD1FAE5),
    onSecondaryContainer: Color(0xFF065F46),
    tertiary: _accentPurple,
    onTertiary: _neutralWhite,
    tertiaryContainer: Color(0xFFEDE9FE),
    onTertiaryContainer: Color(0xFF581C87),
    error: _accentRed,
    onError: _neutralWhite,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF991B1B),
    surface: _neutralWhite,
    onSurface: _neutralGray900,
    surfaceContainerHighest: _neutralGray50,
    onSurfaceVariant: _neutralGray600,
    outline: _neutralGray300,
    outlineVariant: _neutralGray200,
    shadow: _neutralBlack,
    scrim: _neutralBlack,
    inverseSurface: _neutralGray800,
    onInverseSurface: _neutralGray100,
    inversePrimary: _primaryBlueLight,
    surfaceTint: _primaryBlue,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: _primaryBlueLight,
    onPrimary: _neutralGray900,
    primaryContainer: _primaryBlueDark,
    onPrimaryContainer: Color(0xFFDDEAFE),
    secondary: _accentGreen,
    onSecondary: _neutralGray900,
    secondaryContainer: Color(0xFF065F46),
    onSecondaryContainer: Color(0xFFD1FAE5),
    tertiary: _accentPurple,
    onTertiary: _neutralGray900,
    tertiaryContainer: Color(0xFF581C87),
    onTertiaryContainer: Color(0xFFEDE9FE),
    error: _accentRed,
    onError: _neutralGray900,
    errorContainer: Color(0xFF991B1B),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: _darkSurface,
    onSurface: _neutralGray100,
    surfaceContainerHighest: _darkSurfaceVariant,
    onSurfaceVariant: _neutralGray300,
    outline: _neutralGray600,
    outlineVariant: _neutralGray700,
    shadow: _neutralBlack,
    scrim: _neutralBlack,
    inverseSurface: _neutralGray100,
    onInverseSurface: _neutralGray800,
    inversePrimary: _primaryBlue,
    surfaceTint: _primaryBlueLight,
  );

  // Custom text styles for fintech
  static const TextTheme _textTheme = TextTheme(
    // Display styles - for large headings
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),

    // Headline styles - for card titles, section headers
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
    ),

    // Title styles - for app bars, dialog titles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),

    // Body styles - for main content
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),

    // Label styles - for buttons, chips, etc.
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,
      fontFamily: 'Inter', // Modern, clean font for fintech
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: _neutralWhite,
        foregroundColor: _neutralGray900,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _neutralGray900,
          letterSpacing: 0,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Card Theme
      /*cardTheme: CardTheme(
        elevation: 2,
        shadowColor: _neutralGray900.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),*/

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: _neutralGray300, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _neutralGray50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _neutralGray300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _neutralGray300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accentRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accentRed, width: 2),
        ),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _neutralGray600,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _neutralGray400,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _neutralWhite,
        selectedItemColor: _primaryBlue,
        unselectedItemColor: _neutralGray400,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _neutralGray100,
        disabledColor: _neutralGray200,
        selectedColor: _primaryBlue.withOpacity(0.12),
        secondarySelectedColor: _accentGreen.withOpacity(0.12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        secondaryLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: _neutralGray200,
        thickness: 1,
        space: 1,
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // Dialog Theme
      /*dialogTheme: DialogTheme(
        elevation: 8,
        backgroundColor: _neutralWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _neutralGray900,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _neutralGray700,
          height: 1.5,
        ),
      ),*/

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: _primaryBlue,
        foregroundColor: _neutralWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryBlue,
        linearTrackColor: _neutralGray200,
        circularTrackColor: _neutralGray200,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _neutralWhite;
          }
          return _neutralGray400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryBlue;
          }
          return _neutralGray300;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryBlue;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(_neutralWhite),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryBlue;
          }
          return _neutralGray400;
        }),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      textTheme: _textTheme,
      fontFamily: 'Inter',

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: _darkBackground,
        foregroundColor: _neutralGray100,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _neutralGray100,
          letterSpacing: 0,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      /*cardTheme: CardTheme(
        elevation: 4,
        shadowColor: _neutralBlack.withOpacity(0.3),
        surfaceTintColor: Colors.transparent,
        color: _darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),*/

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _primaryBlueLight,
          foregroundColor: _neutralGray900,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _neutralGray600, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _neutralGray600, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryBlueLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accentRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accentRed, width: 2),
        ),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _neutralGray300,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _neutralGray500,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _darkSurface,
        selectedItemColor: _primaryBlueLight,
        unselectedItemColor: _neutralGray500,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Dialog Theme
      /*dialogTheme: DialogTheme(
        elevation: 8,
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _neutralGray100,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _neutralGray300,
          height: 1.5,
        ),
      )*/

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryBlueLight,
        linearTrackColor: _neutralGray700,
        circularTrackColor: _neutralGray700,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: _neutralGray700,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Custom fintech-specific colors
  static const Color profitGreen = _accentGreen;
  static const Color lossRed = _accentRed;
  static const Color warningYellow = _accentYellow;
  static const Color premiumPurple = _accentPurple;
  static const Color neutralGray = _neutralGray500;

  // Gradient definitions for fintech cards
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [_primaryBlue, _primaryBlueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF059669), _accentGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [_accentPurple, Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [_neutralGray800, _neutralGray700],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Extension for easy access to custom colors
extension AppColors on ColorScheme {
  Color get profit => AppTheme.profitGreen;
  Color get loss => AppTheme.lossRed;
  Color get warning => AppTheme.warningYellow;
  Color get premium => AppTheme.premiumPurple;
  Color get neutral => AppTheme.neutralGray;
}

// Extension for gradients
extension AppGradients on ThemeData {
  LinearGradient get primaryGradient => AppTheme.primaryGradient;
  LinearGradient get successGradient => AppTheme.successGradient;
  LinearGradient get premiumGradient => AppTheme.premiumGradient;
  LinearGradient get darkGradient => AppTheme.darkGradient;
}
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0F162B);
  static const Color primaryDark = Color(0xFF099DE8);
  static const Color secondaryColor = Color(0xFF202F6F);
  static const Color navy = Color(0xFF054C8D);
  static const Color navy2 = Color(0xFF161B30);
  static const Color nearBlack = Color(0xFF1C1B22);
  static const Color offWhite = Color(0xFFF4F5F8);
  static const Color lightBackground = offWhite;
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = navy;
  static const Color lightSecondaryText = navy2;
  static const Color darkBackground = Color(0xFF121418);
  static const Color cardDark = Color(0xFF1a1d23);
  static const Color darkSurface = navy;
  static const Color darkOnSurface = offWhite;
  static const Color darkSecondaryText = Color(0xFFD6D9E3);

  static ThemeData get lightTheme {
    final cs = ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.grey,
      surface: lightSurface,
      onSurface: primaryDark,
      onSurfaceVariant: offWhite,
      onInverseSurface: nearBlack,
      shadow: Colors.grey
    );

    return ThemeData(
      fontFamily: 'Inter',
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,
      scaffoldBackgroundColor: lightSurface,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightOnSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: lightSecondaryText),
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          color: lightSecondaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      iconTheme: const IconThemeData(color: lightSecondaryText),
      cardTheme: CardThemeData(
        elevation: 0,
        color: lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          visualDensity: const VisualDensity(vertical: -4),
          foregroundColor: primaryColor,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 16),
          overlayColor: Colors.transparent,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: offWhite,
        suffixIconColor: Colors.grey,
        iconColor: Colors.grey,
        prefixIconColor: Colors.grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE6E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.grey,
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: lightSecondaryText,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightSecondaryText,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: lightSecondaryText),
        bodyMedium: TextStyle(fontSize: 14, color: lightSecondaryText),
        bodySmall: TextStyle(fontSize: 12, color: lightSecondaryText),
        labelMedium: TextStyle(fontSize: 12, color: lightSecondaryText),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE6E8F0),
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        tileColor: offWhite,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightSecondaryText,
        ),
        iconColor: primaryColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    final cs =
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ).copyWith(
          error: Colors.redAccent,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: darkSurface,
          onPrimary: Colors.white,
          onSecondary: Colors.grey,
          onSurface: darkOnSurface,
          onSurfaceVariant: cardDark,
        );

    return ThemeData(
      fontFamily: 'Inter',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkOnSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: darkOnSurface),
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          color: darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      iconTheme: const IconThemeData(color: darkSecondaryText),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          visualDensity: const VisualDensity(vertical: -4),
          foregroundColor: primaryDark,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 16),
          overlayColor: Colors.transparent,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        suffixIconColor: darkSecondaryText,
        iconColor: darkSecondaryText,
        prefixIconColor: darkSecondaryText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2A335A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightOnSurface),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          color: darkSecondaryText,
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          color: darkSecondaryText,
          fontSize: 14,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: darkOnSurface),
        bodyMedium: TextStyle(fontSize: 14, color: darkOnSurface),
        bodySmall: TextStyle(fontSize: 12, color: darkSecondaryText),
        labelMedium: TextStyle(fontSize: 12, color: darkSecondaryText),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A335A),
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        tileColor: cardDark,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
        iconColor: primaryDark,
      ),
    );
  }
}

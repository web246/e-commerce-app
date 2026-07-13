import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light theme colors
  static const Color _primaryColor = Color(0xFF4F46E5); // Indigo
  static const Color _secondaryColor = Color(0xFFF59E0B); // Amber
  static const Color _surfaceColor = Color(0xFFF8FAFC);
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _errorColor = Color(0xFFEF4444);

  // Dark theme colors
  static const Color _darkPrimaryColor = Color(0xFF818CF8); // Lighter indigo
  static const Color _darkSecondaryColor = Color(0xFFFBBF24); // Lighter amber
  static const Color _darkSurfaceColor = Color(0xFF1E293B);
  static const Color _darkBackgroundColor = Color(0xFF0F172A);
  static const Color _darkErrorColor = Color(0xFFF87171);
  static const Color _darkOnPrimaryColor = Color(0xFF1E1E2E);
  static const Color _darkOnSecondaryColor = Color(0xFF1E1E2E);
  static const Color _darkOnErrorColor = Color(0xFF1E1E2E);

  // Legacy static color constants (kept for backward compatibility)
  static const Color background = Color(0xFFF8FAFC);
  static const Color foreground = Color(0xFF0A0F1E);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF005BB5);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFF1F5F9);
  static const Color muted = Color(0xFFF1F5F9);
  static const Color mutedForeground = Color(0xFF64748B);
  static const Color accent = Color(0xFFE67A00);
  static const Color destructive = Color(0xFFEF4444);
  static const Color border = Color(0xFFDBE4F0);
  static const double radius = 12.0;

  static const Color backgroundDark = Color(0xFF0A0F1E);
  static const Color foregroundDark = Color(0xFFF8FAFC);
  static const Color cardDark = Color(0xFF1A2035);
  static const Color primaryDark = Color(0xFF0066FF);
  static const Color secondaryDark = Color(0xFF232B3D);
  static const Color mutedForegroundDark = Color(0xFF8B95A8);
  static const Color borderDark = Color(0xFF232B3D);

  static final Map<String, Color> categoryColors = {
    'Electronics': Color(0xFF4F46E5),
    'Fashion': Color(0xFFF59E0B),
    'Phones': Color(0xFF6366F1),
    'Computers': Color(0xFF818CF8),
    'Furniture': Color(0xFF8B5CF6),
    'Gaming': Color(0xFFEC4899),
    'Beauty': Color(0xFFF59E0B),
    'Shoes': Color(0xFF10B981),
    'Groceries': Color(0xFF22C55E),
    'Kitchen': Color(0xFFF97316),
    'Automotive': Color(0xFF64748B),
    'Health': Color(0xFFEF4444),
    'Sports': Color(0xFF06B6D4),
    'More': Color(0xFF94A3B8),
  };

  static final LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF4338CA)],
  );

  static final LinearGradient gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static final LinearGradient gradientHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF6366F1), Color(0xFF4338CA)],
    stops: [0.0, 0.5, 1.0],
  );

  static final List<BoxShadow> hydroShadow = [
    BoxShadow(
      color: Color(0xFF4F46E5).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> hydroShadowHover = [
    BoxShadow(
      color: Color(0xFF4F46E5).withValues(alpha: 0.15),
      blurRadius: 40,
      offset: Offset(0, 8),
    ),
  ];

  // Text theme using Inter + Plus Jakarta Sans
  static TextTheme get _baseTextTheme {
    final interTheme = GoogleFonts.interTextTheme();
    return interTheme.copyWith(
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 28, fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 22, fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 18, fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16, fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400,
      ),
      bodySmall: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400,
      ),
      labelLarge: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1E293B),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: _backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _backgroundColor,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _surfaceColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Color(0xFF94A3B8),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: _baseTextTheme,
      dividerColor: const Color(0xFFE2E8F0),
      iconTheme: const IconThemeData(color: Color(0xFF475569)),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        surface: _darkSurfaceColor,
        error: _darkErrorColor,
        onPrimary: _darkOnPrimaryColor,
        onSecondary: _darkOnSecondaryColor,
        onSurface: Color(0xFFF1F5F9),
        onError: _darkOnErrorColor,
      ),
      scaffoldBackgroundColor: _darkBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkBackgroundColor,
        foregroundColor: const Color(0xFFF1F5F9),
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF1F5F9),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _darkSurfaceColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimaryColor,
          foregroundColor: _darkOnPrimaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _darkPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _darkErrorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E293B),
        selectedItemColor: _darkPrimaryColor,
        unselectedItemColor: Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: _baseTextTheme.apply(
        bodyColor: const Color(0xFFF1F5F9),
        displayColor: const Color(0xFFF1F5F9),
      ),
      dividerColor: const Color(0xFF334155),
      iconTheme: const IconThemeData(color: Color(0xFF94A3B8)),
    );
  }
}

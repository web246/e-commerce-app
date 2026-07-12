import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
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
    'Electronics': Color(0xFF005BB5),
    'Fashion': Color(0xFFE67A00),
    'Phones': Color(0xFF0077CC),
    'Computers': Color(0xFF6366F1),
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
    colors: [Color(0xFF005BB5), Color(0xFF003D8F)],
  );

  static final LinearGradient gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE67A00), Color(0xFFC45F00)],
  );

  static final LinearGradient gradientHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF005BB5), Color(0xFF0077CC), Color(0xFF003D8F)],
    stops: [0.0, 0.5, 1.0],
  );

  static final List<BoxShadow> hydroShadow = [
    BoxShadow(
      color: Color(0xFF005BB5).withOpacity(0.10),
      blurRadius: 24,
      offset: Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> hydroShadowHover = [
    BoxShadow(
      color: Color(0xFF005BB5).withOpacity(0.18),
      blurRadius: 40,
      offset: Offset(0, 8),
    ),
  ];

  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -0.02),
    displayMedium: GoogleFonts.plusJakartaSans(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.02),
    displaySmall: GoogleFonts.plusJakartaSans(fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.02),
    headlineMedium: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.02),
    headlineSmall: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.02),
    titleLarge: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.6),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.6),
    labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: primaryForeground,
        surface: card,
        onSurface: foreground,
        secondary: secondary,
        onSecondary: foreground,
      ),
      cardColor: card,
      dividerColor: border,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: const IconThemeData(color: foreground),
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: foreground),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          textStyle: textTheme.titleLarge?.copyWith(color: primaryForeground),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryDark,
      colorScheme: ColorScheme.dark(
        primary: primaryDark,
        onPrimary: primaryForeground,
        surface: cardDark,
        onSurface: foregroundDark,
        secondary: secondaryDark,
        onSecondary: foregroundDark,
      ),
      cardColor: cardDark,
      dividerColor: borderDark,
      textTheme: textTheme.apply(bodyColor: foregroundDark, displayColor: foregroundDark),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: foregroundDark),
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: foregroundDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: primaryForeground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          textStyle: textTheme.titleLarge?.copyWith(color: primaryForeground),
        ),
      ),
    );
  }
}

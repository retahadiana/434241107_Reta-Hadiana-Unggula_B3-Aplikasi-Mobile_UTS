import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'glassmorphism.dart';

class AppTheme {
  // ─── Anti-Gravity Palette ─────────────────────────────────────────────────
  static const Color deepNavy = Color(0xFF192A56);
  static const Color charcoal = Color(0xFF2D3436);
  static const Color softPurple = Color(0xFF6C5CE7);
  static const Color accentBlue = Color(0xFF74B9FF);
  static const Color accentCyan = Color(0xFF00CEC9);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME — Soft pastel glassmorphism
  // ═══════════════════════════════════════════════════════════════════════════
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: softPurple,
        primary: softPurple,
        secondary: accentBlue,
        surface: const Color(0xFFF0EEFF),
        onSurface: const Color(0xFF1A1A2E),
        error: const Color(0xFFE74C3C),
      ),
    );

    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: deepNavy,
        iconTheme: const IconThemeData(color: Color(0xFF2D3436)),
        titleTextStyle: GoogleFonts.poppins(
          color: deepNavy,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white.withValues(alpha: 0.55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: deepNavy.withValues(alpha: 0.4)),
        labelStyle: TextStyle(color: deepNavy.withValues(alpha: 0.6)),
        floatingLabelStyle: const TextStyle(color: softPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: softPurple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFFE74C3C)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          backgroundColor: deepNavy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          elevation: 4,
          shadowColor: deepNavy.withValues(alpha: 0.3),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          elevation: 4,
          shadowColor: deepNavy.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          backgroundColor: deepNavy,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          foregroundColor: deepNavy,
          side: BorderSide(color: deepNavy.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: softPurple,
        ),
      ),
      iconTheme: IconThemeData(color: deepNavy.withValues(alpha: 0.7)),
      dividerTheme: DividerThemeData(color: deepNavy.withValues(alpha: 0.08)),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.5),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
        labelStyle: TextStyle(color: deepNavy.withValues(alpha: 0.8), fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.white.withValues(alpha: 0.6),
        indicatorColor: softPurple.withValues(alpha: 0.15),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: deepNavy.withValues(alpha: 0.7)),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: deepNavy.withValues(alpha: 0.8),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(softPurple),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return softPurple.withValues(alpha: 0.3);
          }
          return deepNavy.withValues(alpha: 0.1);
        }),
      ),
      radioTheme: const RadioThemeData(
        fillColor: WidgetStatePropertyAll(softPurple),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: deepNavy,
        contentTextStyle: GoogleFonts.poppins(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color(0xFFF0EEFF).withValues(alpha: 0.95),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFF0EEFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      listTileTheme: ListTileThemeData(
        textColor: deepNavy,
        iconColor: deepNavy.withValues(alpha: 0.6),
        subtitleTextStyle: TextStyle(color: deepNavy.withValues(alpha: 0.5)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: softPurple,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME — Deep navy glassmorphism
  // ═══════════════════════════════════════════════════════════════════════════
  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: softPurple,
        primary: accentCyan,
        secondary: accentBlue,
        surface: const Color(0xFF1A1A2E),
        onSurface: Colors.white,
        error: const Color(0xFFFF6B6B),
        onError: Colors.white,
      ),
    );

    final textTheme = GoogleFonts.poppinsTextTheme(
      base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: AGColors.glassFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AGColors.glassBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AGColors.glassFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        floatingLabelStyle: const TextStyle(color: accentCyan),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: AGColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: AGColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: accentCyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          backgroundColor: Colors.white,
          foregroundColor: deepNavy,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          elevation: 4,
          shadowColor: Colors.black26,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          backgroundColor: Colors.white,
          foregroundColor: deepNavy,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white.withValues(alpha: 0.8),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      dividerTheme: DividerThemeData(color: Colors.white.withValues(alpha: 0.1)),
      chipTheme: ChipThemeData(
        backgroundColor: AGColors.glassFill,
        side: BorderSide(color: AGColors.glassBorder),
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: const Color(0xCC192A56),
        indicatorColor: accentCyan.withValues(alpha: 0.2),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: Colors.white.withValues(alpha: 0.8)),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(accentCyan),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accentCyan.withValues(alpha: 0.3);
          }
          return Colors.white.withValues(alpha: 0.15);
        }),
      ),
      radioTheme: const RadioThemeData(
        fillColor: WidgetStatePropertyAll(accentCyan),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(color: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AGColors.glassFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(color: AGColors.glassBorder),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xE6192A56),
        contentTextStyle: GoogleFonts.poppins(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xF0192A56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xF0192A56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white.withValues(alpha: 0.7),
        subtitleTextStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentCyan,
      ),
    );
  }
}

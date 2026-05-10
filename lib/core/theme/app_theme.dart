import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // ── Terracotta — couleur principale ─────────────────────
  static const Color primary      = Color(0xFFB5551A);
  static const Color primaryLight = Color(0xFFD47A45);
  static const Color primarySoft  = Color(0xFFFDF2EC);

  // ── Gris foncé / Noir ────────────────────────────────────
  static const Color dark         = Color(0xFF1E293B);
  static const Color darkMedium   = Color(0xFF334155);
  static const Color darkSoft     = Color(0xFFF1F5F9);

  // ── Surfaces & fonds ─────────────────────────────────────
  static const Color surface      = Color(0xFFFFFFFF);
  static const Color background   = Color(0xFFFFFFFF);
  static const Color surfaceCard  = Color(0xFFFAFAF9);
  static const Color surfaceDark  = Color(0xFF1C1F26);

  // ── Bordures ─────────────────────────────────────────────
  static const Color border       = Color(0xFFE8E8E6);
  static const Color borderLight  = Color(0xFFECECEA);

  // ── Textes ───────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFF111827);
  static const Color textSecond   = Color(0xFF6B7280);
  static const Color textLight    = Color(0xFF9CA3AF);
  static const Color textMuted    = Color(0xFFBBBBBB);
  static const Color textDark     = Color(0xFF0F172A);
  static const Color textOnDark   = Color(0xFFD1D5DB);

  // ── Sémantiques ──────────────────────────────────────────
  static const Color success      = Color(0xFF22C55E);
  static const Color successSoft  = Color(0xFFF0FDF4);
  static const Color error        = Color(0xFFEF4444);
  static const Color danger       = Color(0xFFEF4444);
  static const Color warning      = Color(0xFFD97706);
  static const Color info         = Color(0xFF3B82F6);
  static const Color infoBg       = Color(0xFFEFF6FF);

  // ── Rayons ───────────────────────────────────────────────
  static const double radiusXS = 6;
  static const double radiusSM = 8;
  static const double radiusMD = 12;
  static const double radiusLG = 16;
  static const double radiusXL = 24;

  // ── Ombres ───────────────────────────────────────────────
  static List<BoxShadow> get shadowLight => [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 6,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowSM => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMD => [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowOrange => [
    BoxShadow(
      color: primary.withOpacity(0.25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get shadowDark => [
    BoxShadow(
      color: dark.withOpacity(0.20),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // ── ThemeData ─────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: dark,
      surface: surface,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
    ),

    // ── AppBar ───────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: textPrimary,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
    ),

    // ── Buttons ──────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: dark,
        side: const BorderSide(color: dark, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: dark,
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // ── Input ────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textLight,
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: textSecond,
      ),
    ),

    // ── Card ─────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLG),
        side: const BorderSide(color: border, width: 0.5),
      ),
    ),

    // ── BottomNavigationBar ──────────────────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: dark,
      unselectedItemColor: textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    ),

    // ── Chip ─────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: background,
      selectedColor: darkSoft,
      labelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      side: const BorderSide(color: border, width: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSM),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),

    // ── Divider ──────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 0.5,
      space: 1,
    ),

    // ── Slider ───────────────────────────────────────────────
    sliderTheme: const SliderThemeData(
      activeTrackColor: dark,
      inactiveTrackColor: border,
      thumbColor: dark,
      overlayColor: Color(0x1A1E293B),
      trackHeight: 4,
    ),

    // ── ProgressIndicator ────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: border,
    ),

    // ── SnackBar ─────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: dark,
      contentTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      actionTextColor: primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMD),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // ── Dialog ───────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXL),
        side: const BorderSide(color: border, width: 0.5),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: textDark,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecond,
      ),
    ),

    // ── BottomSheet ──────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusXL),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: border,
      dragHandleSize: Size(40, 4),
    ),

    // ── Switch ───────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return textLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        return border;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),

    // ── Checkbox ─────────────────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: border, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXS),
      ),
    ),

    // ── Radio ────────────────────────────────────────────────
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        return textLight;
      }),
    ),

    // ── ListTile ─────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecond,
      ),
      iconColor: textSecond,
      dense: false,
    ),

    // ── TabBar ───────────────────────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: textSecond,
      indicatorColor: primary,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: border,
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ── FloatingActionButton ─────────────────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLG),
      ),
    ),

    // ── TextTheme ────────────────────────────────────────────
    textTheme: const TextTheme(
      displayLarge:   TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: textDark,    letterSpacing: -1),
      displayMedium:  TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textDark,    letterSpacing: -0.5),
      displaySmall:   TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: textDark,    letterSpacing: -0.3),
      headlineLarge:  TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textDark,    letterSpacing: -0.3),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textDark),
      headlineSmall:  TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textDark),
      titleLarge:     TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
      titleMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
      titleSmall:     TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textSecond),
      bodyLarge:      TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: textPrimary),
      bodyMedium:     TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary),
      bodySmall:      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textSecond),
      labelLarge:     TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
      labelMedium:    TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecond),
      labelSmall:     TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textLight),
    ),
  );
}
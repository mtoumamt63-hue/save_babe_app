import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';

/// ThemeData complet pour SaveBabe (Light + Dark)
abstract final class AppTheme {
  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    background: AppColors.background,
    card: AppColors.card,
    foreground: AppColors.foreground,
    mutedFg: AppColors.mutedForeground,
    muted: AppColors.muted,
    primary: AppColors.primary,
    primaryFg: AppColors.primaryForeground,
    secondary: AppColors.secondary,
    secondaryFg: AppColors.secondaryForeground,
    accent: AppColors.accent,
    accentFg: AppColors.accentForeground,
    border: AppColors.border,
    input: AppColors.input,
    ring: AppColors.ring,
    destructive: AppColors.destructive,
    destructiveFg: AppColors.destructiveForeground,
    systemUiStyle: SystemUiOverlayStyle.dark,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    background: AppColors.backgroundDark,
    card: AppColors.cardDark,
    foreground: AppColors.foregroundDark,
    mutedFg: AppColors.mutedForegroundDark,
    muted: AppColors.mutedDark,
    primary: AppColors.primaryDark,
    primaryFg: AppColors.primaryForegroundDark,
    secondary: AppColors.secondaryDark,
    secondaryFg: AppColors.secondaryForegroundDark,
    accent: AppColors.accentDark,
    accentFg: AppColors.accentForegroundDark,
    border: AppColors.borderDark,
    input: AppColors.inputDark,
    ring: AppColors.ringDark,
    destructive: AppColors.destructiveDark,
    destructiveFg: AppColors.destructiveForegroundDark,
    systemUiStyle: SystemUiOverlayStyle.light,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color card,
    required Color foreground,
    required Color mutedFg,
    required Color muted,
    required Color primary,
    required Color primaryFg,
    required Color secondary,
    required Color secondaryFg,
    required Color accent,
    required Color accentFg,
    required Color border,
    required Color input,
    required Color ring,
    required Color destructive,
    required Color destructiveFg,
    required SystemUiOverlayStyle systemUiStyle,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: primaryFg,
      primaryContainer: secondary,
      onPrimaryContainer: secondaryFg,
      secondary: AppColors.pink,
      onSecondary: AppColors.primaryForeground,
      secondaryContainer: accent,
      onSecondaryContainer: accentFg,
      tertiary: AppColors.success,
      onTertiary: AppColors.primaryForeground,
      tertiaryContainer: AppColors.successSoft,
      onTertiaryContainer: AppColors.success,
      error: destructive,
      onError: destructiveFg,
      surface: background,
      onSurface: foreground,
      surfaceContainerHighest: card,
      onSurfaceVariant: mutedFg,
      outline: border,
      outlineVariant: border.withAlpha(120),
      shadow: AppColors.cardShadow,
      scrim: Colors.black54,
      inverseSurface: foreground,
      onInverseSurface: background,
      inversePrimary: secondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Figtree',
      textTheme: AppTypography.textTheme.apply(
        bodyColor: foreground,
        displayColor: foreground,
      ),

      // ── AppBar ─────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: systemUiStyle,
        titleTextStyle: AppTypography.displayS.copyWith(color: foreground),
      ),

      // ── Card ───────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius3xl),
          side: BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── ElevatedButton (= variante primary) ────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryFg,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: const StadiumBorder(),
          textStyle: AppTypography.button,
          shadowColor: Colors.transparent,
        ),
      ),

      // ── OutlinedButton ─────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 2),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: const StadiumBorder(),
          textStyle: AppTypography.button,
        ),
      ),

      // ── TextButton (= variante ghost) ──────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          textStyle: AppTypography.button,
        ),
      ),

      // ── InputDecoration ────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
          borderSide: BorderSide(color: ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
          borderSide: BorderSide(color: destructive, width: 1.5),
        ),
        labelStyle: AppTypography.labelM.copyWith(color: mutedFg),
        hintStyle: AppTypography.bodyM.copyWith(color: mutedFg),
      ),

      // ── BottomNavigationBar ────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: primary,
        unselectedItemColor: mutedFg,
        selectedLabelStyle: AppTypography.labelXs,
        unselectedLabelStyle: AppTypography.labelXs,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // ── Divider ────────────────────────────────────────────
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 0),

      // ── Switch ─────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryFg;
          return card;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return mutedFg.withAlpha(80);
        }),
      ),

      // ── SnackBar (toast) ───────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: foreground,
        contentTextStyle: AppTypography.bodyM.copyWith(color: background),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typographie SaveBabe via GoogleFonts
/// - Figtree : police de corps (body, labels, captions)
/// - Outfit  : police display (titres, chiffres)
abstract final class AppTypography {
  // ── Display (Outfit) ───────────────────────────────────────
  static TextStyle displayXl = GoogleFonts.outfit(
    fontSize: 64,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.5,
  );
  static TextStyle displayL = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  static TextStyle displayM = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );
  static TextStyle displayS = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  // ── Body (Figtree) ─────────────────────────────────────────
  static TextStyle bodyL = GoogleFonts.figtree(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyM = GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyS = GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyXs = GoogleFonts.figtree(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  // ── Labels / Semibold (Figtree) ────────────────────────────
  static TextStyle labelL = GoogleFonts.figtree(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle labelM = GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static TextStyle labelS = GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static TextStyle labelXs = GoogleFonts.figtree(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  // ── Bouton ─────────────────────────────────────────────────
  static TextStyle button = GoogleFonts.figtree(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // ── TextTheme complet ──────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayXl,
    displayMedium: displayL,
    displaySmall: displayM,
    headlineLarge: displayL,
    headlineMedium: displayM,
    headlineSmall: displayS,
    titleLarge: labelL,
    titleMedium: labelM,
    titleSmall: labelS,
    bodyLarge: bodyL,
    bodyMedium: bodyM,
    bodySmall: bodyS,
    labelLarge: button,
    labelMedium: labelM,
    labelSmall: labelXs,
  );
}

/// Dimensions, espacements et rayons de bordures SaveBabe
abstract final class AppDimensions {
  // ── Radius ─────────────────────────────────────────────────
  static const double radiusSm = 12.0; // rounded-sm (radius - 4px)
  static const double radiusMd = 14.0; // rounded-md (radius - 2px)
  static const double radiusLg = 16.0; // rounded-lg (= radius base)
  static const double radiusXl = 20.0; // rounded-xl
  static const double radius2xl = 24.0; // rounded-2xl (radius + 8px)
  static const double radius3xl = 28.0; // rounded-3xl (radius + 12px)
  static const double radius4xl = 32.0; // rounded-4xl (radius + 16px)
  static const double radiusFull = 999.0; // rounded-full

  // ── Padding & Espacements ──────────────────────────────────
  static const double pXs = 4.0;
  static const double pSm = 8.0;
  static const double pMd = 12.0;
  static const double pLg = 16.0;
  static const double pXl = 20.0;
  static const double p2xl = 24.0;
  static const double p3xl = 32.0;

  // ── Padding de la page ─────────────────────────────────────
  static const double pageHorizontal = 20.0; // px-5 = 20px
  static const double pageTopPadding = 16.0; // pt-4 = 16px

  // ── Espacements courants ───────────────────────────────────
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 20.0;
  static const double space2xl = 24.0;
  static const double space3xl = 32.0;

  // ── Tailles des icônes ─────────────────────────────────────
  static const double iconXs = 14.0; // h-3.5 w-3.5
  static const double iconSm = 16.0; // h-4 w-4
  static const double iconMd = 20.0; // h-5 w-5
  static const double iconLg = 24.0; // h-6 w-6
  static const double iconXl = 28.0; // h-7 w-7
  static const double icon2xl = 40.0; // h-10 w-10
  static const double icon3xl = 56.0; // h-14 w-14

  // ── Boutons ────────────────────────────────────────────────
  static const double buttonHeight = 52.0; // py-3.5 * 2 + fontSize
  static const double buttonHeightSm = 36.0; // h-9
  static const double buttonHeightXs = 28.0; // h-7

  // ── BottomNavBar ───────────────────────────────────────────
  static const double tabBarHeight = 60.0;
  static const double tabBarContentPadding = 10.0;

  // ── Card ───────────────────────────────────────────────────
  static const double cardPadding = 20.0; // p-5

  // ── Max width (mobile design max-w-md = 448px) ────────────
  static const double maxWidth = 448.0;
}

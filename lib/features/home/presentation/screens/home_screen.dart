import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../pregnancy_tracker/data/pregnancy_dataset.dart';
import '../../../pregnancy_tracker/domain/models/pregnancy_week_info.dart';

// ────────────────────────────────────────────────────────────────
// Baby size data per week (approx. cm & grams)
// ────────────────────────────────────────────────────────────────
const _babyCm = <int, double>{
  1: 0, 2: 0, 3: 0, 4: 0.1, 5: 0.2, 6: 0.4, 7: 1.0, 8: 1.6, 9: 2.3,
  10: 3.1, 11: 4.1, 12: 5.4, 13: 6.7, 14: 8.7, 15: 10.1, 16: 11.6,
  17: 13.0, 18: 14.2, 19: 15.3, 20: 16.4, 21: 26.7, 22: 27.8, 23: 28.9,
  24: 30.0, 25: 34.6, 26: 35.6, 27: 36.6, 28: 37.6, 29: 38.6, 30: 39.9,
  31: 41.1, 32: 42.4, 33: 43.7, 34: 45.0, 35: 46.2, 36: 47.4, 37: 48.6,
  38: 49.8, 39: 50.7, 40: 51.2, 41: 51.7,
};

const _babyGrams = <int, double>{
  1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 1, 8: 1, 9: 2, 10: 4,
  11: 7, 12: 14, 13: 23, 14: 43, 15: 70, 16: 100, 17: 140, 18: 190,
  19: 240, 20: 300, 21: 360, 22: 430, 23: 500, 24: 600, 25: 660,
  26: 760, 27: 875, 28: 1005, 29: 1153, 30: 1319, 31: 1502, 32: 1702,
  33: 1918, 34: 2146, 35: 2383, 36: 2622, 37: 2859, 38: 3083,
  39: 3288, 40: 3462, 41: 3600,
};

// ────────────────────────────────────────────────────────────────
// HomeScreen
// ────────────────────────────────────────────────────────────────
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final displayName = user.name.isNotEmpty ? user.name : 'Grâce';
    final age = DateFormatter.gestationalAge(user.lmp);
    final weeks = age?.weeks ?? DateFormatter.weeksOf(user.lmp);
    final days = age?.days ?? 0;
    final safeWeek = weeks.clamp(1, 41).toInt();
    final weekInfo = pregnancyDataset.firstWhere((e) => e.week == safeWeek);

    final cm = _babyCm[safeWeek] ?? 0;
    final grams = _babyGrams[safeWeek] ?? 0;

    // ── Palette officielle SaveBabe ──────────────────────────
    final peachMid = isDark ? AppColors.secondaryDark : AppColors.secondary;
    final peachDeep = isDark ? AppColors.primaryDark : AppColors.primary;
    final roseAccent = isDark ? AppColors.pinkDark : AppColors.pink;

    final bgTop = isDark ? AppColors.backgroundDark : AppColors.background;
    final bgBot = isDark ? AppColors.backgroundDark : AppColors.background;

    final now = DateTime.now();

    return Scaffold(
      backgroundColor: bgBot,
      body: CustomScrollView(
        slivers: [
          // ── Sticky hero header ────────────────────────────────
          SliverToBoxAdapter(
            child: _HeroHeader(
              isDark: isDark,
              bgTop: bgTop,
              peachMid: peachMid,
              peachDeep: peachDeep,
              roseAccent: roseAccent,
              displayName: displayName,
              now: now,
              weeks: safeWeek,
              days: days,
              pulse: _pulse,
              weekInfo: weekInfo,
            ),
          ),

          // ── Body content ──────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Baby size card
                if (cm > 0 || grams > 0) ...[
                  const SizedBox(height: 20),
                  _BabySizeCard(
                    isDark: isDark,
                    week: safeWeek,
                    cm: cm,
                    grams: grams,
                    roseAccent: roseAccent,
                    peachMid: peachMid,
                  ),
                ],
                const SizedBox(height: 24),

                // Section: Daily insights
                _SectionTitle(
                  label: 'Mes insights du jour',
                  isDark: isDark,
                  onMore: () => context.push('/app/tracking'),
                ),
                const SizedBox(height: 14),
                _InsightGrid(
                  isDark: isDark,
                  roseAccent: roseAccent,
                  peachDeep: peachDeep,
                  tip: weekInfo.tip,
                  development: weekInfo.development,
                  motherBody: weekInfo.motherBody,
                  onChat: () => context.go('/app/ai'),
                  onAppointment: () => context.push('/appointments'),
                  onImport: () => context.push('/import'),
                  onInvite: () => context.push('/invite'),
                ),
                const SizedBox(height: 24),

                // Section: Quick actions
                _SectionTitle(label: 'Actions rapides', isDark: isDark),
                const SizedBox(height: 14),
                _QuickActions(
                  isDark: isDark,
                  roseAccent: roseAccent,
                  peachDeep: peachDeep,
                  onTracking: () => context.push('/app/tracking'),
                  onBaby: () => context.push(
                    user.baby != null ? '/app/baby' : '/app/baby/create',
                  ),
                  onEmergency: () => context.push('/emergency'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Hero Header (warm gradient + circular week + mini calendar)
// ────────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.isDark,
    required this.bgTop,
    required this.peachMid,
    required this.peachDeep,
    required this.roseAccent,
    required this.displayName,
    required this.now,
    required this.weeks,
    required this.days,
    required this.pulse,
    required this.weekInfo,
  });

  final bool isDark;
  final Color bgTop, peachMid, peachDeep, roseAccent;
  final String displayName;
  final DateTime now;
  final int weeks, days;
  final AnimationController pulse;
  final PregnancyWeekInfo weekInfo;

  @override
  Widget build(BuildContext context) {
    final greeting = _greeting();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.backgroundDark, AppColors.cardDark]
              : [AppColors.background, AppColors.card],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  // Hamburger / Menu icon
                  Icon(
                    Icons.menu_rounded,
                    color: isDark ? AppColors.foregroundDark : AppColors.foreground,
                    size: 26,
                  ),
                  const Spacer(),
                  // Heart + Bell
                  GestureDetector(
                    onTap: () => context.push('/emergency'),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      color: roseAccent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          color: isDark
                              ? AppColors.foregroundDark
                              : AppColors.foreground,
                          size: 24,
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: roseAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Greeting ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.mutedForegroundDark
                          : AppColors.mutedForeground,
                    ),
                  ),
                  Text(
                    '$displayName !',
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.foregroundDark : AppColors.foreground,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Mini horizontal calendar ──────────────────────
            _MiniCalendar(
              isDark: isDark,
              now: now,
              weeks: weeks,
              roseAccent: roseAccent,
              peachMid: peachMid,
            ),
            const SizedBox(height: 20),

            // ── Hero circle ───────────────────────────────────
            _WeekHeroCircle(
              isDark: isDark,
              weeks: weeks,
              days: days,
              pulse: pulse,
              peachMid: peachMid,
              peachDeep: peachDeep,
              roseAccent: roseAccent,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final h = now.hour;
    if (h < 12) return 'Bonjour,';
    if (h < 18) return 'Bon après-midi,';
    return 'Bonsoir,';
  }
}

// ────────────────────────────────────────────────────────────────
// Mini Horizontal Calendar
// ────────────────────────────────────────────────────────────────
class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar({
    required this.isDark,
    required this.now,
    required this.weeks,
    required this.roseAccent,
    required this.peachMid,
  });

  final bool isDark;
  final DateTime now;
  final int weeks;
  final Color roseAccent, peachMid;

  static const _days = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];

  @override
  Widget build(BuildContext context) {
    // Show a 7-day window centred on today
    final start = now.subtract(Duration(days: now.weekday % 7));
    final dateFmt =
        '${_dayName(now.weekday)}, ${now.day} ${_monthName(now.month)} ${now.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFmt,
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.mutedForegroundDark
                      : AppColors.mutedForeground,
                ),
              ),
              // Week badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? roseAccent.withValues(alpha: 0.2)
                      : peachMid,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 14,
                      color: isDark ? roseAccent : AppColors.secondaryForeground,
                    ),
                    Text(
                      'Semaine $weeks',
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? roseAccent
                            : AppColors.secondaryForeground,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 14,
                      color: isDark ? roseAccent : AppColors.secondaryForeground,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final d = start.add(Duration(days: i));
              final isToday = d.day == now.day &&
                  d.month == now.month &&
                  d.year == now.year;
              return _DayDot(
                label: _days[i],
                number: d.day,
                isToday: isToday,
                isDark: isDark,
                roseAccent: roseAccent,
              );
            }),
          ),
        ],
      ),
    );
  }

  String _dayName(int wd) {
    const n = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return n[(wd - 1) % 7];
  }

  String _monthName(int m) {
    const n = [
      'jan', 'fév', 'mar', 'avr', 'mai', 'juin',
      'juil', 'août', 'sep', 'oct', 'nov', 'déc'
    ];
    return n[m - 1];
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.label,
    required this.number,
    required this.isToday,
    required this.isDark,
    required this.roseAccent,
  });

  final String label;
  final int number;
  final bool isToday, isDark;
  final Color roseAccent;

  @override
  Widget build(BuildContext context) {
    final textColor = isToday
        ? Colors.white
        : isDark
            ? AppColors.mutedForegroundDark
            : AppColors.mutedForeground;
    final numColor = isToday
        ? Colors.white
        : isDark
            ? AppColors.foregroundDark
            : AppColors.foreground;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Figtree',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isToday ? roseAccent : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 13,
              fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
              color: numColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Hero Circle (week visualization)
// ────────────────────────────────────────────────────────────────
class _WeekHeroCircle extends StatelessWidget {
  const _WeekHeroCircle({
    required this.isDark,
    required this.weeks,
    required this.days,
    required this.pulse,
    required this.peachMid,
    required this.peachDeep,
    required this.roseAccent,
  });

  final bool isDark;
  final int weeks, days;
  final AnimationController pulse;
  final Color peachMid, peachDeep, roseAccent;

  String _get3dAsset() {
    if (weeks <= 12) {
      return 'assets/pregnancy/3d/fetus_week_08.jpg';
    } else if (weeks <= 26) {
      return 'assets/pregnancy/3d/fetus_week_20.jpg';
    } else {
      return 'assets/pregnancy/3d/fetus_week_36.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (weeks / 41).clamp(0.0, 1.0);
    final assetImage = _get3dAsset();

    return GestureDetector(
      onTap: () => context.push('/baby-anatomy?week=$weeks'),
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, _) {
          final scale = 1.0 + pulse.value * 0.025;
          return Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer pulsating halo
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isDark
                              ? [
                                  roseAccent.withValues(alpha: 0.22),
                                  Colors.transparent,
                                ]
                              : [
                                  peachMid.withValues(alpha: 0.85),
                                  peachMid.withValues(alpha: 0.0),
                                ],
                        ),
                      ),
                    ),
                  ),

                  // Progress arc
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: _ArcPainter(
                      progress: progress,
                      color: roseAccent,
                      trackColor: isDark
                          ? Colors.white10
                          : peachMid.withValues(alpha: 0.6),
                    ),
                  ),

                  // 3D Realistic Fetus Render Circle
                  Hero(
                    tag: 'baby_3d_render',
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: roseAccent.withValues(alpha: 0.3),
                            blurRadius: 28,
                            spreadRadius: 3,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(assetImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Bottom Interactive Pill Button
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.card,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: roseAccent.withValues(alpha: 0.6),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: roseAccent.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.view_in_ar_rounded,
                            size: 15,
                            color: AppColors.pink,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$weeks sem. • Anatomie 3D',
                            style: const TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.pink,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 14,
                            color: AppColors.pink,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color, trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - 6;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    const start = -math.pi / 2;
    const full = 2 * math.pi;

    final track = Paint()
      ..color = trackColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, start, full, false, track);

    final arc = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, start, full * progress, false, arc);
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress || old.color != color;
}

// ────────────────────────────────────────────────────────────────
// Baby Size Card
// ────────────────────────────────────────────────────────────────
class _BabySizeCard extends StatelessWidget {
  const _BabySizeCard({
    required this.isDark,
    required this.week,
    required this.cm,
    required this.grams,
    required this.roseAccent,
    required this.peachMid,
  });

  final bool isDark;
  final int week;
  final double cm, grams;
  final Color roseAccent, peachMid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.cardDark, AppColors.backgroundDark]
              : [AppColors.secondary.withValues(alpha: 0.5), AppColors.card],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.borderDark
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // Stats column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Votre bébé à la Semaine $week',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 14),
                _StatRow(
                  value: '${cm.toStringAsFixed(1)} cm',
                  label: 'Taille approximative',
                  isDark: isDark,
                  roseAccent: roseAccent,
                ),
                const SizedBox(height: 10),
                _StatRow(
                  value: grams >= 1000
                      ? '${(grams / 1000).toStringAsFixed(2)} kg'
                      : '${grams.toStringAsFixed(0)} g',
                  label: 'Poids approximatif',
                  isDark: isDark,
                  roseAccent: roseAccent,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 3D Visual thumbnail
          GestureDetector(
            onTap: () => context.push('/baby-anatomy?week=$week'),
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: roseAccent.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: roseAccent.withValues(alpha: 0.2),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(
                    'assets/pregnancy/weekly/week_${week.clamp(1, 40).toString().padLeft(2, '0')}.png',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.value,
    required this.label,
    required this.isDark,
    required this.roseAccent,
  });

  final String value, label;
  final bool isDark;
  final Color roseAccent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Figtree',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.foregroundDark : AppColors.foreground,
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 11,
              color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Section title
// ────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.label,
    required this.isDark,
    this.onMore,
  });

  final String label;
  final bool isDark;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Figtree',
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.foregroundDark : AppColors.foreground,
          ),
        ),
        if (onMore != null)
          GestureDetector(
            onTap: onMore,
            child: Text(
              'Voir plus',
              style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.pinkDark : AppColors.pink,
              ),
            ),
          ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Insight Grid (2×2 card grid)
// ────────────────────────────────────────────────────────────────
class _InsightGrid extends StatelessWidget {
  const _InsightGrid({
    required this.isDark,
    required this.roseAccent,
    required this.peachDeep,
    required this.tip,
    required this.development,
    required this.motherBody,
    required this.onChat,
    required this.onAppointment,
    required this.onImport,
    required this.onInvite,
  });

  final bool isDark;
  final Color roseAccent, peachDeep;
  final String tip, development, motherBody;
  final VoidCallback onChat, onAppointment, onImport, onInvite;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top row: tip card + symptom log
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _InsightCard(
                isDark: isDark,
                icon: Icons.tips_and_updates_outlined,
                iconColor: roseAccent,
                iconBg: roseAccent.withValues(alpha: isDark ? 0.2 : 0.12),
                title: 'Conseil semaine',
                body: tip,
                onTap: onChat,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: _InsightCard(
                isDark: isDark,
                icon: Icons.add_circle_outline_rounded,
                iconColor: const Color(0xFF3DAB6A),
                iconBg: const Color(0xFF3DAB6A).withValues(alpha: 0.12),
                title: 'Noter symptômes',
                body: '',
                onTap: onChat,
                isMini: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Bottom row: baby dev + appointment
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _InsightCard(
                isDark: isDark,
                icon: Icons.calendar_month_outlined,
                iconColor: const Color(0xFF7B5EA7),
                iconBg: const Color(0xFF7B5EA7).withValues(alpha: 0.12),
                title: 'Rendez-vous',
                body: '',
                onTap: onAppointment,
                isMini: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: _InsightCard(
                isDark: isDark,
                icon: Icons.child_care_outlined,
                iconColor: peachDeep,
                iconBg: peachDeep.withValues(alpha: 0.15),
                title: 'Développement bébé',
                body: development,
                onTap: onImport,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
    required this.onTap,
    this.isMini = false,
  });

  final bool isDark, isMini;
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.foregroundDark : AppColors.foreground,
              ),
            ),
            if (body.isNotEmpty && !isMini) ...[
              const SizedBox(height: 6),
              Text(
                body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 11,
                  height: 1.4,
                  color: isDark
                      ? AppColors.mutedForegroundDark
                      : AppColors.mutedForeground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Quick Actions row
// ────────────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.isDark,
    required this.roseAccent,
    required this.peachDeep,
    required this.onTracking,
    required this.onBaby,
    required this.onEmergency,
  });

  final bool isDark;
  final Color roseAccent, peachDeep;
  final VoidCallback onTracking, onBaby, onEmergency;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionPill(
          isDark: isDark,
          icon: Icons.favorite_rounded,
          label: 'Suivi\ngrossesse',
          color: roseAccent,
          onTap: onTracking,
        ),
        const SizedBox(width: 10),
        _ActionPill(
          isDark: isDark,
          icon: Icons.child_care_rounded,
          label: 'Mon\nbébé',
          color: peachDeep,
          onTap: onBaby,
        ),
        const SizedBox(width: 10),
        _ActionPill(
          isDark: isDark,
          icon: Icons.phone_rounded,
          label: 'Urgence',
          color: const Color(0xFFD94F2A),
          onTap: onEmergency,
        ),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.18 : 0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.foregroundDark : AppColors.foreground,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

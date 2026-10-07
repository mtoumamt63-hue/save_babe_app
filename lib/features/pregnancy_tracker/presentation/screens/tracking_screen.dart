import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/pregnancy_dataset.dart';
import '../../domain/models/country_pack.dart';
import '../../domain/models/pregnancy_week_info.dart';
import '../../domain/services/pregnancy_calculation_service.dart';
import '../widgets/danger_signs_banner.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  static const _service = PregnancyCalculationService();

  final ScrollController _weekScrollController = ScrollController();
  int? _selectedWeekOverride;
  int _selectedTab = 0; // 0: Bébé & Moi, 1: Santé & CPN, 2: Nutrition & Soins

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnCurrentWeek();
    });
  }

  @override
  void dispose() {
    _weekScrollController.dispose();
    super.dispose();
  }

  CountryPack _packFor(String country) {
    final normalized = country.toLowerCase();
    if (normalized.contains('rdc') ||
        (normalized.contains('congo') && normalized.contains('démocratique'))) {
      return rdcPack;
    }
    const malariaCountries = [
      'côte d’ivoire',
      "côte d'ivoire",
      'mali',
      'bénin',
      'benin',
      'cameroun',
      'cameroon',
      'congo',
    ];
    if (malariaCountries.any(normalized.contains)) {
      return subSaharanMalariaGenericPack;
    }
    return whoGenericPack;
  }

  void _centerOnCurrentWeek() {
    if (!_weekScrollController.hasClients) return;
    final user = ref.read(appUserStateProvider);
    final lmp = DateFormatter.parseLmp(user.lmp);
    final effectiveLmp = lmp ?? DateTime.now().subtract(const Duration(days: 20 * 7));
    final currentWeek = _service.ageAt(effectiveLmp).weeks.clamp(1, 41).toInt();
    final week = _selectedWeekOverride ?? currentWeek;

    final offset = ((week - 1) * 66.0 - 130.0).clamp(
      0.0,
      _weekScrollController.position.maxScrollExtent,
    );
    _weekScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final parsedLmp = DateFormatter.parseLmp(user.lmp);
    final hasCustomLmp = parsedLmp != null;

    // Si pas de DDR renseignée, on utilise la semaine 20 par défaut
    final effectiveLmp = parsedLmp ?? DateTime.now().subtract(const Duration(days: 20 * 7));

    final age = _service.ageAt(effectiveLmp);
    final currentGestationalWeek = age.weeks.clamp(1, 41).toInt();
    final selectedWeek = (_selectedWeekOverride ?? currentGestationalWeek).clamp(1, 41).toInt();

    final info = pregnancyDataset.firstWhere(
      (e) => e.week == selectedWeek,
      orElse: () => pregnancyDataset.last,
    );

    final dueDateObj = _service.dueDate(effectiveLmp);
    final dueFormatted = DateFormatter.formatFR(dueDateObj);
    final daysRemaining = dueDateObj.difference(DateTime.now()).inDays;
    final progress = (selectedWeek / 40.0).clamp(0.0, 1.0);
    final trimester = _service.trimesterOf(selectedWeek);
    final pack = _packFor(user.country);
    final nextContact = _service.nextContact(effectiveLmp, pack);
    final contacts = _service.ancSchedule(effectiveLmp, pack);

    final latestMeasures = <String, Measure>{};
    for (final measure in user.measures) {
      latestMeasures.putIfAbsent(measure.kind, () => measure);
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF13172E) : const Color(0xFFF4F6FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. EN-TÊTE HAUT DE GAMME AVEC TITRE & STATUT DPA ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Suivi de Grossesse',
                                style: TextStyle(
                                  fontFamily: 'Figtree',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1B2349),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'T$trimester',
                                  style: TextStyle(
                                    fontFamily: 'Figtree',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? AppColors.primaryDark
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            hasCustomLmp
                                ? (daysRemaining > 0
                                    ? 'DPA prévue le $dueFormatted (J-$daysRemaining)'
                                    : 'DPA imminente ($dueFormatted)')
                                : 'Mode découverte · Semaine $selectedWeek',
                            style: TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 13,
                              color: isDark
                                  ? const Color(0xFF9EAAEC)
                                  : const Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => context.push('/emergency'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pink.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.pink.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_hospital_rounded,
                              size: 16,
                              color: AppColors.pink,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Urgence',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (!hasCustomLmp)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Renseignez votre date des règles dans votre profil pour un calcul sur-mesure.',
                            style: TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 11,
                              color: isDark ? Colors.white70 : const Color(0xFF374151),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => context.push('/app/profile'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Régler',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── 2. CARROUSEL HORIZONTAL DES SEMAINES (SA 1 À 41) ────
              SizedBox(
                height: 64,
                child: ListView.separated(
                  controller: _weekScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  scrollDirection: Axis.horizontal,
                  itemCount: 41,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final weekNum = index + 1;
                    final isSelected = weekNum == selectedWeek;
                    final isRealCurrent = weekNum == currentGestationalWeek;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedWeekOverride = weekNum;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 58,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? const Color(0xFF1E2448)
                                  : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isRealCurrent
                                    ? AppColors.pink
                                    : (isDark
                                        ? const Color(0xFF2C3464)
                                        : const Color(0xFFE2E7F5))),
                            width: isRealCurrent || isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SA',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.85)
                                    : (isDark
                                        ? const Color(0xFF8E9BBF)
                                        : const Color(0xFF808B9F)),
                              ),
                            ),
                            Text(
                              '$weekNum',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white
                                        : const Color(0xFF1F2937)),
                              ),
                            ),
                            if (isRealCurrent && !isSelected)
                              Container(
                                width: 4,
                                height: 4,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: const BoxDecoration(
                                  color: AppColors.pink,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── 3. HERO CARD : L'ÉCRIN DU BÉBÉ AVEC IMAGE HEBDOMADAIRE ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: _HeroBabyCard(
                  week: selectedWeek,
                  isRealCurrent: selectedWeek == currentGestationalWeek,
                  info: info,
                  progress: progress,
                  trimester: trimester,
                  isDark: isDark,
                  onResetToCurrent: () {
                    setState(() {
                      _selectedWeekOverride = null;
                    });
                    _centerOnCurrentWeek();
                  },
                  onOpen3dAnatomy: () =>
                      context.push('/baby-anatomy?week=$selectedWeek'),
                ),
              ),

              // ── 4. SÉLECTEUR D'ONGLETS SEGMENTÉS HAUT DE GAMME ──────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2448) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2E3764)
                          : const Color(0xFFE3E8F6),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(0, 'Bébé & Moi', isDark),
                      _buildTabButton(1, 'Santé & CPN', isDark),
                      _buildTabButton(2, 'Nutrition & Soins', isDark),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── 5. CONTENU DE L'ONGLET ACTIF ────────────
              if (_selectedTab == 0)
                _BabyAndMomSection(
                  week: selectedWeek,
                  info: info,
                  isDark: isDark,
                )
              else if (_selectedTab == 1)
                _HealthAndAncSection(
                  nextContact: nextContact,
                  contacts: contacts,
                  user: user,
                  latestMeasures: latestMeasures,
                  isDark: isDark,
                )
              else
                _NutritionAndGuidesSection(
                  trimester: trimester,
                  selectedWeek: selectedWeek,
                  isDark: isDark,
                ),

              const SizedBox(height: 20),

              // ── 6. BANNIÈRE SIGNES DE DANGER (EN FIN DE PAGE) ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DangerSignsBanner(
                  onOpenSigns: () => context.push('/danger-signs'),
                  onEmergency: () => context.push('/emergency'),
                  onNotifyTrusted: () => context.push('/invite'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title, bool isDark) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? const Color(0xFF909FC6)
                      : const Color(0xFF6B7280)),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBabyCard extends StatelessWidget {
  final int week;
  final bool isRealCurrent;
  final PregnancyWeekInfo info;
  final double progress;
  final int trimester;
  final bool isDark;
  final VoidCallback onResetToCurrent;
  final VoidCallback onOpen3dAnatomy;

  const _HeroBabyCard({
    required this.week,
    required this.isRealCurrent,
    required this.info,
    required this.progress,
    required this.trimester,
    required this.isDark,
    required this.onResetToCurrent,
    required this.onOpen3dAnatomy,
  });

  String _formatWeekAsset(int w) {
    final clamped = w.clamp(1, 40);
    return 'assets/pregnancy/weekly/week_${clamped.toString().padLeft(2, '0')}.png';
  }

  @override
  Widget build(BuildContext context) {
    final imageAsset = _formatWeekAsset(week);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
                  Color(0xFF212852),
                  Color(0xFF191F44),
                ]
              : const [
                  Colors.white,
                  Color(0xFFF7F9FF),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isDark
              ? const Color(0xFF333E75)
              : const Color(0xFFE5ECFB),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Semaine $week de grossesse',
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.primaryDark
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    if (!isRealCurrent) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onResetToCurrent,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pink.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                size: 12,
                                color: AppColors.pink,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Aujourd’hui',
                                style: TextStyle(
                                  fontFamily: 'Figtree',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.pink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                InkWell(
                  onTap: onOpen3dAnatomy,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2B3466)
                          : const Color(0xFFEFF3FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.view_in_ar_rounded,
                          size: 14,
                          color: isDark
                              ? AppColors.primaryDark
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Anatomie 3D',
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.primaryDark
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF161B36)
                        : const Color(0xFFF3F6FD),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF384379)
                          : const Color(0xFFE2E9FB),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          imageAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.child_care_rounded,
                                size: 54,
                                color: AppColors.primary.withValues(alpha: 0.5),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'SA $week',
                              style: const TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Taille du bébé',
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF9EAAEC)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        info.babySize,
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E2A5E),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.timelapse_rounded,
                            size: 14,
                            color: AppColors.pink,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Semaine $week sur 40 (Trimestre $trimester)',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFB0BDED)
                                    : const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 7,
                          value: progress,
                          backgroundColor: isDark
                              ? const Color(0xFF2E3766)
                              : const Color(0xFFE5ECFB),
                          valueColor: AlwaysStoppedAnimation(
                            week <= 13
                                ? const Color(0xFF3B57D4)
                                : (week <= 27
                                    ? const Color(0xFFE0557F)
                                    : const Color(0xFF10B981)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BabyAndMomSection extends StatelessWidget {
  final int week;
  final PregnancyWeekInfo info;
  final bool isDark;

  const _BabyAndMomSection({
    required this.week,
    required this.info,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PremiumSectionCard(
            isDark: isDark,
            icon: Icons.child_care_rounded,
            iconColor: const Color(0xFF3B57D4),
            tag: 'Semaine $week',
            title: 'Développement du bébé',
            content: info.development,
          ),
          const SizedBox(height: 14),
          _PremiumSectionCard(
            isDark: isDark,
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFE0557F),
            tag: 'Symptômes & Changements',
            title: 'Votre corps cette semaine',
            content: info.motherBody,
          ),
          const SizedBox(height: 14),
          _PremiumSectionCard(
            isDark: isDark,
            icon: Icons.tips_and_updates_rounded,
            iconColor: const Color(0xFFF59E0B),
            tag: 'Recommandation médicale',
            title: 'Conseil de la sage-femme',
            content: info.tip,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1B203E)
                  : const Color(0xFFEEF2FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: isDark ? const Color(0xFF8E9DC6) : const Color(0xFF6B7280),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Les tailles et poids sont des moyennes statistiques. Seule l’échographie réalisée par un soignant fait foi.',
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 11,
                      color: isDark ? const Color(0xFF8E9DC6) : const Color(0xFF6B7280),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthAndAncSection extends StatelessWidget {
  final AncContact? nextContact;
  final List<AncContact> contacts;
  final AppUserState user;
  final Map<String, Measure> latestMeasures;
  final bool isDark;

  const _HealthAndAncSection({
    required this.nextContact,
    required this.contacts,
    required this.user,
    required this.latestMeasures,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nextContact != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E254C) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.event_available_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prochain contact CPN',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFF9EAAEC)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              nextContact!.label,
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1B2349),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          DateFormatter.formatFR(nextContact!.date),
                          style: const TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (nextContact!.keyPoints.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Text(
                      'Objectifs prioritaires :',
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFF9EAAEC)
                            : const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nextContact!.keyPoints.join(' • '),
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFFB0BDED)
                            : const Color(0xFF4B5563),
                        height: 1.35,
                      ),
                    ),
                  ],
                  if (nextContact!.iptpDose) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            size: 16,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Zone palustre : Dose de TPIg-SP prévue selon le protocole soignant.',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Indicateurs de santé',
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1B2349),
                ),
              ),
              InkWell(
                onTap: () => context.push('/app/tracking/metrics'),
                child: const Text(
                  'Voir l’historique →',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _VitalMetricCard(
                  label: 'Poids',
                  value: latestMeasures['poids']?.value ?? '--',
                  unit: 'kg',
                  icon: Icons.monitor_weight_rounded,
                  iconColor: const Color(0xFF3B57D4),
                  isDark: isDark,
                  onTap: () => context.push('/app/tracking/metrics'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VitalMetricCard(
                  label: 'Tension',
                  value: latestMeasures['tension']?.value ?? '--',
                  unit: 'mmHg',
                  icon: Icons.speed_rounded,
                  iconColor: const Color(0xFFE0557F),
                  isDark: isDark,
                  onTap: () => context.push('/app/tracking/metrics'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VitalMetricCard(
                  label: 'Glycémie',
                  value: latestMeasures['glycemie']?.value ?? '--',
                  unit: 'mg/dL',
                  icon: Icons.bloodtype_rounded,
                  iconColor: const Color(0xFF10B981),
                  isDark: isDark,
                  onTap: () => context.push('/app/tracking/metrics'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Calendrier des consultations prénatales',
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF1B2349),
            ),
          ),
          const SizedBox(height: 10),

          ...contacts.map((contact) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final isPast = contact.date.isBefore(today);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E254C) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPast
                      ? AppColors.success.withValues(alpha: 0.3)
                      : (isDark
                          ? const Color(0xFF2C3565)
                          : const Color(0xFFE4EAFA)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isPast
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPast
                          ? Icons.check_circle_rounded
                          : Icons.calendar_today_rounded,
                      size: 17,
                      color: isPast ? AppColors.success : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.label,
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          DateFormatter.formatFR(contact.date),
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF909FC6)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (contact.iptpDose)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'TPIg-SP',
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),

          if (user.record.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Mon dossier médical',
              style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1B2349),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E254C) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2C3565)
                      : const Color(0xFFE4EAFA),
                ),
              ),
              child: Column(
                children: user.record.map((r) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          r.label,
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF909FC6)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          r.value,
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NutritionAndGuidesSection extends StatelessWidget {
  final int trimester;
  final int selectedWeek;
  final bool isDark;

  const _NutritionAndGuidesSection({
    required this.trimester,
    required this.selectedWeek,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NutritionFeaturedCard(
            trimester: trimester,
            isDark: isDark,
            onTap: () => context.push('/nutrition-full'),
          ),
          const SizedBox(height: 20),
          Text(
            'Guides essentiels & Soins',
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF1B2349),
            ),
          ),
          const SizedBox(height: 12),
          _TopicImageCard(
            title: 'Préparer l’accouchement',
            subtitle: 'Valise de maternité, signes du travail, contractions',
            imagePath: 'assets/pregnancy/photos/maternity.jpg',
            tag: 'Maternité',
            isDark: isDark,
            onTap: () => context.push('/childbirth'),
          ),
          const SizedBox(height: 12),
          _TopicImageCard(
            title: 'Soins du nouveau-né & Allaitement',
            subtitle: 'Mise au sein précoce, cordon ombilical, sommeil',
            imagePath: 'assets/pregnancy/photos/breastfeeding.jpg',
            tag: 'Nouveau-né',
            isDark: isDark,
            onTap: () => context.push('/newborn-guide'),
          ),
          const SizedBox(height: 12),
          _TopicImageCard(
            title: 'Rétablissement après l’accouchement',
            subtitle: 'Visites postnatales, lochies, repos et bien-être',
            imagePath: 'assets/pregnancy/photos/prenatal.jpg',
            tag: 'Post-partum',
            isDark: isDark,
            onTap: () => context.push('/postpartum'),
          ),
          const SizedBox(height: 12),
          _TopicImageCard(
            title: 'Semaine par semaine (1 à 40 SA)',
            subtitle: 'Guide détaillé des 9 mois de grossesse',
            imagePath: 'assets/pregnancy/photos/fetus_20.jpg',
            tag: 'Calendrier',
            isDark: isDark,
            onTap: () => context.push('/pregnancy-weeks?week=$selectedWeek'),
          ),
        ],
      ),
    );
  }
}

class _PremiumSectionCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String tag;
  final String title;
  final String content;

  const _PremiumSectionCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.tag,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E254C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2C3565) : const Color(0xFFE4EAFA),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag,
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: iconColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF1B2349),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 13,
              color: isDark
                  ? const Color(0xFFB0BDED)
                  : const Color(0xFF4B5563),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _VitalMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final bool isDark;
  final VoidCallback onTap;

  const _VitalMetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E254C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2C3565) : const Color(0xFFE4EAFA),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF8E9DC6)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1B2349),
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 10,
                color: isDark
                    ? const Color(0xFF8E9DC6)
                    : const Color(0xFF8B95A5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionFeaturedCard extends StatelessWidget {
  final int trimester;
  final bool isDark;
  final VoidCallback onTap;

  const _NutritionFeaturedCard({
    required this.trimester,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 165,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/pregnancy/photos/meal.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pink,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Nutrition Trimestre $trimester',
                        style: const TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Alimentation locale & plats recommandés',
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Attiéké, poisson braisé, fonio, mafé, baobab et fer naturel →',
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicImageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String tag;
  final bool isDark;
  final VoidCallback onTap;

  const _TopicImageCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.tag,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E254C) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF2C3565) : const Color(0xFFE4EAFA),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1B2349),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF8E9DC6)
                          : const Color(0xFF6B7280),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? const Color(0xFF8E9DC6) : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}

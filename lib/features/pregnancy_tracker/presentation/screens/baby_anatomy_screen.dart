import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/pregnancy_dataset.dart';
import '../../domain/models/pregnancy_week_info.dart';

/// Organe ou point anatomique remarquable
class AnatomicalHotspot {
  final String id;
  final String name;
  final String icon;
  final Offset positionFraction; // x, y (0..1) sur l'image
  final String description;
  final String medicalFact;

  const AnatomicalHotspot({
    required this.id,
    required this.name,
    required this.icon,
    required this.positionFraction,
    required this.description,
    required this.medicalFact,
  });
}

class BabyAnatomyScreen extends StatefulWidget {
  const BabyAnatomyScreen({super.key, this.initialWeek = 20});

  final int initialWeek;

  @override
  State<BabyAnatomyScreen> createState() => _BabyAnatomyScreenState();
}

class _BabyAnatomyScreenState extends State<BabyAnatomyScreen>
    with TickerProviderStateMixin {
  late int _selectedWeek;
  late AnimationController _heartbeatController;
  late AnimationController _floatController;
  late final WebViewController _webViewController;

  // Toggle between real 360 3D view (Sketchfab WebGL) and Anatomical Guide
  bool _useRealtime3d = true;
  bool _is3dLoading = true;

  // 3D drag rotation for anatomical guided mode
  double _rotX = 0.0;
  double _rotY = 0.0;

  AnatomicalHotspot? _selectedHotspot;

  static const String _sketchfabModelId = '531114454d7b4029ad263bb9be1bf11d';
  static const String _sketchfabEmbedUrl =
      'https://sketchfab.com/models/$_sketchfabModelId/embed?autostart=1&camera=0&preload=1&ui_controls=1&ui_infos=0&ui_watermark=0&ui_help=0&ui_settings=0&ui_inspector=0&ui_annotations=0&transparent=1&ui_color=e05c8a';

  @override
  void initState() {
    super.initState();
    _selectedWeek = widget.initialWeek.clamp(4, 40);

    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850), // ~140 bpm
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Initialize 3D Real-Time WebGL Controller
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _is3dLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _is3dLoading = false);
          },
          onWebResourceError: (error) {
            debugPrint('Sketchfab 3D WebGL error: ${error.description}');
            if (mounted) setState(() => _is3dLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(_sketchfabEmbedUrl));
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  String _getAssetImageForWeek(int week) {
    if (week <= 12) {
      return 'assets/pregnancy/3d/fetus_week_08.jpg';
    } else if (week <= 26) {
      return 'assets/pregnancy/3d/fetus_week_20.jpg';
    } else {
      return 'assets/pregnancy/3d/fetus_week_36.jpg';
    }
  }

  List<AnatomicalHotspot> _getHotspotsForWeek(int week) {
    if (week <= 12) {
      return const [
        AnatomicalHotspot(
          id: 'brain',
          name: 'Cerveau & Tube neural',
          icon: '',
          positionFraction: Offset(0.48, 0.28),
          description: 'Le cerveau primitif se divise en 3 vésicules. Des millions de neurones se forment chaque minute.',
          medicalFact: 'Les premiers réflexes et impulsions électriques débutent dès ce stade.',
        ),
        AnatomicalHotspot(
          id: 'heart',
          name: 'Cœur embryonnaire',
          icon: '',
          positionFraction: Offset(0.58, 0.45),
          description: 'Le cœur bat très vite, entre 150 et 170 battements par minute, assurant la circulation vitale.',
          medicalFact:
              'Il est déjà audible à l\'échographie Doppler obstétricale.',
        ),
        AnatomicalHotspot(
          id: 'cord',
          name: 'Cordon ombilical',
          icon: '',
          positionFraction: Offset(0.38, 0.65),
          description: 'Relie l\'embryon au trophoblaste. Contient 2 artères et 1 veine protégées par la gelée de Wharton.',
          medicalFact: 'Il filtre et achemine l\'oxygène maternel directement vers l\'embryon.',
        ),
      ];
    } else if (week <= 26) {
      return const [
        AnatomicalHotspot(
          id: 'brain',
          name: 'Système nerveux central',
          icon: '',
          positionFraction: Offset(0.60, 0.24),
          description: 'Les sens s\'éveillent : votre bébé perçoit les bruits de votre voix et les battements de votre cœur.',
          medicalFact: 'La myélinisation des nerfs progresse rapidement pour accélérer les influx nerveux.',
        ),
        AnatomicalHotspot(
          id: 'heart',
          name: 'Cœur fœtal',
          icon: '',
          positionFraction: Offset(0.56, 0.44),
          description: 'Quatre cavités complètement formées battant au rythme régulier de 130 à 150 bpm.',
          medicalFact: 'Le sang est enrichi en oxygène grâce au placenta sans passer par les poumons encore au repos.',
        ),
        AnatomicalHotspot(
          id: 'hands',
          name: 'Mains & Préhension',
          icon: '',
          positionFraction: Offset(0.48, 0.40),
          description: 'Les doigts ont leurs empreintes digitales uniques et peuvent attraper le cordon ombilical.',
          medicalFact: 'Bébé commence à sucer son pouce pour développer son réflexe de succion.',
        ),
        AnatomicalHotspot(
          id: 'cord',
          name: 'Cordon ombilical & Placenta',
          icon: '',
          positionFraction: Offset(0.55, 0.68),
          description: 'Échangeur métabolique haute performance assurant oxygène, anticorps et nutriments essentiels.',
          medicalFact: 'Le placenta produit aussi les hormones protectrices de la grossesse.',
        ),
        AnatomicalHotspot(
          id: 'legs',
          name: 'Membres & Mouvements',
          icon: '',
          positionFraction: Offset(0.32, 0.64),
          description: 'Muscles et os renforcés par le calcium. Vous ressentez distinctement ses petits coups.',
          medicalFact: 'Bébé s\'étire, fait des culbutes et teste son sens de l\'équilibre.',
        ),
      ];
    } else {
      return const [
        AnatomicalHotspot(
          id: 'brain',
          name: 'Cerveau & Rêves',
          icon: '',
          positionFraction: Offset(0.42, 0.28),
          description: 'Le cortex cérébral présente des circonvolutions complexes. Le bébé entre en sommeil paradoxal.',
          medicalFact: 'Bébé mémorise déjà le timbre de la voix de sa mère et de son entourage.',
        ),
        AnatomicalHotspot(
          id: 'heart',
          name: 'Cœur prêt pour la vie',
          icon: '',
          positionFraction: Offset(0.40, 0.52),
          description: 'Puissant et synchronisé, son système circulatoire est prêt pour la transition respiratoire.',
          medicalFact: 'À la naissance, le premier cri fermera instantanément le foramen ovale.',
        ),
        AnatomicalHotspot(
          id: 'lungs',
          name: 'Poumons & Surfactant',
          icon: '',
          positionFraction: Offset(0.50, 0.48),
          description: 'Les alvéoles fabriquent du surfactant, substance essentielle empêchant les poumons de s\'affaisser.',
          medicalFact: 'Bébé s\'entraîne en inhalant et expirant du liquide amniotique régulièrement.',
        ),
        AnatomicalHotspot(
          id: 'skin',
          name: 'Peau & Vernix Caseosa',
          icon: '',
          positionFraction: Offset(0.32, 0.68),
          description: 'La peau est lisse et protégée par un enduit crémeux blanc (vernix) hydratant et antimicrobien.',
          medicalFact: 'Les couches de graisse sous-cutanée aident bébé à réguler sa température.',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final weekInfo = pregnancyDataset.firstWhere(
      (e) => e.week == _selectedWeek,
      orElse: () => pregnancyDataset.first,
    );

    final hotspots = _getHotspotsForWeek(_selectedWeek);
    final currentAsset = _getAssetImageForWeek(_selectedWeek);

    // Warm anatomical studio colors
    const bgStudioDark = Color(0xFF140E14);
    const bgStudioLight = Color(0xFFFFF5F0);
    const roseAccent = Color(0xFFE05C8A);
    const peachGlow = Color(0xFFFFB896);

    return Scaffold(
      backgroundColor: isDark ? bgStudioDark : bgStudioLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark ? Colors.white : const Color(0xFF2D1810),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vue Anatomique 3D',
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF2D1810),
                        ),
                      ),
                      Text(
                        'Semaine $_selectedWeek • Modèle interactif',
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 12,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF8B5A4A),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Heartbeat BPM badge
                  AnimatedBuilder(
                    animation: _heartbeatController,
                    builder: (context, _) {
                      final scale = 1.0 + _heartbeatController.value * 0.15;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: roseAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: roseAccent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.scale(
                              scale: scale,
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: roseAccent,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '142 BPM',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: roseAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Mode Switcher (Vrai 3D 360° vs Anatomie & Organes) ─
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFFFEAE0),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _useRealtime3d = true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _useRealtime3d
                                ? roseAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: _useRealtime3d
                                ? [
                                    BoxShadow(
                                      color: roseAccent.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.view_in_ar_rounded,
                                size: 16,
                                color: _useRealtime3d
                                    ? Colors.white
                                    : (isDark
                                          ? Colors.white60
                                          : const Color(0xFF8B5A4A)),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '3D 360° Temps Réel',
                                style: TextStyle(
                                  fontFamily: 'Figtree',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _useRealtime3d
                                      ? Colors.white
                                      : (isDark
                                            ? Colors.white60
                                            : const Color(0xFF8B5A4A)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _useRealtime3d = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_useRealtime3d
                                ? roseAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: !_useRealtime3d
                                ? [
                                    BoxShadow(
                                      color: roseAccent.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.hub_outlined,
                                size: 16,
                                color: !_useRealtime3d
                                    ? Colors.white
                                    : (isDark
                                          ? Colors.white60
                                          : const Color(0xFF8B5A4A)),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Organes & Points Clés',
                                style: TextStyle(
                                  fontFamily: 'Figtree',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: !_useRealtime3d
                                      ? Colors.white
                                      : (isDark
                                            ? Colors.white60
                                            : const Color(0xFF8B5A4A)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 3D Viewport ──────────────────────────────────────
            Expanded(
              flex: 5,
              child: _useRealtime3d
                  ? _buildRealtime3dViewer(isDark, roseAccent)
                  : _buildGuidedAnatomyViewer(
                      isDark,
                      hotspots,
                      currentAsset,
                      peachGlow,
                      roseAccent,
                    ),
            ),

            // ── Hint text ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 14,
                    color: isDark ? Colors.white38 : const Color(0xFF8B5A4A),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _useRealtime3d
                        ? 'Faites glisser pour tourner à 360° • Pincez pour zoomer'
                        : 'Touchez un point anatomique pour révéler les détails',
                    style: TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 11,
                      color: isDark ? Colors.white38 : const Color(0xFF8B5A4A),
                    ),
                  ),
                ],
              ),
            ),

            // ── Hotspot details card OR Week info card ───────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _selectedHotspot != null && !_useRealtime3d
                  ? _buildHotspotDetailCard(isDark)
                  : _buildWeekSummaryCard(isDark, weekInfo),
            ),

            const SizedBox(height: 10),

            // ── Interactive Timeline Slider (Semaines 4 à 40) ────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1822) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white10 : const Color(0xFFEEE0D8),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Évolution de grossesse',
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: roseAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Semaine $_selectedWeek / 41',
                            style: const TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: roseAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: roseAccent,
                        inactiveTrackColor: isDark
                            ? Colors.white12
                            : const Color(0xFFFFD9C4),
                        thumbColor: roseAccent,
                        overlayColor: roseAccent.withValues(alpha: 0.2),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 9,
                        ),
                      ),
                      child: Slider(
                        value: _selectedWeek.toDouble(),
                        min: 4,
                        max: 40,
                        divisions: 36,
                        onChanged: (val) {
                          final newWeek = val.round();
                          if (newWeek != _selectedWeek) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedWeek = newWeek;
                              _selectedHotspot = null;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Visualiseur 3D temps réel 360° officiel Sketchfab WebGL
  Widget _buildRealtime3dViewer(bool isDark, Color roseAccent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isDark ? const Color(0xFF1A131A) : const Color(0xFFFFF0E8),
          border: Border.all(
            color: roseAccent.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: roseAccent.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            WebViewWidget(controller: _webViewController),
            if (_is3dLoading)
              Container(
                color: isDark
                    ? const Color(0xFF140E14)
                    : const Color(0xFFFFF5F0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: roseAccent),
                      const SizedBox(height: 16),
                      const Text(
                        'Chargement du modèle 3D 360°...',
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Floating 360 badge
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.rotate_right_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '360° LIVE',
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Visualiseur anatomique guidé avec points d'intérêt
  Widget _buildGuidedAnatomyViewer(
    bool isDark,
    List<AnatomicalHotspot> hotspots,
    String currentAsset,
    Color peachGlow,
    Color roseAccent,
  ) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotY += details.delta.dx * 0.008;
          _rotX -= details.delta.dy * 0.008;
          _rotX = _rotX.clamp(-0.4, 0.4);
          _rotY = _rotY.clamp(-0.6, 0.6);
        });
      },
      onDoubleTap: () {
        setState(() {
          _rotX = 0;
          _rotY = 0;
        });
      },
      child: Center(
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final floatOffset = math.sin(_floatController.value * math.pi) * 6;

            return Transform.translate(
              offset: Offset(0, floatOffset),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015) // Perspective
                  ..rotateX(_rotX)
                  ..rotateY(_rotY),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient Studio Radial Glow
                    Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            peachGlow.withValues(alpha: isDark ? 0.25 : 0.6),
                            roseAccent.withValues(alpha: isDark ? 0.1 : 0.2),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),

                    // High-Resolution 3D Render
                    Hero(
                      tag: 'baby_3d_render',
                      child: Container(
                        width: 270,
                        height: 270,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: roseAccent.withValues(alpha: 0.25),
                              blurRadius: 32,
                              spreadRadius: 4,
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(currentAsset),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Interactive anatomical pins / hotspots
                    ...hotspots.map((spot) {
                      final isSelected = _selectedHotspot?.id == spot.id;
                      return Positioned(
                        left: 270 * spot.positionFraction.dx,
                        top: 270 * spot.positionFraction.dy,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _selectedHotspot = spot;
                            });
                          },
                          child: _HotspotPin(
                            spot: spot,
                            isSelected: isSelected,
                            pulseAnimation: _heartbeatController,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHotspotDetailCard(bool isDark) {
    final spot = _selectedHotspot!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF231B26) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE05C8A)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(spot.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  spot.name,
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF2D1810),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() => _selectedHotspot = null);
                },
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            spot.description,
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 11,
              height: 1.35,
              color: isDark ? Colors.white70 : const Color(0xFF5A3E30),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE05C8A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 13,
                  color: Color(0xFFE05C8A),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    spot.medicalFact,
                    style: const TextStyle(
                      fontFamily: 'Figtree',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE05C8A),
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

  Widget _buildWeekSummaryCard(bool isDark, PregnancyWeekInfo info) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1822) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEE0D8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFFE05C8A),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Évolution : ${info.babySize}',
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF2D1810),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            info.development,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 11,
              height: 1.35,
              color: isDark ? Colors.white60 : const Color(0xFF8B5A4A),
            ),
          ),
        ],
      ),
    );
  }
}

class _HotspotPin extends StatelessWidget {
  const _HotspotPin({
    required this.spot,
    required this.isSelected,
    required this.pulseAnimation,
  });

  final AnatomicalHotspot spot;
  final bool isSelected;
  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, _) {
        final pulse = pulseAnimation.value;
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE05C8A)
                : Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE05C8A)
                    .withValues(alpha: 0.4 + pulse * 0.3),
                blurRadius: 8 + pulse * 6,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(spot.icon, style: const TextStyle(fontSize: 14)),
        );
      },
    );
  }
}

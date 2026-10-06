import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _stripesController;
  late final AnimationController _pulseController;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Contrôleur de la barre de progression (remplissage progressif fluide en 5.5s)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    // Contrôleur des rayures animées style candy bar (rotation/défilement continu)
    _stripesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    // Contrôleur de pulsation douce pour le logo et les étoiles
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _progressController.forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Pause agréable de 500ms à 100% avant la transition vers l'écran suivant
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _navigateToNextScreen();
          }
        });
      }
    });
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    final onboarded = ref.read(appUserStateNotifierProvider).onboarded;
    final targetPath = onboarded ? '/app/home' : '/onboarding/welcome';
    context.go(targetPath);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _stripesController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF13172E),
              Color(0xFF1C2040),
              Color(0xFF161933),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF6F8FD),
              Color(0xFFEFF3FC),
            ],
          );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── 1. LOGO PRINCIPAL ADAPTÉ AVEC HALO LUMINEUX ──────
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_pulseController.value * 0.03);
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Halo lumineux doux aux couleurs de l'app (rose & bleu)
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.pink.withValues(alpha: 0.16),
                              AppColors.primary.withValues(alpha: 0.12),
                              Colors.transparent,
                            ],
                            stops: const [0.2, 0.6, 1.0],
                          ),
                        ),
                      ),

                      // Carte du Logo
                      Container(
                        width: 170,
                        height: 170,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF262C52) : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.14),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: AppColors.pink.withValues(alpha: 0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.pregnant_woman_rounded,
                                size: 80,
                                color: AppColors.pink,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── 2. NOM DE L'APPLICATION ET SLOGAN ─────────────────
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF3B57D4),
                    Color(0xFF8B5CF6),
                    Color(0xFFE0557F),
                  ],
                ).createShader(bounds),
                child: const Text(
                  'SaveBabe',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Prendre soin de la vie dès le premier jour',
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF9EAAEC)
                      : const Color(0xFF6B7280),
                  letterSpacing: 0.2,
                ),
              ),

              const Spacer(flex: 3),

              // ── 3. LOADEUR STYLE "BOY OR GIRL" AVEC BARRE CANDY STRIPES ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge "Boy or Girl" avec petites étoiles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Étoile gauche
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, _) => Transform.rotate(
                            angle: _pulseController.value * 0.2,
                            child: Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: const Color(0xFF3B57D4)
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // "Boy" en bleu stylisé avec ombre douce
                        const Text(
                          'Boy',
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF2967F5),
                            shadows: [
                              Shadow(
                                color: Color(0x332967F5),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),

                        // " or " au milieu
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF282F57)
                                  : const Color(0xFFE8EEFB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                        ),

                        // "Girl" en rose gourmand avec ombre douce
                        const Text(
                          'Girl',
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFF44781),
                            shadows: [
                              Shadow(
                                color: Color(0x33F44781),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),
                        // Étoile droite
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, _) => Transform.rotate(
                            angle: -_pulseController.value * 0.2,
                            child: Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: const Color(0xFFF44781)
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Barre de progression Candy Stripes animée
                    AnimatedBuilder(
                      animation: Listenable.merge(
                        [_progressAnimation, _stripesController],
                      ),
                      builder: (context, child) {
                        return _CandyStripesProgressBar(
                          progress: _progressAnimation.value,
                          scrollOffset: _stripesController.value,
                          isDark: isDark,
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    // Texte descriptif avec étapes progressives et pourcentage dynamique
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, _) {
                        final percent = (_progressAnimation.value * 100).toInt();
                        final String stageText;
                        if (percent >= 100) {
                          stageText = 'BIENVENUE';
                        } else if (percent >= 75) {
                          stageText = 'FINALISATION';
                        } else if (percent >= 30) {
                          stageText = 'CHARGEMENT';
                        } else {
                          stageText = 'INITIALISATION';
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              stageText,
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.2,
                                color: isDark
                                    ? const Color(0xFF9CA9D8)
                                    : const Color(0xFF5A6686),
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (percent < 100)
                              _AnimatedDots(controller: _stripesController)
                            else
                              const SizedBox(width: 18),
                            const SizedBox(width: 8),
                            Text(
                              '$percent%',
                              style: const TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ── 4. PIED DE PAGE DISCRET ───────────────────────────
              Text(
                'v1.0.0 • Santé & Grossesse Sécurisée',
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 11,
                  color: isDark ? Colors.white24 : Colors.black26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barre de chargement avec capsule 3D, rayures diagonales animées rose & bleu
class _CandyStripesProgressBar extends StatelessWidget {
  final double progress;
  final double scrollOffset;
  final bool isDark;

  const _CandyStripesProgressBar({
    required this.progress,
    required this.scrollOffset,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2345) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF384175)
              : const Color(0xFFD6DFFA),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            // Fond vide de la barre
            Container(
              color: isDark
                  ? const Color(0xFF181D3B)
                  : const Color(0xFFF3F6FD),
            ),

            // Remplissage progressif avec les rayures animées
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              alignment: Alignment.centerLeft,
              child: CustomPaint(
                size: const Size(double.infinity, 28),
                painter: _CandyStripesPainter(
                  scrollOffset: scrollOffset,
                ),
              ),
            ),

            // Reflet brillant style bonbon / sticker 3D sur la moitié haute
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 12,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.35),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Peintre personnalisé dessinant les rayures diagonales alternées bleu (#3B57D4) et rose (#E0557F)
class _CandyStripesPainter extends CustomPainter {
  final double scrollOffset;

  _CandyStripesPainter({required this.scrollOffset});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0) return;

    final paintBlue = Paint()
      ..color = const Color(0xFF2E63F2)
      ..style = PaintingStyle.fill;

    final paintPink = Paint()
      ..color = const Color(0xFFF24883)
      ..style = PaintingStyle.fill;

    // Fond bleu par défaut
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintBlue);

    // Dessin des bandes diagonales roses
    const stripeWidth = 14.0;
    const stripeSpacing = 28.0; // Période totale
    final offset = scrollOffset * stripeSpacing;

    final path = Path();
    for (double x = -stripeSpacing + offset;
        x < size.width + stripeSpacing + size.height;
        x += stripeSpacing) {
      path.reset();
      path.moveTo(x, 0);
      path.lineTo(x + stripeWidth, 0);
      path.lineTo(x + stripeWidth - size.height, size.height);
      path.lineTo(x - size.height, size.height);
      path.close();
      canvas.drawPath(path, paintPink);
    }
  }

  @override
  bool shouldRepaint(covariant _CandyStripesPainter oldDelegate) {
    return oldDelegate.scrollOffset != scrollOffset;
  }
}

/// Animation des trois petits points de chargement
class _AnimatedDots extends StatelessWidget {
  final Animation<double> controller;

  const _AnimatedDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final step = (controller.value * 3).floor() % 3;
        final dots = '.' * (step + 1);
        return SizedBox(
          width: 18,
          child: Text(
            dots,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Color(0xFF2E63F2),
            ),
          ),
        );
      },
    );
  }
}

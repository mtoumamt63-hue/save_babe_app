import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_logo.dart';
import '../../../../core/widgets/sb_private_badge.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: SbLogo(size: SbLogoSize.md),
              ),
              const SizedBox(height: 36),
              // Visuel central elegant avec logo officiel et halo
              Stack(
                alignment: Alignment.center,
                children: [
                  // Halo subtil d'arriere-plan
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.primary)
                                  .withValues(alpha: isDark ? 0.25 : 0.12),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  // Anneau degrade exterieur
                  Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppColors.darkPrimary.withValues(alpha: 0.45),
                                AppColors.darkPink.withValues(alpha: 0.35),
                              ]
                            : [
                                AppColors.primary.withValues(alpha: 0.2),
                                AppColors.pink.withValues(alpha: 0.25),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: (isDark ? Colors.white12 : Colors.white)
                            .withValues(alpha: 0.8),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 156,
                      height: 156,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.3 : 0.08,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // Badge pulsant elegant avec icone Material
                  Positioned(
                    bottom: 6,
                    right: 14,
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.pink,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.pink.withValues(alpha: 0.45),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E1E2C)
                                : Colors.white,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                'Votre grossesse,\nNotre Priorité.',
                textAlign: TextAlign.center,
                style: AppTypography.displayL.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Un accompagnement simple, privé et accessible, même sans internet.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyM.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 36),
              SbButton(
                text: 'Créer un compte',
                onPressed: () => context.push('/onboarding/signup'),
              ),
              const SizedBox(height: 12),
              SbButton(
                text: 'Se connecter',
                variant: SbButtonVariant.outline,
                onPressed: () => context.push('/onboarding/login'),
              ),
              const SizedBox(height: 16),
              const SbPrivateBadge(text: 'Vos données restent privées'),
            ],
          ),
        ),
      ),
    );
  }
}

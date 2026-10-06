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
              // Cercle visuel avec animation de pouls sur le cœur
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppColors.darkPrimary.withValues(alpha: 0.3),
                                AppColors.darkPink.withValues(alpha: 0.2),
                              ]
                            : [AppColors.secondary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🤰🏾', style: TextStyle(fontSize: 84)),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 12,
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.pink,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.pink.withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          '♥',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                'Votre grossesse,\nvotre tranquillité.',
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

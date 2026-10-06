import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_steps.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  static const List<String> _items = [
    'Conseils de la semaine',
    'Suivi de grossesse',
    'Questions fréquentes',
    'Rendez-vous',
    'Suivi du bébé',
  ];

  int _done = 0;
  bool _isPaused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSync();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSync() {
    _timer = Timer.periodic(const Duration(milliseconds: 650), (timer) {
      if (_isPaused) return;
      if (_done < _items.length) {
        setState(() {
          _done++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) {
            context.go('/onboarding/ready');
          }
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progress = _items.isEmpty
        ? 0.0
        : (_done / _items.length).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SbSteps(currentStep: 4),
              const SbHeader(
                title: 'Préparer votre espace hors connexion',
                subtitle: 'Téléchargement en arrière-plan',
              ),
              SbCard(
                padding: const EdgeInsets.all(AppDimensions.pLg),
                child: Column(
                  children: [
                    ...List.generate(_items.length, (i) {
                      final item = _items[i];
                      final isCompleted = i < _done;
                      final isCurrent = i == _done;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item,
                              style: AppTypography.bodyM.copyWith(
                                color: isCompleted || isCurrent
                                    ? (isDark
                                          ? AppColors.darkCardForeground
                                          : AppColors.cardForeground)
                                    : (isDark
                                          ? AppColors.darkMutedForeground
                                          : AppColors.mutedForeground),
                                fontWeight: isCompleted
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              )
                            else if (isCurrent)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.darkBorder
                                        : AppColors.border,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: isDark
                            ? AppColors.darkBorder
                            : AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Seul le contenu autorisé et essentiel à votre suivi est téléchargé.',
                style: AppTypography.bodyS.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              SbCard(
                backgroundColor: isDark
                    ? AppColors.darkCard
                    : AppColors.successSoft,
                borderColor: Colors.transparent,
                padding: const EdgeInsets.all(AppDimensions.pMd),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppColors.success,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Synchronisation sécurisée',
                            style: AppTypography.labelM.copyWith(
                              color: isDark
                                  ? AppColors.darkCardForeground
                                  : AppColors.cardForeground,
                            ),
                          ),
                          Text(
                            'Vous pouvez continuer à utiliser l\'application',
                            style: AppTypography.bodyS.copyWith(
                              color: isDark
                                  ? AppColors.darkMutedForeground
                                  : AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SbButton(
                text: _isPaused ? 'Reprendre' : 'Mettre en pause',
                variant: SbButtonVariant.outline,
                icon: Icon(
                  _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  size: 20,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                onPressed: _togglePause,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

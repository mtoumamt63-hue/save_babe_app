import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.successSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 48,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Informations enregistrées\ndans votre dossier',
                textAlign: TextAlign.center,
                style: AppTypography.displayM.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ces données alimentent votre suivi et permettent à l\'assistant de mieux vous guider.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyM.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 48),
              SbButton(
                text: 'Garder pour moi seul(e)',
                onPressed: () => context.go('/app/tracking'),
              ),
              const SizedBox(height: 12),
              SbButton(
                text: 'Partager avec un proche',
                variant: SbButtonVariant.outline,
                onPressed: () => context.push('/invite'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

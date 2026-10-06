import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class SbSteps extends StatelessWidget {
  const SbSteps({super.key, required this.currentStep, this.totalSteps = 4});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final inactiveColor = isDark ? AppColors.darkBorder : AppColors.border;
    final mutedColor = isDark
        ? AppColors.darkMutedForeground
        : AppColors.mutedForeground;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Étape $currentStep sur $totalSteps',
            style: AppTypography.bodyS.copyWith(color: mutedColor),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(totalSteps, (index) {
              final stepIndex = index + 1;
              final isActive = stepIndex <= currentStep;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(
                    right: index < totalSteps - 1 ? 6 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? activeColor : inactiveColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

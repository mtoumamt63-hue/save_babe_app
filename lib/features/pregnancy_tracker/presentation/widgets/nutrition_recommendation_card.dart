import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../data/nutrition_dataset.dart';

class NutritionRecommendationCard extends StatelessWidget {
  const NutritionRecommendationCard({
    super.key,
    required this.trimester,
    this.onTap,
  });

  final int trimester;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tips = trimesterTips.firstWhere(
      (item) => item.trimester == trimester,
      orElse: () => trimesterTips.first,
    );

    return SbCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant_rounded, color: AppColors.success),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Nutrition — trimestre $trimester',
                  style: AppTypography.labelM.copyWith(
                    color: isDark
                        ? AppColors.darkCardForeground
                        : AppColors.cardForeground,
                  ),
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                ),
            ],
          ),
          const SizedBox(height: 10),
          ...tips.tips
              .take(3)
              .map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: AppTypography.bodyS.copyWith(
                            color: isDark
                                ? AppColors.darkMutedForeground
                                : AppColors.mutedForeground,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 2),
          Text(
            'Voir le guide alimentaire complet',
            style: AppTypography.bodyS.copyWith(
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

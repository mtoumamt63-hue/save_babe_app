import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../widgets/pregnancy_page.dart';
import '../../data/nutrition_dataset.dart';

class NutritionGuideScreen extends StatelessWidget {
  const NutritionGuideScreen({super.key, required this.trimester});

  final int trimester;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final safeTrimester = trimester.clamp(1, 3).toInt();
    final tips = trimesterTips.firstWhere(
      (item) => item.trimester == safeTrimester,
      orElse: () => trimesterTips.first,
    );

    return PregnancyPage(
      title: 'Guide nutrition',
      subtitle: 'Repères panafricains adaptés à la grossesse',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SbCard(
              backgroundColor: isDark
                  ? AppColors.successSoftDark
                  : AppColors.successSoft,
              borderColor: AppColors.success.withValues(alpha: 0.35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trimestre $safeTrimester à retenir',
                    style: AppTypography.labelM.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...tips.tips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: AppTypography.bodyS.copyWith(
                                color: isDark
                                    ? AppColors.darkCardForeground
                                    : AppColors.cardForeground,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ce qu’il faut privilégier',
              style: AppTypography.labelL.copyWith(
                color: isDark
                    ? AppColors.darkCardForeground
                    : AppColors.cardForeground,
              ),
            ),
            const SizedBox(height: 10),
            ...nutritionItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SbCard(
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(top: 6),
                    title: Text(
                      item.need,
                      style: AppTypography.labelM.copyWith(
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                    subtitle: Text(
                      item.foods.take(3).join(' • '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyS.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                      ),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.foods.join(' • '),
                          style: AppTypography.bodyM.copyWith(
                            color: isDark
                                ? AppColors.darkCardForeground
                                : AppColors.cardForeground,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.advice,
                          style: AppTypography.bodyS.copyWith(
                            color: isDark
                                ? AppColors.darkMutedForeground
                                : AppColors.mutedForeground,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'À éviter ou limiter',
              style: AppTypography.labelL.copyWith(
                color: isDark
                    ? AppColors.darkCardForeground
                    : AppColors.cardForeground,
              ),
            ),
            const SizedBox(height: 10),
            ...avoidItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SbCard(
                  borderColor: AppColors.destructive.withValues(alpha: 0.22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.block_rounded,
                        color: AppColors.destructive,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.item,
                              style: AppTypography.labelM.copyWith(
                                color: isDark
                                    ? AppColors.darkCardForeground
                                    : AppColors.cardForeground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.reason,
                              style: AppTypography.bodyS.copyWith(
                                color: isDark
                                    ? AppColors.darkMutedForeground
                                    : AppColors.mutedForeground,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Cette application ne remplace pas la consultation avec un médecin, une sage-femme ou un centre de santé. Les aliments disponibles et les protocoles doivent être adaptés au pays.',
              style: AppTypography.bodyS.copyWith(
                color: isDark
                    ? AppColors.darkMutedForeground
                    : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

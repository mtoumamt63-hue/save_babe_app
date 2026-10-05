import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';

class DangerSignsBanner extends StatelessWidget {
  const DangerSignsBanner({
    super.key,
    required this.onOpenSigns,
    required this.onEmergency,
    this.onNotifyTrusted,
  });

  final VoidCallback onOpenSigns;
  final VoidCallback onEmergency;
  final VoidCallback? onNotifyTrusted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SbCard(
      backgroundColor: isDark
          ? AppColors.destructive.withValues(alpha: 0.12)
          : const Color(0xFFFFF0EC),
      borderColor: AppColors.destructive.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.destructive),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Signes de danger',
                  style: AppTypography.labelM.copyWith(
                    color: AppColors.destructive,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Saignement, maux de tête intenses avec vue floue, fièvre, perte de liquide ou bébé qui bouge nettement moins : n’attendez pas.',
            style: AppTypography.bodyS.copyWith(
              color: isDark
                  ? AppColors.darkCardForeground
                  : AppColors.cardForeground,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          SbButton(
            text: 'Voir les signes de danger',
            variant: SbButtonVariant.outline,
            onPressed: onOpenSigns,
          ),
          const SizedBox(height: 8),
          SbButton(
            text: 'Urgence',
            variant: SbButtonVariant.danger,
            onPressed: onEmergency,
          ),
          if (onNotifyTrusted != null) ...[
            const SizedBox(height: 4),
            SbButton(
              text: 'Prévenir ma personne de confiance',
              variant: SbButtonVariant.ghost,
              onPressed: onNotifyTrusted,
            ),
          ],
        ],
      ),
    );
  }
}

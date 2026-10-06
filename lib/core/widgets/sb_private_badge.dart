import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class SbPrivateBadge extends StatelessWidget {
  const SbPrivateBadge({super.key, this.text = 'Vos données restent privées'});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedColor = isDark
        ? AppColors.darkMutedForeground
        : AppColors.mutedForeground;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline_rounded, size: 14, color: mutedColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTypography.bodyS.copyWith(
              color: mutedColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

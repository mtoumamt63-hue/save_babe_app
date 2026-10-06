import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../widgets/pregnancy_page.dart';
import '../../data/danger_signs_data.dart';
import '../../domain/models/danger_sign.dart';

class DangerSignsScreen extends StatelessWidget {
  const DangerSignsScreen({super.key});

  Color _color(DangerUrgency urgency) {
    switch (urgency) {
      case DangerUrgency.immediate:
        return AppColors.destructive;
      case DangerUrgency.sameDay:
        return const Color(0xFFB26A00);
      case DangerUrgency.consultSoon:
        return const Color(0xFF8A7600);
    }
  }

  String _urgencyLabel(DangerUrgency urgency) {
    switch (urgency) {
      case DangerUrgency.immediate:
        return 'Urgence immédiate';
      case DangerUrgency.sameDay:
        return 'Consulter aujourd’hui';
      case DangerUrgency.consultSoon:
        return 'Consulter rapidement';
    }
  }

  Widget _section(BuildContext context, String title, DangerPhase phase) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = dangerSignsFor(phase);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            title,
            style: AppTypography.labelL.copyWith(
              color: isDark
                  ? AppColors.darkCardForeground
                  : AppColors.cardForeground,
            ),
          ),
        ),
        ...list.map(
          (sign) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SbCard(
              borderColor: _color(sign.urgency).withValues(alpha: 0.45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: _color(sign.urgency),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          sign.title,
                          style: AppTypography.labelM.copyWith(
                            color: isDark
                                ? AppColors.darkCardForeground
                                : AppColors.cardForeground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sign.action,
                    style: AppTypography.bodyM.copyWith(
                      color: _color(sign.urgency),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sign.why,
                    style: AppTypography.bodyS.copyWith(
                      color: isDark
                          ? AppColors.darkMutedForeground
                          : AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _urgencyLabel(sign.urgency),
                    style: AppTypography.bodyS.copyWith(
                      color: _color(sign.urgency),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PregnancyPage(
      title: 'Signes de danger',
      subtitle: 'Agir d’abord, comprendre ensuite',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SbCard(
              backgroundColor: isDark
                  ? AppColors.destructive.withValues(alpha: 0.12)
                  : const Color(0xFFFFF0EC),
              borderColor: AppColors.destructive.withValues(alpha: 0.4),
              child: Text(
                'Si vous avez un de ces signes, n’attendez pas : allez immédiatement au centre de santé ou appelez les urgences, et prévenez votre personne de confiance.',
                style: AppTypography.bodyM.copyWith(
                  color: AppColors.destructive,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
            _section(context, 'Pendant la grossesse', DangerPhase.pregnancy),
            _section(
              context,
              'Après l’accouchement — maman',
              DangerPhase.postpartum,
            ),
            _section(context, 'Nouveau-né', DangerPhase.newborn),
            const SizedBox(height: 8),
            SbButton(
              text: 'Ouvrir l’écran d’urgence',
              variant: SbButtonVariant.danger,
              onPressed: () => context.push('/emergency'),
            ),
            const SizedBox(height: 8),
            SbButton(
              text: 'Prévenir ma personne de confiance',
              variant: SbButtonVariant.outline,
              onPressed: () => context.push('/invite'),
            ),
            const SizedBox(height: 16),
            Text(
              'Cette application ne remplace pas la consultation avec un médecin, une sage-femme ou un centre de santé.',
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

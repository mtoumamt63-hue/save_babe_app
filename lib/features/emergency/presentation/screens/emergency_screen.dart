import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';

class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  Future<void> _callPhone(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dangerSigns = [
      'Saignements vaginaux',
      'Maux de tête sévères avec vision trouble',
      'Fièvre élevée ou frissons',
      'Douleur abdominale intense',
      'Perte brutale de liquide',
      'Bébé qui ne bouge plus ou bouge nettement moins',
      'Gonflement rapide du visage ou des mains',
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Numéros d\'urgence',
                subtitle: 'Contactez immédiatement un professionnel',
                onBack: () => context.pop(),
              ),
              // Bouton Urgences 112
              SbButton(
                text: 'Appeler les urgences (112 ou 185)',
                variant: SbButtonVariant.danger,
                icon: const Icon(
                  Icons.phone_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => _callPhone('112'),
              ),
              // Bouton Partenaire (si renseigné)
              if (user.partner != null && user.partner!.phone.isNotEmpty) ...[
                const SizedBox(height: 12),
                SbButton(
                  text:
                      'Appeler ${user.partner!.name} (${user.partner!.phone})',
                  variant: SbButtonVariant.outline,
                  icon: Icon(
                    Icons.phone_outlined,
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    size: 20,
                  ),
                  onPressed: () => _callPhone(user.partner!.phone),
                ),
              ],
              const SizedBox(height: 24),
              // Centre de référence
              if (user.center.isNotEmpty) ...[
                SbCard(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_hospital_rounded,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mon centre de santé',
                              style: AppTypography.labelS.copyWith(
                                color: isDark
                                    ? AppColors.darkMutedForeground
                                    : AppColors.mutedForeground,
                              ),
                            ),
                            Text(
                              user.center,
                              style: AppTypography.labelM.copyWith(
                                color: isDark
                                    ? AppColors.darkCardForeground
                                    : AppColors.cardForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Card Signes de danger
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.destructive,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Signes de danger immédiats',
                          style: AppTypography.labelM.copyWith(
                            color: AppColors.destructive,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...dangerSigns.map((sign) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(top: 6, right: 10),
                              decoration: const BoxDecoration(
                                color: AppColors.destructive,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                sign,
                                style: AppTypography.bodyM.copyWith(
                                  color: isDark
                                      ? AppColors.darkCardForeground
                                      : AppColors.cardForeground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';

class BabyScreen extends ConsumerWidget {
  const BabyScreen({super.key});

  void _logActivity(BuildContext context, WidgetRef ref, String kind) {
    final now = DateTime.now();
    final timeStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final entry = BabyLogEntry(id: const Uuid().v4(), kind: kind, at: timeStr);

    ref.read(appUserStateNotifierProvider.notifier).addBabyLog(entry);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$kind noté')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baby = user.baby;

    if (baby == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👶🏾', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 20),
                Text(
                  'Aucun profil bébé',
                  style: AppTypography.displayM.copyWith(
                    color: isDark
                        ? AppColors.darkCardForeground
                        : AppColors.cardForeground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Votre bébé est né ? Enregistrez son profil pour suivre ses tétées, son sommeil et ses vaccins.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyM.copyWith(
                    color: isDark
                        ? AppColors.darkMutedForeground
                        : AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 32),
                SbButton(
                  text: 'Créer le profil du bébé',
                  onPressed: () => context.push('/app/baby/create'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final birthDate = DateTime.tryParse(baby.birth) ?? DateTime.now();
    final days = DateTime.now().difference(birthDate).inDays.clamp(0, 9999);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: baby.name,
                subtitle: '$days jours · ${baby.weight} kg à la naissance',
              ),
              // 3 boutons de logs rapides
              Row(
                children: [
                  _QuickLogBtn(
                    icon: Icons.local_drink_rounded,
                    label: 'Tétée',
                    onTap: () => _logActivity(context, ref, 'Tétée'),
                  ),
                  const SizedBox(width: 10),
                  _QuickLogBtn(
                    icon: Icons.bedtime_rounded,
                    label: 'Sommeil',
                    onTap: () => _logActivity(context, ref, 'Sommeil'),
                  ),
                  const SizedBox(width: 10),
                  _QuickLogBtn(
                    icon: Icons.water_drop_rounded,
                    label: 'Couche',
                    onTap: () => _logActivity(context, ref, 'Couche'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Guides essentiels', style: AppTypography.labelM),
                    const SizedBox(height: 8),
                    Text(
                      'Soins du nouveau-né, allaitement, sommeil sécurisé et signes de danger.',
                      style: AppTypography.bodyS,
                    ),
                    const SizedBox(height: 10),
                    SbButton(
                      text: 'Ouvrir le guide nouveau-né',
                      onPressed: () => context.push('/newborn-guide'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Vaccins : pas de calendrier universel codé en dur.
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vaccins',
                      style: AppTypography.labelM.copyWith(
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Journal des activités
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Journal',
                      style: AppTypography.labelM.copyWith(
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (user.babyLog.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Rien encore aujourd\'hui',
                          style: AppTypography.bodyS.copyWith(
                            color: isDark
                                ? AppColors.darkMutedForeground
                                : AppColors.mutedForeground,
                          ),
                        ),
                      )
                    else
                      ...user.babyLog.take(8).map((log) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                log.kind,
                                style: AppTypography.bodyM.copyWith(
                                  color: isDark
                                      ? AppColors.darkCardForeground
                                      : AppColors.cardForeground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                log.at,
                                style: AppTypography.bodyS.copyWith(
                                  color: isDark
                                      ? AppColors.darkMutedForeground
                                      : AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SbButton(
                text: 'Modifier le profil',
                variant: SbButtonVariant.ghost,
                onPressed: () => context.push('/app/baby/create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLogBtn extends StatelessWidget {
  const _QuickLogBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.successSoft,
            borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: AppColors.success),
              const SizedBox(height: 6),
              Text(
                '+ $label',
                style: const TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';

class ReadyScreen extends ConsumerWidget {
  const ReadyScreen({super.key});

  void _finishAndGo(
    BuildContext context,
    WidgetRef ref,
    String targetRoute,
  ) async {
    await ref
        .read(appUserStateNotifierProvider.notifier)
        .update((s) => s.copyWith(onboarded: true));
    if (context.mounted) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final displayName = user.name.isNotEmpty ? user.name : 'Grâce';
    final weeks = DateFormatter.weeksOf(user.lmp);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Bonjour, $displayName',
                subtitle: 'Votre espace est prêt',
              ),
              // Carte Gradient Semaines
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$weeks',
                      style: AppTypography.displayXl.copyWith(
                        color: Colors.white,
                        fontSize: 56,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'semaines de grossesse',
                      style: AppTypography.bodyL.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Que souhaitez-vous faire en premier ?',
                style: AppTypography.labelL.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.favorite_rounded,
                iconColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                iconBg: isDark ? AppColors.darkCard : AppColors.secondary,
                title: 'Suivi de grossesse',
                subtitle: 'Conseils et évolution de bébé',
                onTap: () => _finishAndGo(context, ref, '/app/tracking'),
              ),
              const SizedBox(height: 10),
              _ActionTile(
                icon: Icons.calendar_today_rounded,
                iconColor: AppColors.pink,
                iconBg: AppColors.accent,
                title: 'Mes rendez-vous',
                subtitle: 'Consulter et planifier les visites',
                onTap: () => _finishAndGo(context, ref, '/app/appointments'),
              ),
              const SizedBox(height: 10),
              _ActionTile(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: AppColors.success,
                iconBg: isDark ? AppColors.darkCard : AppColors.successSoft,
                title: 'Poser une question à l\'assistant',
                subtitle: 'Disponible 24h/24 hors connexion',
                onTap: () => _finishAndGo(context, ref, '/chat'),
              ),
              const SizedBox(height: 14),
              SbCard(
                onTap: () => _finishAndGo(context, ref, '/invite'),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.pink,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Inviter un proche de confiance',
                        style: AppTypography.labelM.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.mutedForeground,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SbButton(
                text: 'Accéder à mon espace',
                onPressed: () => _finishAndGo(context, ref, '/app/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SbCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelM.copyWith(
                    color: isDark
                        ? AppColors.darkCardForeground
                        : AppColors.cardForeground,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodyS.copyWith(
                    color: isDark
                        ? AppColors.darkMutedForeground
                        : AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.mutedForeground,
          ),
        ],
      ),
    );
  }
}

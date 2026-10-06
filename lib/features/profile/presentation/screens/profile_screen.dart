import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : 'G';
    final displayName = user.name.isNotEmpty ? user.name : 'Grâce';
    final weeks = DateFormatter.weeksOf(user.lmp);

    final settingsItems = [
      {
        'title': 'Confidentialité de l\'assistant IA',
        'icon': Icons.auto_awesome_rounded,
        'route': '/app/profile/ai-privacy',
      },
      {
        'title': 'Hors-ligne et chiffrement',
        'icon': Icons.wifi_off_rounded,
        'route': '/app/profile/offline',
      },
      {
        'title': 'Langue et pays',
        'icon': Icons.public_rounded,
        'route': '/app/profile/language',
      },
      {
        'title': 'Apparence',
        'icon': Icons.dark_mode_outlined,
        'route': '/app/profile/theme',
      },
      {
        'title': 'Personne de confiance',
        'icon': Icons.person_add_alt_1_rounded,
        'route': '/invite',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SbHeader(title: 'Mon profil'),
              // Carte Profil utilisateur
              SbCard(
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: AppTypography.displayM.copyWith(
                              fontSize: 20,
                              color: isDark
                                  ? AppColors.darkCardForeground
                                  : AppColors.cardForeground,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${user.contact.isNotEmpty ? user.contact : "+225 07 00 00 00"} · $weeks SA',
                            style: AppTypography.bodyS.copyWith(
                              color: isDark
                                  ? AppColors.darkMutedForeground
                                  : AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Menu réglages
              SbCard(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Column(
                  children: settingsItems.map((item) {
                    return ListTile(
                      leading: Icon(
                        item['icon'] as IconData,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                        size: 22,
                      ),
                      title: Text(
                        item['title'] as String,
                        style: AppTypography.bodyM.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.mutedForeground,
                        size: 20,
                      ),
                      onTap: () => context.push(item['route'] as String),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),
              // Bouton Se déconnecter
              SbButton(
                text: 'Se déconnecter',
                variant: SbButtonVariant.outline,
                icon: const Icon(Icons.logout_rounded, size: 18),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Déconnexion'),
                      content: const Text(
                        'Souhaitez-vous vous déconnecter de SaveBabe ? Vos données restent sauvegardées sur cet appareil.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Déconnexion'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await ref.read(authServiceProvider).signOut();
                    if (context.mounted) {
                      context.go('/onboarding/welcome');
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              // Bouton Supprimer les données locales
              SbButton(
                text: 'Supprimer mes données locales',
                variant: SbButtonVariant.ghost,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.destructive,
                  size: 18,
                ),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirmer la suppression'),
                      content: const Text(
                        'Supprimer toutes vos données de cet appareil ? Cette action est irréversible pour les données locales.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Supprimer',
                            style: TextStyle(color: AppColors.destructive),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await ref
                        .read(appUserStateNotifierProvider.notifier)
                        .reset();
                    await ref.read(authServiceProvider).signOut();
                    if (context.mounted) {
                      context.go('/onboarding/welcome');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_toggle.dart';

class OfflineScreen extends ConsumerStatefulWidget {
  const OfflineScreen({super.key});

  @override
  ConsumerState<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends ConsumerState<OfflineScreen> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkNetwork();
  }

  Future<void> _checkNetwork() async {
    final netInfo = ref.read(networkInfoProvider);
    final connected = await netInfo.isConnected;
    if (mounted) {
      setState(() => _isConnected = connected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Hors-ligne et chiffrement',
                onBack: () => context.pop(),
              ),
              // Statut connectivité
              SbCard(
                backgroundColor: isDark
                    ? AppColors.darkCard
                    : (_isConnected ? AppColors.successSoft : AppColors.accent),
                borderColor: Colors.transparent,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _isConnected
                          ? Icons.wifi_rounded
                          : Icons.wifi_off_rounded,
                      color: _isConnected ? AppColors.success : AppColors.pink,
                      size: 26,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isConnected ? 'Connectée' : 'Hors connexion',
                            style: AppTypography.labelM.copyWith(
                              color: isDark
                                  ? AppColors.darkCardForeground
                                  : AppColors.cardForeground,
                            ),
                          ),
                          Text(
                            'Vos contenus essentiels restent disponibles',
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
              const SizedBox(height: 14),
              // Mode hors connexion toggle
              SbCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mode hors connexion',
                            style: AppTypography.labelM.copyWith(
                              color: isDark
                                  ? AppColors.darkCardForeground
                                  : AppColors.cardForeground,
                            ),
                          ),
                          Text(
                            'Contenus téléchargés sur l\'appareil',
                            style: AppTypography.bodyS.copyWith(
                              color: isDark
                                  ? AppColors.darkMutedForeground
                                  : AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SbToggle(
                      value: user.consent.offline,
                      onChanged: (v) {
                        ref
                            .read(appUserStateNotifierProvider.notifier)
                            .update(
                              (s) => s.copyWith(
                                consent: s.consent.copyWith(offline: v),
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Chiffrement actif
              SbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Chiffrement actif',
                          style: AppTypography.labelM.copyWith(
                            color: isDark
                                ? AppColors.darkCardForeground
                                : AppColors.cardForeground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Vos données sont stockées uniquement sur cet appareil. Rien n\'est partagé sans votre accord.',
                      style: AppTypography.bodyM.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.accent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'En cas d\'urgence, contactez un professionnel de santé.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkPink : AppColors.pink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

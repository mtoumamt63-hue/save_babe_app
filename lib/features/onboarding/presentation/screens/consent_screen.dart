import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_steps.dart';
import '../../../../core/widgets/sb_toggle.dart';

class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  bool _health = true;
  bool _ai = true;
  bool _offline = true;
  bool _share = false;

  @override
  void initState() {
    super.initState();
    final consent = ref.read(appUserStateProvider).consent;
    _health = consent.health;
    _ai = consent.ai;
    _offline = consent.offline;
    _share = consent.share;
  }

  void _saveAndProceed() async {
    await ref
        .read(appUserStateNotifierProvider.notifier)
        .update(
          (s) => s.copyWith(
            consent: s.consent.copyWith(
              health: _health,
              ai: _ai,
              offline: _offline,
              share: _share,
            ),
          ),
        );
    if (mounted) {
      context.push('/onboarding/sync');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                title: 'Vos choix de confidentialité',
                onBack: () => context.pop(),
              ),
              const SbSteps(currentStep: 3),
              _ConsentItem(
                title: 'Données de santé',
                description: 'Stockage sécurisé et chiffré',
                badgeText: 'Requis',
                isBadgePink: true,
                value: _health,
                onChanged: (_) {}, // Requis, non désactivable
              ),
              const SizedBox(height: 12),
              _ConsentItem(
                title: 'Assistant IA',
                description: 'Utiliser uniquement les informations nécessaires',
                badgeText: 'Optionnel',
                isBadgePink: false,
                value: _ai,
                onChanged: (v) => setState(() => _ai = v),
              ),
              const SizedBox(height: 12),
              _ConsentItem(
                title: 'Mode hors connexion',
                description: 'Télécharger les contenus autorisés',
                badgeText: 'Optionnel',
                isBadgePink: false,
                value: _offline,
                onChanged: (v) => setState(() => _offline = v),
              ),
              const SizedBox(height: 12),
              _ConsentItem(
                title: 'Partager avec un proche',
                description: 'Jamais sans votre accord',
                badgeText: 'Optionnel',
                isBadgePink: false,
                value: _share,
                onChanged: (v) => setState(() => _share = v),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Modifiable plus tard dans Profil',
                  style: AppTypography.bodyS.copyWith(
                    color: isDark
                        ? AppColors.darkMutedForeground
                        : AppColors.mutedForeground,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SbButton(text: 'Continuer', onPressed: _saveAndProceed),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentItem extends StatelessWidget {
  const _ConsentItem({
    required this.title,
    required this.description,
    required this.badgeText,
    required this.isBadgePink,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String description;
  final String badgeText;
  final bool isBadgePink;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SbCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
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
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.bodyS.copyWith(
                    color: isDark
                        ? AppColors.darkMutedForeground
                        : AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badgeText,
                  style: AppTypography.labelXs.copyWith(
                    color: isBadgePink
                        ? AppColors.pink
                        : AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SbToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

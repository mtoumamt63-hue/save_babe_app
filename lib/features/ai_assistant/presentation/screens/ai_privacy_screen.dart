import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_toggle.dart';

class AiPrivacyScreen extends ConsumerStatefulWidget {
  const AiPrivacyScreen({super.key});

  @override
  ConsumerState<AiPrivacyScreen> createState() => _AiPrivacyScreenState();
}

class _AiPrivacyScreenState extends ConsumerState<AiPrivacyScreen> {
  late bool _anonymize;
  late bool _history;
  late bool _medical;

  @override
  void initState() {
    super.initState();
    final p = ref.read(appUserStateProvider).aiPrivacy;
    _anonymize = p.anonymize;
    _history = p.history;
    _medical = p.medical;
  }

  void _save() {
    ref
        .read(appUserStateNotifierProvider.notifier)
        .update(
          (s) => s.copyWith(
            aiPrivacy: s.aiPrivacy.copyWith(
              anonymize: _anonymize,
              history: _history,
              medical: _medical,
            ),
          ),
        );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Choix enregistrés')));
    context.pop();
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
                title: 'Confidentialité de l\'assistant IA',
                subtitle: 'Vos données sensibles restent sous votre contrôle',
                onBack: () => context.pop(),
              ),
              _PrivacyRow(
                title: 'Anonymiser mes questions',
                subtitle: 'Votre nom n\'est jamais transmis',
                value: _anonymize,
                onChanged: (v) => setState(() => _anonymize = v),
              ),
              const SizedBox(height: 12),
              _PrivacyRow(
                title: 'Garder l\'historique',
                subtitle: 'Uniquement sur cet appareil',
                value: _history,
                onChanged: (v) => setState(() => _history = v),
              ),
              const SizedBox(height: 12),
              _PrivacyRow(
                title: 'Utiliser mon dossier médical',
                subtitle: 'Pour des réponses personnalisées',
                value: _medical,
                onChanged: (v) => setState(() => _medical = v),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'L\'IA ne reçoit que les informations nécessaires',
                    style: AppTypography.bodyS.copyWith(
                      color: isDark
                          ? AppColors.darkMutedForeground
                          : AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SbButton(text: 'Enregistrer mes choix', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  const _PrivacyRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
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
          const SizedBox(width: 12),
          SbToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

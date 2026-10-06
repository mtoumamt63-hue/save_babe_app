import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_private_badge.dart';
import '../../../../core/widgets/sb_text_field.dart';

class InviteScreen extends ConsumerStatefulWidget {
  const InviteScreen({super.key});

  @override
  ConsumerState<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends ConsumerState<InviteScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final partner = ref.read(appUserStateProvider).partner;
    _nameController = TextEditingController(text: partner?.name ?? '');
    _phoneController = TextEditingController(text: partner?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _savePartner() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || phone.isEmpty) return;

    ref
        .read(appUserStateNotifierProvider.notifier)
        .setPartner(Partner(name: name, phone: phone));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Proche de confiance enregistré')),
    );
    context.pop();
  }

  void _removePartner() {
    ref.read(appUserStateNotifierProvider.notifier).setPartner(null);
    _nameController.clear();
    _phoneController.clear();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Accès retiré')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasPartner = user.partner != null && user.partner!.name.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Inviter un proche',
                subtitle: 'Partagez votre suivi en toute sécurité',
                onBack: () => context.pop(),
              ),
              SbTextField(
                label: 'Nom ou lien de parenté',
                controller: _nameController,
                placeholder: 'Koffi (conjoint)',
              ),
              SbTextField(
                label: 'Numéro de téléphone',
                controller: _phoneController,
                placeholder: '+225 07 00 00 00',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              // Ce que cette personne verra
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ce que cette personne verra',
                          style: AppTypography.labelM.copyWith(
                            color: isDark
                                ? AppColors.darkCardForeground
                                : AppColors.cardForeground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const _PermissionLine(
                      text: 'Évolution des semaines de grossesse',
                    ),
                    const _PermissionLine(
                      text: 'Prochains rendez-vous médicaux',
                    ),
                    const _PermissionLine(
                      text: 'Notification d\'urgence en 1 tap',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Ce qui reste strictement privé
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.pink,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ce qui reste strictement privé',
                          style: AppTypography.labelM.copyWith(
                            color: isDark
                                ? AppColors.darkCardForeground
                                : AppColors.cardForeground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const _PermissionLine(
                      text: 'Questions posées à l\'assistant IA',
                    ),
                    const _PermissionLine(
                      text: 'Notes et données médicales détaillées',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SbButton(
                text: hasPartner
                    ? 'Mettre à jour le proche'
                    : 'Enregistrer et inviter',
                onPressed: _savePartner,
              ),
              if (hasPartner) ...[
                const SizedBox(height: 10),
                SbButton(
                  text: 'Retirer l\'accès au proche',
                  variant: SbButtonVariant.danger,
                  onPressed: _removePartner,
                ),
              ],
              const SbPrivateBadge(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionLine extends StatelessWidget {
  const _PermissionLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '• $text',
        style: AppTypography.bodyS.copyWith(
          color: isDark
              ? AppColors.darkMutedForeground
              : AppColors.mutedForeground,
        ),
      ),
    );
  }
}

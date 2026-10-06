import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_private_badge.dart';
import '../../../../core/widgets/sb_text_field.dart';

class BabyCreateScreen extends ConsumerStatefulWidget {
  const BabyCreateScreen({super.key});

  @override
  ConsumerState<BabyCreateScreen> createState() => _BabyCreateScreenState();
}

class _BabyCreateScreenState extends ConsumerState<BabyCreateScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _birthController;
  late final TextEditingController _weightController;
  String _sex = 'Fille';

  @override
  void initState() {
    super.initState();
    final baby = ref.read(appUserStateProvider).baby;
    _nameController = TextEditingController(text: baby?.name ?? '');
    _birthController = TextEditingController(
      text: baby?.birth ?? DateTime.now().toIso8601String().split('T')[0],
    );
    _weightController = TextEditingController(text: baby?.weight ?? '');
    _sex = baby?.sex ?? 'Fille';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate = DateTime.tryParse(_birthController.text) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() {
        _birthController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _saveBaby() {
    final name = _nameController.text.trim();
    final birth = _birthController.text.trim();
    if (name.isEmpty || birth.isEmpty) return;

    final baby = Baby(
      name: name,
      birth: birth,
      weight: _weightController.text.trim().isNotEmpty
          ? _weightController.text.trim()
          : '3.2',
      sex: _sex,
    );

    ref.read(appUserStateNotifierProvider.notifier).setBaby(baby);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Bienvenue $name !')));
    context.go('/app/baby');
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
              const SbHeader(
                title: 'Créer le profil du bébé',
                subtitle: 'Après la naissance',
              ),
              // Avatar
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: const BoxDecoration(
                    color: AppColors.successSoft,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('👶🏾', style: TextStyle(fontSize: 48)),
                ),
              ),
              SbTextField(
                label: 'Prénom du bébé',
                controller: _nameController,
                placeholder: 'Amani',
                onChanged: (_) => setState(() {}),
              ),
              SbTextField(
                label: 'Date de naissance',
                controller: _birthController,
                readOnly: true,
                onTap: _selectDate,
                suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
              ),
              SbTextField(
                label: 'Poids de naissance (kg)',
                controller: _weightController,
                placeholder: '3,2',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 6),
              // Choix sexe
              Row(
                children: ['Fille', 'Garçon'].map((s) {
                  final isSelected = _sex == s;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _sex = s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                      ? AppColors.darkPrimary.withValues(
                                          alpha: 0.2,
                                        )
                                      : AppColors.secondary)
                                : (isDark
                                      ? AppColors.darkCard
                                      : AppColors.card),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLg,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.primary)
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.border),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            s,
                            style: AppTypography.labelM.copyWith(
                              color: isSelected
                                  ? (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.primary)
                                  : (isDark
                                        ? AppColors.darkCardForeground
                                        : AppColors.cardForeground),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              SbButton(
                text: 'Créer le profil',
                onPressed: _nameController.text.trim().isNotEmpty
                    ? _saveBaby
                    : null,
              ),
              const SbPrivateBadge(
                text: 'Les informations restent privées et chiffrées',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

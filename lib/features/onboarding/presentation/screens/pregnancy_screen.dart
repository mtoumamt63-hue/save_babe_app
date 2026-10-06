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
import '../../../../core/widgets/sb_steps.dart';
import '../../../../core/widgets/sb_text_field.dart';

class PregnancyScreen extends ConsumerStatefulWidget {
  const PregnancyScreen({super.key});

  @override
  ConsumerState<PregnancyScreen> createState() => _PregnancyScreenState();
}

class _PregnancyScreenState extends ConsumerState<PregnancyScreen> {
  late String _lmp;
  late String _firstPregnancy;
  late final TextEditingController _centerController;
  late final TextEditingController _lmpController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserStateProvider);
    _lmp = user.lmp.isNotEmpty
        ? user.lmp
        : DateTime.now()
              .subtract(const Duration(days: 168))
              .toIso8601String()
              .split('T')[0];
    _firstPregnancy = user.firstPregnancy;
    _centerController = TextEditingController(text: user.center);
    _lmpController = TextEditingController(text: _lmp);
  }

  @override
  void dispose() {
    _centerController.dispose();
    _lmpController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate =
        DateTime.tryParse(_lmp) ?? now.subtract(const Duration(days: 70));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 300)),
      lastDate: now,
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() {
        _lmp = picked.toIso8601String().split('T')[0];
        _lmpController.text = _lmp;
      });
    }
  }

  void _saveAndProceed() async {
    await ref
        .read(appUserStateNotifierProvider.notifier)
        .update(
          (s) => s.copyWith(
            lmp: _lmp,
            firstPregnancy: _firstPregnancy,
            center: _centerController.text.trim(),
          ),
        );
    if (mounted) {
      context.push('/onboarding/consent');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dueStr = DateFormatter.dueDate(_lmp);
    final weeks = DateFormatter.weeksOf(_lmp);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Votre profil grossesse',
                onBack: () => context.pop(),
              ),
              const SbSteps(currentStep: 2),
              // Champ date des dernières règles avec tap sur DatePicker
              SbTextField(
                label: 'Date des dernières règles (DDR)',
                placeholder: _lmp.isNotEmpty ? _lmp : 'Sélectionnez une date',
                readOnly: true,
                onTap: _selectDate,
                suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                controller: _lmpController,
              ),
              // Carte résumé DPA
              SbCard(
                backgroundColor: isDark
                    ? AppColors.darkCard
                    : AppColors.secondary,
                borderColor: Colors.transparent,
                padding: const EdgeInsets.all(AppDimensions.pLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date prévue d\'accouchement',
                      style: AppTypography.labelM.copyWith(
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dueStr.isNotEmpty ? dueStr : '—',
                      style: AppTypography.displayM.copyWith(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                      ),
                    ),
                    if (_lmp.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$weeks semaines de grossesse',
                        style: AppTypography.bodyS.copyWith(
                          color: isDark
                              ? AppColors.darkMutedForeground
                              : AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Est-ce votre première grossesse ?',
                style: AppTypography.labelM.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _OptionButton(
                    label: 'Oui',
                    isSelected: _firstPregnancy == 'oui',
                    onTap: () => setState(() => _firstPregnancy = 'oui'),
                  ),
                  const SizedBox(width: 8),
                  _OptionButton(
                    label: 'Non',
                    isSelected: _firstPregnancy == 'non',
                    onTap: () => setState(() => _firstPregnancy = 'non'),
                  ),
                  const SizedBox(width: 8),
                  _OptionButton(
                    label: 'Je ne sais pas',
                    isSelected: _firstPregnancy == 'nsp',
                    onTap: () => setState(() => _firstPregnancy = 'nsp'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SbTextField(
                label: 'Centre de santé préféré',
                controller: _centerController,
                placeholder: 'CHU de Cocody',
              ),
              const SizedBox(height: 12),
              SbButton(
                text: 'Continuer',
                onPressed: _lmp.isNotEmpty ? _saveAndProceed : null,
              ),
              const SizedBox(height: 8),
              SbButton(
                text: 'Enregistrer pour plus tard',
                variant: SbButtonVariant.ghost,
                onPressed: _saveAndProceed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isSelected
        ? (isDark
              ? AppColors.darkPrimary.withValues(alpha: 0.2)
              : AppColors.secondary)
        : (isDark ? AppColors.darkCard : AppColors.card);
    final borderColor = isSelected
        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
        : (isDark ? AppColors.darkBorder : AppColors.border);
    final textColor = isSelected
        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
        : (isDark ? AppColors.darkCardForeground : AppColors.cardForeground);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.bodyM.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

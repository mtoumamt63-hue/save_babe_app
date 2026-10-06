import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_text_field.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  bool _isAdding = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController(
    text: '09:00',
  );
  final TextEditingController _placeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _placeController.text = ref.read(appUserStateProvider).center;
    _dateController.text = DateTime.now()
        .add(const Duration(days: 7))
        .toIso8601String()
        .split('T')[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _saveAppointment() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final appt = Appointment(
      id: const Uuid().v4(),
      title: title,
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      place: _placeController.text.trim().isNotEmpty
          ? _placeController.text.trim()
          : 'Centre de santé',
    );

    ref.read(appUserStateNotifierProvider.notifier).addAppointment(appt);
    _titleController.clear();
    setState(() => _isAdding = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Rendez-vous ajouté')));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sortedAppts = [...user.appointments]
      ..sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Rendez-vous',
                subtitle: '${user.appointments.length} rendez-vous prévus',
              ),
              // Liste des RDV
              if (sortedAppts.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Text(
                      'Aucun rendez-vous prévu',
                      style: AppTypography.bodyM.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                      ),
                    ),
                  ),
                )
              else
                ...sortedAppts.map((r) {
                  final dt = DateTime.tryParse(r.date);
                  final dayStr = dt != null ? dt.day.toString() : '—';
                  final monthStr = dt != null
                      ? DateFormatter.monthShort(dt).toUpperCase()
                      : '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SbCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkPrimary.withValues(alpha: 0.2)
                                  : AppColors.secondary,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusLg,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  dayStr,
                                  style: AppTypography.displayM.copyWith(
                                    fontSize: 20,
                                    color: isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.primary,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  monthStr,
                                  style: TextStyle(
                                    fontFamily: 'Figtree',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  style: AppTypography.labelM.copyWith(
                                    color: isDark
                                        ? AppColors.darkCardForeground
                                        : AppColors.cardForeground,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${r.time} · ${r.place}',
                                  style: AppTypography.bodyS.copyWith(
                                    color: isDark
                                        ? AppColors.darkMutedForeground
                                        : AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                              color: AppColors.mutedForeground,
                            ),
                            onPressed: () {
                              ref
                                  .read(appUserStateNotifierProvider.notifier)
                                  .removeAppointment(r.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 16),
              // Formulaire d'ajout
              if (_isAdding)
                SbCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nouveau rendez-vous',
                        style: AppTypography.labelL.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SbTextField(
                        label: 'Motif de la consultation',
                        controller: _titleController,
                        placeholder: 'Consultation prénatale 4',
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SbTextField(
                              label: 'Date (AAAA-MM-JJ)',
                              controller: _dateController,
                              placeholder: '2026-10-20',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SbTextField(
                              label: 'Heure',
                              controller: _timeController,
                              placeholder: '09:30',
                            ),
                          ),
                        ],
                      ),
                      SbTextField(
                        label: 'Lieu / Centre de santé',
                        controller: _placeController,
                        placeholder: 'Centre de santé',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SbButton(
                              text: 'Annuler',
                              variant: SbButtonVariant.outline,
                              onPressed: () =>
                                  setState(() => _isAdding = false),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SbButton(
                              text: 'Enregistrer',
                              onPressed: _saveAppointment,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                SbButton(
                  text: '+ Ajouter un rendez-vous',
                  onPressed: () => setState(() => _isAdding = true),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

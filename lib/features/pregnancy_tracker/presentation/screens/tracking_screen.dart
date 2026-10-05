import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../data/pregnancy_dataset.dart';
import '../../domain/models/country_pack.dart';
import '../../domain/services/pregnancy_calculation_service.dart';
import '../widgets/danger_signs_banner.dart';
import '../widgets/nutrition_recommendation_card.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  static const _service = PregnancyCalculationService();

  CountryPack _packFor(String country) {
    final normalized = country.toLowerCase();
    if (normalized.contains('rdc') ||
        normalized.contains('congo') && normalized.contains('démocratique')) {
      return rdcPack;
    }
    const malariaCountries = [
      'côte d’ivoire',
      "côte d'ivoire",
      'mali',
      'bénin',
      'benin',
      'cameroun',
      'cameroon',
      'congo',
    ];
    if (malariaCountries.any(normalized.contains)) {
      return subSaharanMalariaGenericPack;
    }
    return whoGenericPack;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lmp = DateFormatter.parseLmp(user.lmp);

    if (lmp == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SbHeader(
                  title: 'Suivi de grossesse',
                  subtitle: 'Date des dernières règles manquante',
                ),
                SbCard(
                  child: Text(
                    'Renseignez votre date des dernières règles dans votre profil pour calculer précisément les semaines d’aménorrhée et la date prévue d’accouchement.',
                    style: AppTypography.bodyM.copyWith(
                      color: isDark
                          ? AppColors.darkCardForeground
                          : AppColors.cardForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final age = _service.ageAt(lmp);
    final latestMeasures = <String, Measure>{};
    for (final measure in user.measures) {
      latestMeasures.putIfAbsent(measure.kind, () => measure);
    }
    final displayWeek = age.weeks.clamp(1, 41).toInt();
    final info = pregnancyDataset.firstWhere((e) => e.week == displayWeek);
    final due = DateFormatter.dueDate(user.lmp);
    final progress = _service.progress(lmp);
    final trimester = _service.trimesterOf(age.weeks);
    final pack = _packFor(user.country);
    final nextContact = _service.nextContact(lmp, pack);
    final contacts = _service.ancSchedule(lmp, pack);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Suivi de grossesse',
                subtitle: due.isNotEmpty
                    ? 'Accouchement prévu le $due'
                    : 'Calcul de la DPA indisponible',
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppColors.darkCard,
                            AppColors.darkPrimary.withValues(alpha: 0.3),
                          ]
                        : [AppColors.secondary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Âge gestationnel',
                      style: AppTypography.bodyS.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${age.weeks} SA + ${age.days} j',
                      style: AppTypography.displayL.copyWith(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      info.babySize,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyM.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 12,
                        value: progress,
                        backgroundColor: isDark
                            ? AppColors.darkBorder
                            : Colors.white,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.pink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${age.weeks}/40 SA · Trimestre $trimester',
                      style: AppTypography.bodyS.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DangerSignsBanner(
                onOpenSigns: () => context.push('/danger-signs'),
                onEmergency: () => context.push('/emergency'),
                onNotifyTrusted: () => context.push('/invite'),
              ),
              const SizedBox(height: 16),
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cette semaine — SA $displayWeek',
                      style: AppTypography.labelM.copyWith(
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.child_care_rounded,
                      title: 'Développement du bébé',
                      text: info.development,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.favorite_outline_rounded,
                      title: 'Votre corps',
                      text: info.motherBody,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.lightbulb_outline_rounded,
                      title: 'Conseil',
                      text: info.tip,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Les tailles et poids sont des moyennes. La biométrie échographique réalisée par un soignant fait foi.',
                      style: AppTypography.bodyS.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              NutritionRecommendationCard(
                trimester: trimester,
                onTap: () => context.push('/nutrition-full'),
              ),
              const SizedBox(height: 12),
              _ActionGrid(
                actions: [
                  _Action(
                    '📚',
                    'Toutes les semaines',
                    () => context.push('/pregnancy-weeks?week=$displayWeek'),
                  ),
                  _Action(
                    '🥗',
                    'Nutrition 1–9 mois',
                    () => context.push('/nutrition-full'),
                  ),
                  _Action(
                    '📅',
                    'Dates des CPN',
                    () => context.push('/prenatal'),
                  ),
                  _Action(
                    '🫶🏾',
                    'Préparer l’accouchement',
                    () => context.push('/childbirth'),
                  ),
                  _Action(
                    '🌿',
                    'Après l’accouchement',
                    () => context.push('/postpartum'),
                  ),
                  _Action(
                    '👶🏾',
                    'Soins du nouveau-né',
                    () => context.push('/newborn-guide'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Consultations prénatales',
                style: AppTypography.labelL.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 8),
              if (nextContact != null)
                SbCard(
                  borderColor: isDark
                      ? AppColors.darkPrimary
                      : AppColors.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prochain contact : ${nextContact.label}',
                        style: AppTypography.labelM.copyWith(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormatter.formatFR(nextContact.date),
                        style: AppTypography.bodyM.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                      if (nextContact.keyPoints.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          nextContact.keyPoints.join(' • '),
                          style: AppTypography.bodyS.copyWith(
                            color: isDark
                                ? AppColors.darkMutedForeground
                                : AppColors.mutedForeground,
                            height: 1.35,
                          ),
                        ),
                      ],
                      if (nextContact.iptpDose) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Zone palustre : une dose de TPIg-SP peut être prévue selon le protocole local et l’avis du soignant.',
                          style: AppTypography.bodyS.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              ...contacts.map((contact) {
                final isPast = contact.date.isBefore(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                  ),
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SbCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPast
                              ? Icons.check_circle_rounded
                              : Icons.event_outlined,
                          color: isPast
                              ? AppColors.success
                              : (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact.label,
                                style: AppTypography.labelM.copyWith(
                                  color: isDark
                                      ? AppColors.darkCardForeground
                                      : AppColors.cardForeground,
                                ),
                              ),
                              Text(
                                DateFormatter.formatFR(contact.date),
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
                );
              }),
              if (user.record.isNotEmpty) ...[
                const SizedBox(height: 12),
                SbCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mon dossier',
                        style: AppTypography.labelM.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...user.record.map(
                        (record) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  record.label,
                                  style: AppTypography.bodyS.copyWith(
                                    color: isDark
                                        ? AppColors.darkMutedForeground
                                        : AppColors.mutedForeground,
                                  ),
                                ),
                              ),
                              Text(
                                record.value,
                                style: AppTypography.bodyM.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkCardForeground
                                      : AppColors.cardForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mes indicateurs de santé',
                      style: AppTypography.labelM,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Enregistrez votre poids, votre tension artérielle et votre glycémie à jeun pour suivre leur évolution, voir l’historique et repérer les valeurs qui nécessitent de contacter un soignant.',
                      style: AppTypography.bodyS.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    _LatestMeasureRow(
                      label: 'Poids',
                      value: latestMeasures['poids']?.value,
                      unit: 'kg',
                    ),
                    _LatestMeasureRow(
                      label: 'Tension',
                      value: latestMeasures['tension']?.value,
                      unit: 'mmHg',
                    ),
                    _LatestMeasureRow(
                      label: 'Glycémie à jeun',
                      value: latestMeasures['glycemie']?.value,
                      unit: 'mg/dL',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SbButton(
                text: 'Ouvrir mes indicateurs · poids, tension, glycémie',
                onPressed: () => context.push('/app/tracking/metrics'),
              ),
              const SizedBox(height: 12),
              Text(
                'Cette application ne remplace pas la consultation avec un médecin, une sage-femme ou un centre de santé.',
                style: AppTypography.bodyS.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestMeasureRow extends StatelessWidget {
  const _LatestMeasureRow({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String? value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodyS)),
          Text(
            value == null ? 'À saisir' : '$value $unit',
            style: AppTypography.bodyS.copyWith(
              fontWeight: FontWeight.w700,
              color: value == null
                  ? (isDark
                        ? AppColors.darkMutedForeground
                        : AppColors.mutedForeground)
                  : (isDark ? AppColors.darkPrimary : AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Action {
  const _Action(this.emoji, this.label, this.onTap);
  final String emoji;
  final String label;
  final VoidCallback onTap;
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.actions});
  final List<_Action> actions;
  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: actions.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.55,
    ),
    itemBuilder: (_, i) => InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: actions[i].onTap,
      child: SbCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(actions[i].emoji, style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 6),
            Text(
              actions[i].label,
              textAlign: TextAlign.center,
              style: AppTypography.labelS,
            ),
          ],
        ),
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.pink),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyS.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: AppTypography.bodyM.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

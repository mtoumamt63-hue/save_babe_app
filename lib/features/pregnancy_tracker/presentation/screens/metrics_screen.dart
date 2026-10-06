import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../../domain/services/metric_evaluator.dart';
import '../widgets/metric_chart_card.dart';

class MetricsScreen extends ConsumerStatefulWidget {
  const MetricsScreen({super.key});

  @override
  ConsumerState<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends ConsumerState<MetricsScreen> {
  static const MetricEvaluator _evaluator = MetricEvaluator();

  String _selectedKind = 'poids';
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  bool _showHistory = false;

  static const Map<String, Map<String, String>> _meta = {
    'poids': {'label': 'Poids', 'unit': 'kg', 'placeholder': '64.5'},
    'tension': {'label': 'Tension', 'unit': 'mmHg', 'placeholder': '120/80'},
    'glycemie': {
      'label': 'Glycémie à jeun',
      'unit': 'mg/dL',
      'placeholder': '90',
    },
  };

  @override
  void dispose() {
    _valueController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  String _normalizeNumber(String value) => value.trim().replaceAll(',', '.');

  MetricStatus? _statusFor({
    required String kind,
    required String value,
    required AppUserState user,
    DateTime? measuredAt,
  }) {
    if (kind == 'tension') {
      final parts = value.split('/');
      if (parts.length != 2) return null;
      final systolic = int.tryParse(parts[0].trim());
      final diastolic = int.tryParse(parts[1].trim());
      if (systolic == null || diastolic == null || systolic <= diastolic) {
        return null;
      }
      return _evaluator.bloodPressure(systolic: systolic, diastolic: diastolic);
    }

    if (kind == 'glycemie') {
      final glucose = double.tryParse(_normalizeNumber(value));
      if (glucose == null || glucose <= 0) return null;
      return _evaluator.fastingGlucose(value: glucose, inMmolPerL: false);
    }

    if (kind == 'poids') {
      final weight = double.tryParse(_normalizeNumber(value));
      if (weight == null ||
          weight <= 0 ||
          user.prePregnancyWeightKg == null ||
          user.heightM == null ||
          user.heightM! <= 0) {
        return null;
      }
      final bmi = _evaluator.bmi(
        weightKg: user.prePregnancyWeightKg!,
        heightM: user.heightM!,
      );
      final category = _evaluator.bmiCategory(bmi);
      final weeks = DateFormatter.weeksOf(user.lmp);
      return _evaluator.weightGain(
        gainKg: weight - user.prePregnancyWeightKg!,
        category: category,
        completedWeeks: measuredAt == null
            ? weeks
            : DateFormatter.weeksOf(user.lmp, now: measuredAt),
      );
    }

    return null;
  }

  Future<void> _addMeasure() async {
    final user = ref.read(appUserStateProvider);
    final value = _selectedKind == 'tension'
        ? '${_systolicController.text.trim()}/${_diastolicController.text.trim()}'
        : _valueController.text.trim();
    if (value.isEmpty) return;

    final status = _statusFor(kind: _selectedKind, value: value, user: user);
    if (_selectedKind == 'tension' && status == null) {
      final systolic = int.tryParse(_systolicController.text.trim());
      final diastolic = int.tryParse(_diastolicController.text.trim());
      if (systolic == null || diastolic == null) {
        _showError('Renseignez les deux valeurs de tension.');
      } else if (systolic <= diastolic) {
        _showError(
          'La valeur systolique doit être supérieure à la diastolique.',
        );
      } else {
        _showError('Vérifiez les valeurs de tension saisies.');
      }
      return;
    }
    if ((_selectedKind == 'poids' || _selectedKind == 'glycemie') &&
        (double.tryParse(_normalizeNumber(value)) == null ||
            double.parse(_normalizeNumber(value)) <= 0)) {
      _showError('Entrez une valeur numérique valide.');
      return;
    }

    final newMeasure = Measure(
      id: const Uuid().v4(),
      kind: _selectedKind,
      value: value,
      date: DateFormatter.formatFR(DateTime.now()),
    );

    await ref
        .read(appUserStateNotifierProvider.notifier)
        .addMeasure(newMeasure);
    if (!mounted) return;
    if (_selectedKind == 'tension') {
      _systolicController.clear();
      _diastolicController.clear();
    } else {
      _valueController.clear();
    }
    setState(() {});

    if (status?.level == AlertLevel.urgent) {
      _showStatusDialog(status!, emergency: true);
    } else if (status?.level == AlertLevel.warning) {
      _showStatusDialog(status!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(status?.message ?? 'Mesure ajoutée')),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showStatusDialog(
    MetricStatus status, {
    bool emergency = false,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(emergency ? 'Attention — urgence' : 'Mesure à surveiller'),
        content: Text(status.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fermer'),
          ),
          if (emergency)
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.push('/emergency');
              },
              child: const Text('Urgence'),
            ),
        ],
      ),
    );
  }

  Future<void> _editPregnancyProfile(AppUserState user) async {
    final weightController = TextEditingController(
      text: user.prePregnancyWeightKg?.toStringAsFixed(1) ?? '',
    );
    final heightController = TextEditingController(
      text: user.heightM != null
          ? (user.heightM! * 100).toStringAsFixed(0)
          : '',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Profil avant grossesse'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Poids avant grossesse (kg)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Taille (cm)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              final weight = double.tryParse(
                _normalizeNumber(weightController.text),
              );
              final heightCm = double.tryParse(
                _normalizeNumber(heightController.text),
              );
              if (weight == null ||
                  weight <= 0 ||
                  heightCm == null ||
                  heightCm <= 0) {
                return;
              }
              await ref
                  .read(appUserStateNotifierProvider.notifier)
                  .setPregnancyProfile(
                    prePregnancyWeightKg: weight,
                    heightM: heightCm / 100,
                  );
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    weightController.dispose();
    heightController.dispose();
  }

  String _bmiLabel(BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return 'Insuffisance pondérale';
      case BmiCategory.normal:
        return 'Poids normal';
      case BmiCategory.overweight:
        return 'Surpoids';
      case BmiCategory.obese:
        return 'Obésité';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentMeta = _meta[_selectedKind]!;
    final selectedMeasures = user.measures
        .where((measure) => measure.kind == _selectedKind)
        .toList();

    double? bmi;
    BmiCategory? bmiCategory;
    WeightBand? totalBand;
    if (user.prePregnancyWeightKg != null &&
        user.heightM != null &&
        user.heightM! > 0) {
      bmi = _evaluator.bmi(
        weightKg: user.prePregnancyWeightKg!,
        heightM: user.heightM!,
      );
      bmiCategory = _evaluator.bmiCategory(bmi);
      totalBand = _evaluator.totalRecommended(bmiCategory);
    }

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SbHeader(
                  title: 'Mes indicateurs',
                  subtitle: 'Poids, tension et glycémie',
                  onBack: () => context.pop(),
                ),
                Row(
                  children: _meta.keys.map((kind) {
                    final meta = _meta[kind]!;
                    final matching = user.measures.where((m) => m.kind == kind);
                    final lastValue = matching.isNotEmpty
                        ? matching.first.value
                        : null;
                    final selected = kind == _selectedKind;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedKind = kind),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? (isDark
                                        ? AppColors.darkPrimary.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.secondary)
                                  : (isDark
                                        ? AppColors.darkCard
                                        : AppColors.card),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radius2xl,
                              ),
                              border: Border.all(
                                color: selected
                                    ? (isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.primary)
                                    : (isDark
                                          ? AppColors.darkBorder
                                          : AppColors.border),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  meta['label']!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: AppTypography.bodyS.copyWith(
                                    color: isDark
                                        ? AppColors.darkMutedForeground
                                        : AppColors.mutedForeground,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lastValue ?? '—',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.displayM.copyWith(
                                    fontSize: 18,
                                    color: isDark
                                        ? AppColors.darkCardForeground
                                        : AppColors.cardForeground,
                                  ),
                                ),
                                Text(
                                  meta['unit']!,
                                  style: AppTypography.bodyS.copyWith(
                                    color: isDark
                                        ? AppColors.darkMutedForeground
                                        : AppColors.mutedForeground,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                if (_selectedKind == 'poids') ...[
                  SbCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Repère de prise de poids',
                                style: AppTypography.labelM.copyWith(
                                  color: isDark
                                      ? AppColors.darkCardForeground
                                      : AppColors.cardForeground,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _editPregnancyProfile(user),
                              child: Text(
                                bmi == null ? 'Renseigner' : 'Modifier',
                              ),
                            ),
                          ],
                        ),
                        if (bmi == null)
                          Text(
                            'Renseignez votre taille et votre poids avant grossesse pour calculer l’IMC de départ et la fourchette de prise de poids recommandée.',
                            style: AppTypography.bodyS.copyWith(
                              color: isDark
                                  ? AppColors.darkMutedForeground
                                  : AppColors.mutedForeground,
                            ),
                          )
                        else ...[
                          Text(
                            'IMC avant grossesse : ${bmi.toStringAsFixed(1)} — ${_bmiLabel(bmiCategory!)}',
                            style: AppTypography.bodyM.copyWith(
                              color: isDark
                                  ? AppColors.darkCardForeground
                                  : AppColors.cardForeground,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Prise totale indicative : ${totalBand!.minKg.toStringAsFixed(1)} à ${totalBand.maxKg.toStringAsFixed(1)} kg.',
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
                  const SizedBox(height: 12),
                ],
                SbCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedKind == 'tension') ...[
                        Text(
                          'Saisir la tension (mmHg)',
                          style: AppTypography.labelM,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SbTextField(
                                label: 'Systolique',
                                controller: _systolicController,
                                placeholder: '120',
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SbTextField(
                                label: 'Diastolique',
                                controller: _diastolicController,
                                placeholder: '80',
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                        _LiveMetricStatus(
                          status: _statusFor(
                            kind: 'tension',
                            value:
                                '${_systolicController.text}/${_diastolicController.text}',
                            user: user,
                          ),
                          isComplete:
                              _systolicController.text.isNotEmpty &&
                              _diastolicController.text.isNotEmpty,
                          hint: 'Entrez les deux valeurs pour afficher le repère couleur.',
                        ),
                      ] else ...[
                        SbTextField(
                          label:
                              'Nouvelle mesure — ${currentMeta['label']} (${currentMeta['unit']})',
                          controller: _valueController,
                          placeholder: currentMeta['placeholder'],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        if (_selectedKind == 'glycemie')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Mesure à jeun en mg/dL. Une valeur saisie ici est un repère, pas un diagnostic.',
                              style: AppTypography.bodyS.copyWith(
                                color: isDark
                                    ? AppColors.darkMutedForeground
                                    : AppColors.mutedForeground,
                              ),
                            ),
                          ),
                        _LiveMetricStatus(
                          status: _statusFor(
                            kind: _selectedKind,
                            value: _valueController.text,
                            user: user,
                          ),
                          isComplete:
                              _valueController.text.isNotEmpty &&
                              (_selectedKind != 'poids' ||
                                  (user.prePregnancyWeightKg != null &&
                                      user.heightM != null)),
                          hint:
                              _selectedKind == 'poids' &&
                                  (user.prePregnancyWeightKg == null ||
                                      user.heightM == null)
                              ? 'Renseignez le poids et la taille avant grossesse pour comparer votre prise de poids.'
                              : 'Saisissez une valeur pour afficher le repère couleur.',
                        ),
                      ],
                      const SizedBox(height: 8),
                      SbButton(
                        text: '+ Ajouter une mesure',
                        onPressed: _addMeasure,
                      ),
                    ],
                  ),
                ),
                if (selectedMeasures.isEmpty) ...[
                  const SizedBox(height: 12),
                  SbCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Aucune mesure de ${currentMeta['label']!.toLowerCase()} enregistrée. Saisissez la valeur indiquée dans votre carnet puis touchez « Ajouter une mesure » pour afficher votre évolution ici.',
                            style: AppTypography.bodyS,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _ThresholdCard(kind: _selectedKind),
                const SizedBox(height: 12),
                MetricChartCard(
                  title: 'Évolution — ${currentMeta['label']}',
                  unit: currentMeta['unit']!,
                  kind: _selectedKind,
                  measures: selectedMeasures,
                ),
                const SizedBox(height: 12),
                Center(
                  child: SbButton(
                    text: _showHistory
                        ? 'Masquer l’historique'
                        : 'Voir l’historique',
                    variant: SbButtonVariant.ghost,
                    onPressed: () =>
                        setState(() => _showHistory = !_showHistory),
                  ),
                ),
                if (_showHistory) ...[
                  const SizedBox(height: 12),
                  if (user.measures.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Aucune mesure pour l’instant',
                          style: AppTypography.bodyM.copyWith(
                            color: isDark
                                ? AppColors.darkMutedForeground
                                : AppColors.mutedForeground,
                          ),
                        ),
                      ),
                    )
                  else
                    ...user.measures.map((measure) {
                      final meta =
                          _meta[measure.kind] ??
                          {'label': measure.kind, 'unit': ''};
                      final status = _statusFor(
                        kind: measure.kind,
                        value: measure.value,
                        user: user,
                        measuredAt: DateFormatter.parseFR(measure.date),
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SbCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          borderColor: status == null
                              ? null
                              : _statusColor(status.level)
                                    .withValues(alpha: 0.35),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${meta['label']} · ${measure.date}',
                                      style: AppTypography.bodyM.copyWith(
                                        color: isDark
                                            ? AppColors.darkCardForeground
                                            : AppColors.cardForeground,
                                      ),
                                    ),
                                    if (status != null)
                                      Text(
                                        status.message,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.bodyS.copyWith(
                                          color: _statusColor(status.level),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${measure.value} ${meta['unit']}',
                                style: AppTypography.labelM.copyWith(
                                  color: status == null
                                      ? (isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.primary)
                                      : _statusColor(status.level),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
                const SizedBox(height: 12),
                Text(
                  'SaveBabe ne pose pas de diagnostic. Toute valeur anormale ou tout symptôme inquiétant doit être confirmé et pris en charge par un professionnel de santé.',
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
      ),
    );
  }

  Color _statusColor(AlertLevel level) {
    switch (level) {
      case AlertLevel.ok:
        return AppColors.success;
      case AlertLevel.warning:
        return const Color(0xFFB26A00);
      case AlertLevel.urgent:
        return AppColors.destructive;
    }
  }
}

class _ThresholdCard extends StatelessWidget {
  const _ThresholdCard({required this.kind});
  final String kind;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    late List<(String, Color)> levels;
    late String note;
    switch (kind) {
      case 'tension':
        levels = [
          ('Systolique < 140 et diastolique < 90 · repère', AppColors.success),
          (
            'Systolique ≥ 140 ou diastolique ≥ 90 · surveiller',
            const Color(0xFFB26A00),
          ),
          (
            'Systolique ≥ 160 ou diastolique ≥ 110 · urgence',
            AppColors.destructive,
          ),
        ];
        note = 'Si céphalées intenses, vision floue, douleur sous les côtes ou gonflement brutal, contactez sans attendre un service de santé.';
        break;
      case 'glycemie':
        levels = [
          ('Moins de 92 mg/dL à jeun', AppColors.success),
          ('92–125 mg/dL · à confirmer', const Color(0xFFB26A00)),
          ('126 mg/dL ou plus · avis rapide', AppColors.destructive),
        ];
        note = 'Ces repères ne remplacent pas un test prescrit ni l’interprétation d’un professionnel de santé.';
        break;
      default:
        levels = [
          ('Dans la fourchette calculée selon le profil', AppColors.success),
          ('En dehors de la fourchette · à discuter', const Color(0xFFB26A00)),
        ];
        note = 'La prise de poids dépend de l’IMC avant grossesse et du nombre de semaines. Il n’existe pas un seuil unique en kilogrammes pour tout le monde.';
    }
    return SbCard(
      backgroundColor: isDark
          ? AppColors.darkPrimary.withValues(alpha: 0.08)
          : AppColors.secondary.withValues(alpha: 0.55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Repères de couleur', style: AppTypography.labelM),
          const SizedBox(height: 8),
          ...levels.map(
            (level) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: level.$2,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(level.$1, style: AppTypography.bodyS)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(note, style: AppTypography.bodyS.copyWith(height: 1.35)),
        ],
      ),
    );
  }
}

class _LiveMetricStatus extends StatelessWidget {
  const _LiveMetricStatus({
    required this.status,
    required this.isComplete,
    required this.hint,
  });

  final MetricStatus? status;
  final bool isComplete;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final color = switch (status?.level) {
      AlertLevel.ok => AppColors.success,
      AlertLevel.warning => const Color(0xFFB26A00),
      AlertLevel.urgent => AppColors.destructive,
      null => Theme.of(context).colorScheme.outline,
    };
    final message =
        status?.message ??
        (isComplete ? 'Vérifiez le format et les valeurs saisies.' : hint);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: .4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            status?.level == AlertLevel.urgent
                ? Icons.error_rounded
                : status?.level == AlertLevel.warning
                ? Icons.warning_amber_rounded
                : status?.level == AlertLevel.ok
                ? Icons.check_circle_rounded
                : Icons.info_outline_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyS.copyWith(color: color, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

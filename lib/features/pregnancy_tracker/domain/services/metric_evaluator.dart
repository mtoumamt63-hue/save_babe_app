/// Évaluation des mesures (poids, tension, glycémie, hémoglobine).
/// L'application ne pose PAS de diagnostic : elle colore la mesure et propose une conduite.
enum AlertLevel { ok, warning, urgent }

class MetricStatus {
  final AlertLevel level;
  final String message;
  const MetricStatus(this.level, this.message);
}

enum BmiCategory { underweight, normal, overweight, obese }

class WeightBand {
  final double minKg;
  final double maxKg;
  const WeightBand(this.minKg, this.maxKg);
}

class MetricEvaluator {
  const MetricEvaluator();

  // ---------- Tension artérielle ----------
  MetricStatus bloodPressure({required int systolic, required int diastolic}) {
    if (systolic >= 160 || diastolic >= 110) {
      return const MetricStatus(
        AlertLevel.urgent,
        'Tension très élevée : allez immédiatement en structure de santé.',
      );
    }
    if (systolic >= 140 || diastolic >= 90) {
      return const MetricStatus(
        AlertLevel.warning,
        'Tension élevée : reposez-vous 15 minutes puis mesurez à nouveau. Si elle reste élevée, consultez rapidement un soignant (risque de pré-éclampsie, surtout après 20 SA).',
      );
    }
    if (systolic < 90) {
      return const MetricStatus(
        AlertLevel.warning,
        'Tension basse : allongez-vous sur le côté et buvez. Consultez si cela se répète ou en cas de vertiges.',
      );
    }
    return const MetricStatus(
      AlertLevel.ok,
      'Tension dans la zone habituelle.',
    );
  }

  // ---------- Glycémie à jeun (repère, pas un diagnostic) ----------
  static const double mgPerMmol = 18.016;

  MetricStatus fastingGlucose({required double value, bool inMmolPerL = true}) {
    final mmol = inMmolPerL ? value : value / mgPerMmol;
    if (mmol >= 7.0) {
      return const MetricStatus(
        AlertLevel.urgent,
        'Valeur élevée : consultez rapidement un soignant.',
      );
    }
    if (mmol >= 5.1) {
      return const MetricStatus(
        AlertLevel.warning,
        'Zone compatible avec un diabète gestationnel : parlez-en à votre soignant pour un test confirmé.',
      );
    }
    return const MetricStatus(AlertLevel.ok, 'Dans la zone attendue à jeun.');
  }

  // ---------- Hémoglobine (g/dL) ----------
  MetricStatus hemoglobin(double gPerDl) {
    if (gPerDl < 7.0) {
      return const MetricStatus(
        AlertLevel.urgent,
        'Anémie sévère : prise en charge urgente.',
      );
    }
    if (gPerDl < 11.0) {
      return const MetricStatus(
        AlertLevel.warning,
        'Anémie : voyez votre soignant (traitement et alimentation riche en fer).',
      );
    }
    return const MetricStatus(AlertLevel.ok, 'Valeur normale.');
  }

  // ---------- Prise de poids (IOM) ----------
  double bmi({required double weightKg, required double heightM}) =>
      weightKg / (heightM * heightM);

  BmiCategory bmiCategory(double bmi) {
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 25) return BmiCategory.normal;
    if (bmi < 30) return BmiCategory.overweight;
    return BmiCategory.obese;
  }

  /// Rythme hebdomadaire (kg/sem) aux 2e et 3e trimestres : (min, max).
  List<double> _weeklyRate(BmiCategory c) {
    switch (c) {
      case BmiCategory.underweight:
        return [0.44, 0.58];
      case BmiCategory.normal:
        return [0.35, 0.50];
      case BmiCategory.overweight:
        return [0.23, 0.33];
      case BmiCategory.obese:
        return [0.17, 0.27];
    }
  }

  /// Prise de poids totale recommandée (kg) : (min, max).
  WeightBand totalRecommended(BmiCategory c) {
    switch (c) {
      case BmiCategory.underweight:
        return const WeightBand(12.5, 18);
      case BmiCategory.normal:
        return const WeightBand(11.5, 16);
      case BmiCategory.overweight:
        return const WeightBand(7, 11.5);
      case BmiCategory.obese:
        return const WeightBand(5, 9);
    }
  }

  /// Bande de prise de poids attendue à `completedWeeks` SA.
  /// 1er trimestre : 0,5 à 2 kg au total ; ensuite rythme hebdomadaire IOM.
  WeightBand expectedGain(BmiCategory c, int completedWeeks) {
    final r = _weeklyRate(c);
    if (completedWeeks <= 13) {
      final f = completedWeeks <= 0 ? 0.0 : completedWeeks / 13.0;
      return WeightBand(0.5 * f, 2.0 * f);
    }
    final extra = completedWeeks - 13;
    return WeightBand(0.5 + r[0] * extra, 2.0 + r[1] * extra);
  }

  MetricStatus weightGain({
    required double gainKg,
    required BmiCategory category,
    required int completedWeeks,
  }) {
    final band = expectedGain(category, completedWeeks);
    if (gainKg > band.maxKg + 0.5) {
      return const MetricStatus(
        AlertLevel.warning,
        'Votre prise de poids est un peu au-dessus de la zone indiquée. Parlez-en à votre soignant, sans vous inquiéter ni faire de régime.',
      );
    }
    if (gainKg < band.minKg - 0.5) {
      return const MetricStatus(
        AlertLevel.warning,
        'Votre prise de poids est un peu en dessous de la zone indiquée. Parlez-en à votre soignant et mangez des repas variés et plus fréquents.',
      );
    }
    return const MetricStatus(
      AlertLevel.ok,
      'Votre prise de poids est dans la zone recommandée.',
    );
  }
}

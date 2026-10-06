import '../models/country_pack.dart';

/// Âge gestationnel : semaines d'aménorrhée (SA) + jours.
class GestationalAge {
  final int weeks;
  final int days;
  const GestationalAge(this.weeks, this.days);

  int get totalDays => weeks * 7 + days;

  @override
  String toString() => '$weeks SA + $days j';
}

/// Un contact de soins prénatals (CPN).
class AncContact {
  final int number;
  final int week; // semaine cible (pour le contact 1 : "au plus tard")
  final DateTime date;
  final String label;
  final List<String> keyPoints;
  final bool iptpDose; // dose de TPIg-SP suggérée à ce contact

  const AncContact({
    required this.number,
    required this.week,
    required this.date,
    required this.label,
    this.keyPoints = const [],
    this.iptpDose = false,
  });
}

/// Calculs obstétriques de SaveBabe. Aucune dépendance Flutter : testable seule.
class PregnancyCalculationService {
  const PregnancyCalculationService();

  /// Règle de Naegele (convention OMS) : DDR + 280 jours = 40 SA.
  static const int pregnancyDays = 280;
  static const int termWeek = 37; // « à terme » à partir de 37 SA
  static const int postTermWeek =
      41; // surveillance renforcée à partir de 41 SA
  static const int maxPlausibleDays = 44 * 7;

  DateTime _utcDay(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  /// DDR plausible : pas dans le futur et pas plus de 44 semaines dans le passé.
  bool isValidLmp(DateTime lmp, {DateTime? now}) {
    final today = _utcDay(now ?? DateTime.now());
    final diff = today.difference(_utcDay(lmp)).inDays;
    return diff >= 0 && diff <= maxPlausibleDays;
  }

  /// Date prévue d'accouchement (DPA). À corriger par échographie précoce si le soignant le demande.
  DateTime dueDate(DateTime lmp) =>
      DateTime(lmp.year, lmp.month, lmp.day + pregnancyDays);

  /// Âge gestationnel à une date donnée (par défaut : aujourd'hui).
  GestationalAge ageAt(DateTime lmp, {DateTime? on}) {
    final days = _utcDay(on ?? DateTime.now()).difference(_utcDay(lmp)).inDays;
    final safe = days < 0 ? 0 : days;
    return GestationalAge(safe ~/ 7, safe % 7);
  }

  /// Trimestre (convention de l'application) : 1 = SA 1–13, 2 = SA 14–27, 3 = SA 28+.
  int trimesterOf(int completedWeeks) {
    if (completedWeeks <= 13) return 1;
    if (completedWeeks <= 27) return 2;
    return 3;
  }

  bool isTerm(int completedWeeks) => completedWeeks >= termWeek;
  bool isPostTerm(int completedWeeks) => completedWeeks >= postTermWeek;

  /// Jours restants avant la DPA (négatif si dépassée).
  int daysUntilDue(DateTime lmp, {DateTime? now}) =>
      _utcDay(dueDate(lmp)).difference(_utcDay(now ?? DateTime.now())).inDays;

  /// Progression 0.0 – 1.0 vers 40 SA (pour une barre de progression).
  double progress(DateTime lmp, {DateTime? now}) {
    final d = ageAt(lmp, on: now).totalDays;
    return (d / pregnancyDays).clamp(0.0, 1.0).toDouble();
  }

  static const Map<int, List<String>> _pointsByWeek = {
    12: [
      'Antécédents et examen',
      'Tension, poids, hémoglobine, urines',
      'Groupe sanguin, VIH, syphilis',
      'Fer + acide folique',
      'Moustiquaire (zone palustre)',
      'Vaccin antitétanique selon statut',
    ],
    20: [
      'Échographie avant 24 SA si disponible',
      'Tension, poids',
      'TPIg-SP si zone palustre',
    ],
    26: [
      'Tension, poids, hémoglobine, urines',
      'Dépistage du diabète gestationnel selon protocole',
    ],
    30: ['Croissance, tension', 'Rappel des signes de danger'],
    34: ['Présentation du bébé', 'Plan d\'accouchement et de transport'],
    36: ['Préparer l\'accouchement', 'Allaitement'],
    38: ['Contrôle habituel'],
    40: ['Contrôle ; retour à 41 SA si pas accouchée'],
  };

  /// Calendrier des CPN selon le pack pays (OMS à 8 contacts par défaut).
  List<AncContact> ancSchedule(DateTime lmp, CountryPack pack) {
    final weeks = pack.ancWeeks;
    final start = DateTime(lmp.year, lmp.month, lmp.day);
    final contacts = <AncContact>[];
    DateTime? lastDose;
    for (var i = 0; i < weeks.length; i++) {
      final w = weeks[i];
      final date = DateTime(start.year, start.month, start.day + w * 7);
      var dose = false;
      if (pack.malariaZone && w >= pack.iptpFromWeek) {
        // Règle OMS : au moins 1 mois entre deux doses ; pas avant 13 SA.
        if (lastDose == null ||
            _utcDay(date).difference(_utcDay(lastDose)).inDays >=
                pack.iptpMinIntervalDays) {
          dose = true;
          lastDose = date;
        }
      }
      contacts.add(
        AncContact(
          number: i + 1,
          week: w,
          date: date,
          label: i == 0
              ? 'CPN 1 — au plus tard à $w SA'
              : 'CPN ${i + 1} — $w SA',
          keyPoints: _pointsByWeek[w] ?? const [],
          iptpDose: dose,
        ),
      );
    }
    return contacts;
  }

  /// Prochain contact à venir (ou null si tous passés).
  AncContact? nextContact(DateTime lmp, CountryPack pack, {DateTime? now}) {
    final today = _utcDay(now ?? DateTime.now());
    for (final c in ancSchedule(lmp, pack)) {
      if (!_utcDay(c.date).isBefore(today)) return c;
    }
    return null;
  }
}

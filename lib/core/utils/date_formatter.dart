import '../../features/pregnancy_tracker/domain/services/pregnancy_calculation_service.dart';

/// Utilitaires de dates pour SaveBabe.
///
/// Toute la logique obstétrique est centralisée dans
/// [PregnancyCalculationService] afin d'éviter des calculs divergents entre
/// l'accueil, le suivi et les métriques.
class DateFormatter {
  const DateFormatter._();

  static const PregnancyCalculationService _pregnancy =
      PregnancyCalculationService();

  static DateTime? parseLmp(String lmp) {
    if (lmp.trim().isEmpty) return null;
    try {
      return DateTime.parse(lmp);
    } catch (_) {
      return null;
    }
  }

  /// Nombre de semaines d'aménorrhée complètes depuis la DDR.
  /// Retourne 0 si la DDR est vide ou invalide.
  static int weeksOf(String lmp, {DateTime? now}) {
    final date = parseLmp(lmp);
    if (date == null) return 0;
    return _pregnancy.ageAt(date, on: now).weeks.clamp(0, 44).toInt();
  }

  /// Âge gestationnel précis, ex. « 24 SA + 3 j ».
  static GestationalAge? gestationalAge(String lmp, {DateTime? now}) {
    final date = parseLmp(lmp);
    if (date == null) return null;
    return _pregnancy.ageAt(date, on: now);
  }

  /// DPA = DDR + 280 jours (convention 40 SA).
  static String dueDate(String lmp) {
    final date = parseLmp(lmp);
    if (date == null) return '';
    return formatFR(_pregnancy.dueDate(date));
  }

  static DateTime? dueDateValue(String lmp) {
    final date = parseLmp(lmp);
    if (date == null) return null;
    return _pregnancy.dueDate(date);
  }

  static bool isValidLmp(String lmp, {DateTime? now}) {
    final date = parseLmp(lmp);
    if (date == null) return false;
    return _pregnancy.isValidLmp(date, now: now);
  }

  static String formatFR(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  /// Parse le format français dd/MM/yyyy utilisé par les mesures existantes.
  static DateTime? parseFR(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  static String monthShort(DateTime date) {
    const months = [
      'jan.',
      'fév.',
      'mar.',
      'avr.',
      'mai',
      'juin',
      'juil.',
      'août',
      'sep.',
      'oct.',
      'nov.',
      'déc.',
    ];
    return months[date.month - 1];
  }

  /// Trimestre : T1 = 1–13 SA, T2 = 14–27 SA, T3 = 28 SA et plus.
  static int trimester(int week) {
    if (week <= 13) return 1;
    if (week <= 27) return 2;
    return 3;
  }
}

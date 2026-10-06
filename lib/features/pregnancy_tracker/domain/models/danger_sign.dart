/// Signe d'alerte et conduite à tenir (référentiel SaveBabe, chapitres 6, 10.3 et 11.4).
enum DangerPhase { pregnancy, postpartum, newborn }

enum DangerUrgency { consultSoon, sameDay, immediate }

class DangerSign {
  final String id;
  final DangerPhase phase;
  final String title;
  final String why;
  final String action;
  final DangerUrgency urgency;

  const DangerSign({
    required this.id,
    required this.phase,
    required this.title,
    required this.why,
    required this.action,
    required this.urgency,
  });
}

/// Fiche d'une semaine de grossesse (référentiel SaveBabe, chapitre 7).
/// Les tailles/poids sont des moyennes approximatives (niveau [B]).
class PregnancyWeekInfo {
  final int week;
  final String babySize;
  final String development;
  final String motherBody;
  final String tip;

  const PregnancyWeekInfo({
    required this.week,
    required this.babySize,
    required this.development,
    required this.motherBody,
    required this.tip,
  });
}

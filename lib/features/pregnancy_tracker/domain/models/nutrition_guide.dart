/// Modèles du guide nutritionnel (référentiel SaveBabe, chapitre 4).
/// `evidence` : 'A' = source officielle consultée, 'B' = à valider par un professionnel, 'C' = dépend du pays.
class NutritionItem {
  final String need; // ex. « Fer »
  final List<String> foods; // aliments du terroir
  final String advice;
  final String evidence;

  const NutritionItem({
    required this.need,
    required this.foods,
    required this.advice,
    required this.evidence,
  });
}

class AvoidItem {
  final String item;
  final String reason;
  final String evidence;

  const AvoidItem({
    required this.item,
    required this.reason,
    required this.evidence,
  });
}

class TrimesterTips {
  final int trimester;
  final List<String> tips;
  const TrimesterTips(this.trimester, this.tips);
}

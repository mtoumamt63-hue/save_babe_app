class PregnancyTip {
  final int weekMin;
  final int weekMax;
  final String tip;

  const PregnancyTip({
    required this.weekMin,
    required this.weekMax,
    required this.tip,
  });
}

const List<PregnancyTip> kPregnancyTips = [
  // ==========================================
  // TRIMESTRE 1 : Semaines 1 à 12
  // ==========================================
  PregnancyTip(
    weekMin: 1,
    weekMax: 3,
    tip: 'Félicitations ! Pensez à prendre votre acide folique tous les matins pour aider le bébé à bien grandir.',
  ),
  PregnancyTip(
    weekMin: 4,
    weekMax: 5,
    tip: 'Évitez l’alcool, la cigarette et les médicaments non prescrits pour protéger votre bébé dès le début.',
  ),
  PregnancyTip(
    weekMin: 6,
    weekMax: 7,
    tip: 'Si vous avez des nausées, mangez de petits repas légers et souvent, sans attendre d’avoir faim.',
  ),
  PregnancyTip(
    weekMin: 8,
    weekMax: 9,
    tip: 'Buvez beaucoup d’eau propre et purifiée chaque jour pour rester en forme et bien hydratée.',
  ),
  PregnancyTip(
    weekMin: 10,
    weekMax: 12,
    tip: 'Prenez rendez-vous avec votre sage-femme pour votre première consultation et votre première échographie.',
  ),
  PregnancyTip(
    weekMin: 10,
    weekMax: 12,
    tip: 'Dormez toujours sous une moustiquaire chaque nuit pour vous protéger du paludisme.',
  ),

  // ==========================================
  // TRIMESTRE 2 : Semaines 13 à 27
  // ==========================================
  PregnancyTip(
    weekMin: 13,
    weekMax: 15,
    tip: 'Mangez des aliments riches en fer (comme les épinards, les foies et le niébé) pour éviter la fatigue et l’anémie.',
  ),
  PregnancyTip(
    weekMin: 16,
    weekMax: 18,
    tip: 'Prenez vos repas de fer avec un fruit riche en vitamine C (comme une orange) pour qu’il soit mieux absorbé.',
  ),
  PregnancyTip(
    weekMin: 19,
    weekMax: 21,
    tip: 'Le bébé commence à entendre vos mots ! Parlez-lui doucement et chantez-lui des chansons qu’il aime déjà.',
  ),
  PregnancyTip(
    weekMin: 22,
    weekMax: 24,
    tip: 'Pour mieux respirer et aider le bébé, essayez de dormir de préférence sur votre côté gauche.',
  ),
  PregnancyTip(
    weekMin: 25,
    weekMax: 27,
    tip: 'Soyez attentive aux mouvements de votre bébé tous les jours. S’il bouge moins que d’habitude, consultez vite.',
  ),
  PregnancyTip(
    weekMin: 25,
    weekMax: 27,
    tip: 'Faites le petit test de sucre demandé par votre médecin pour vérifier que tout va bien pour votre santé.',
  ),

  // ==========================================
  // TRIMESTRE 3 : Semaines 28 à 40
  // ==========================================
  PregnancyTip(
    weekMin: 28,
    weekMax: 31,
    tip: 'Pour soulager vos jambes lourdes et vos pieds gonflés, posez vos jambes sur un coussin le soir en vous reposant.',
  ),
  PregnancyTip(
    weekMin: 32,
    weekMax: 34,
    tip: 'Préparez tranquillement votre sac pour la maternité avec les vêtements propres de bébé et vos carnets médicaux.',
  ),
  PregnancyTip(
    weekMin: 35,
    weekMax: 37,
    tip: 'Repérez à l’avance l’hôpital ou le centre de santé le plus proche et prévoyez comment vous y rendre le moment venu.',
  ),
  PregnancyTip(
    weekMin: 38,
    weekMax: 40,
    tip: 'Apprenez à repérer les vrais signes de l’accouchement : des ventres durs qui font mal régulièrement ou la perte des eaux.',
  ),
  PregnancyTip(
    weekMin: 38,
    weekMax: 40,
    tip: 'Attention aux dangers : si vous saignez, si vous avez très mal à la tête ou de la fièvre, allez tout de suite à l’hôpital.',
  ),

  // ==========================================
  // POST-PARTUM : Semaines 41 à 43
  // ==========================================
  PregnancyTip(
    weekMin: 41,
    weekMax: 43,
    tip: 'Allaitez votre bébé au sein dès qu’il le demande : c’est le meilleur aliment pour le rendre fort et en bonne santé.',
  ),
  PregnancyTip(
    weekMin: 41,
    weekMax: 43,
    tip: 'Reposez-vous au maximum pendant que bébé dort pour aider votre corps à bien récupérer après l’accouchement.',
  ),
  PregnancyTip(
    weekMin: 41,
    weekMax: 43,
    tip: 'N’oubliez pas d’aller à votre visite médicale après l’accouchement pour faire le point avec votre sage-femme.',
  ),
];

/// Retourne le conseil médical adapté à la semaine de grossesse actuelle
PregnancyTip? getTipForWeek(int currentWeek) {
  try {
    return kPregnancyTips.firstWhere(
      (tip) => currentWeek >= tip.weekMin && currentWeek <= tip.weekMax,
    );
  } catch (_) {
    return null;
  }
}

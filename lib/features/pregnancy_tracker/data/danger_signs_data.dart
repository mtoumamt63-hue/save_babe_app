// Signes de danger (référentiel SaveBabe, chapitres 6, 10.3 et 11.4).
import '../domain/models/danger_sign.dart';

const List<DangerSign> dangerSigns = [
  DangerSign(
    id: "preg_bleeding",
    phase: DangerPhase.pregnancy,
    title: "Saignement par le vagin",
    why: "Fausse couche, décollement du placenta, placenta bas inséré.",
    action: "Urgence : allez immédiatement en structure de santé, quel que soit le terme.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "preg_preeclampsia",
    phase: DangerPhase.pregnancy,
    title: "Maux de tête intenses, vue floue ou éclairs, douleur sous les côtes à droite, gonflement brutal du visage et des mains",
    why: "Pré-éclampsie possible (surtout après 20 SA).",
    action: "Urgence : allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "preg_seizure",
    phase: DangerPhase.pregnancy,
    title: "Convulsions ou perte de connaissance",
    why: "Éclampsie : danger vital.",
    action: "Urgence vitale : appelez de l'aide et allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "preg_fever",
    phase: DangerPhase.pregnancy,
    title: "Fièvre ou frissons",
    why: "Paludisme, infection urinaire grave ou autre infection.",
    action: "Test et traitement rapides en centre de santé le jour même.",
    urgency: DangerUrgency.sameDay,
  ),
  DangerSign(
    id: "preg_movements",
    phase: DangerPhase.pregnancy,
    title: "Le bébé bouge moins ou plus du tout",
    why: "Le bébé peut être en difficulté.",
    action: "Consultez le jour même, sans attendre le lendemain.",
    urgency: DangerUrgency.sameDay,
  ),
  DangerSign(
    id: "preg_waters",
    phase: DangerPhase.pregnancy,
    title: "Perte de liquide (perte des eaux) avant le travail",
    why: "Rupture des membranes : risque d'infection et d'accouchement prématuré.",
    action: "Allez à la maternité sans attendre.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "preg_preterm",
    phase: DangerPhase.pregnancy,
    title: "Contractions régulières avant 37 SA, douleur forte et continue du ventre, ventre dur",
    why: "Menace d'accouchement prématuré ou décollement du placenta.",
    action: "Urgence : allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "preg_urine",
    phase: DangerPhase.pregnancy,
    title: "Brûlures en urinant, douleur dans le bas du dos avec fièvre",
    why: "Infection urinaire pouvant monter aux reins.",
    action: "Consultez rapidement.",
    urgency: DangerUrgency.consultSoon,
  ),
  DangerSign(
    id: "preg_vomiting",
    phase: DangerPhase.pregnancy,
    title: "Vomissements incessants, impossibilité de boire",
    why: "Risque de déshydratation.",
    action: "Consultez rapidement.",
    urgency: DangerUrgency.consultSoon,
  ),
  DangerSign(
    id: "preg_clot",
    phase: DangerPhase.pregnancy,
    title: "Jambe gonflée, rouge et douloureuse d'un côté ; douleur thoracique ou essoufflement brutal",
    why: "Caillot de sang possible.",
    action: "Urgence : allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "preg_anemia",
    phase: DangerPhase.pregnancy,
    title: "Pâleur extrême, essoufflement au moindre effort, palpitations",
    why: "Anémie sévère possible.",
    action: "Consultez rapidement.",
    urgency: DangerUrgency.consultSoon,
  ),
  DangerSign(
    id: "preg_mood",
    phase: DangerPhase.pregnancy,
    title: "Tristesse profonde, idées noires, envie de se faire du mal",
    why: "Détresse émotionnelle.",
    action:
        "Parlez à un soignant ou à une personne de confiance sans attendre.",
    urgency: DangerUrgency.sameDay,
  ),
  DangerSign(
    id: "pp_bleeding",
    phase: DangerPhase.postpartum,
    title: "Saignement très abondant (une serviette trempée en moins d'une heure) ou gros caillots",
    why: "Hémorragie du post-partum.",
    action: "Urgence : allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "pp_fever",
    phase: DangerPhase.postpartum,
    title:
        "Fièvre, frissons, pertes malodorantes, douleur du ventre qui augmente",
    why: "Infection après l'accouchement.",
    action: "Allez en structure de santé le jour même.",
    urgency: DangerUrgency.sameDay,
  ),
  DangerSign(
    id: "pp_preeclampsia",
    phase: DangerPhase.postpartum,
    title: "Maux de tête intenses, troubles de la vue, convulsions",
    why: "La pré-éclampsie peut persister ou apparaître après l'accouchement.",
    action: "Urgence : allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "pp_breath",
    phase: DangerPhase.postpartum,
    title: "Difficulté à respirer, douleur thoracique, jambe gonflée et douloureuse",
    why: "Caillot de sang possible.",
    action: "Urgence : allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "pp_wound",
    phase: DangerPhase.postpartum,
    title: "Cicatrice (césarienne ou périnée) rouge, qui coule ou s'ouvre",
    why: "Infection ou lâchage de la cicatrice.",
    action: "Consultez rapidement.",
    urgency: DangerUrgency.sameDay,
  ),
  DangerSign(
    id: "pp_mood",
    phase: DangerPhase.postpartum,
    title: "Tristesse qui dure, perte d'intérêt, idées noires, impossibilité de s'occuper du bébé",
    why: "Dépression du post-partum possible.",
    action:
        "Parlez-en à un soignant ou à une personne de confiance sans attendre.",
    urgency: DangerUrgency.sameDay,
  ),
  DangerSign(
    id: "nb_feeding",
    phase: DangerPhase.newborn,
    title: "Le bébé refuse de téter ou tète mal, est très endormi ou mou",
    why: "Signe d'infection ou de maladie.",
    action: "Allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "nb_seizure",
    phase: DangerPhase.newborn,
    title: "Le bébé a des convulsions",
    why: "Maladie grave.",
    action: "Urgence : allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "nb_breathing",
    phase: DangerPhase.newborn,
    title: "Respiration rapide (60 par minute ou plus), creux entre les côtes, bruits en respirant",
    why: "Problème respiratoire ou infection.",
    action: "Urgence : allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "nb_temp",
    phase: DangerPhase.newborn,
    title: "Fièvre (37,5 °C ou plus) ou corps froid (moins de 35,5 °C)",
    why: "Infection ou perte de chaleur.",
    action: "Allez immédiatement en structure de santé.",
    urgency: DangerUrgency.immediate,
  ),
  DangerSign(
    id: "nb_jaundice",
    phase: DangerPhase.newborn,
    title: "Jaune dans les 24 premières heures de vie, ou paumes et plantes des pieds jaunes à tout âge",
    why: "Jaunisse à surveiller.",
    action: "Allez en structure de santé le jour même.",
    urgency: DangerUrgency.sameDay,
  ),
  DangerSign(
    id: "nb_cord",
    phase: DangerPhase.newborn,
    title: "Cordon rouge, gonflé ou qui coule ; pus dans les yeux ; pustules sur la peau",
    why: "Infection.",
    action: "Consultez le jour même.",
    urgency: DangerUrgency.sameDay,
  ),
  DangerSign(
    id: "nb_other",
    phase: DangerPhase.newborn,
    title: "Le bébé ne bouge pas spontanément, vomit tout, a une diarrhée importante, ne fait ni selles ni urines",
    why: "Maladie possible.",
    action: "Allez en structure de santé le jour même.",
    urgency: DangerUrgency.sameDay,
  ),
];

List<DangerSign> dangerSignsFor(DangerPhase phase) =>
    dangerSigns.where((s) => s.phase == phase).toList();

/// Niveau d'urgence le plus élevé parmi les signes cochés (null si aucun).
DangerUrgency? highestUrgency(Iterable<DangerSign> selected) {
  DangerUrgency? best;
  for (final s in selected) {
    if (best == null || s.urgency.index > best.index) best = s.urgency;
  }
  return best;
}

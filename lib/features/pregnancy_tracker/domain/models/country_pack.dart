/// Paramètres qui changent d'un pays à l'autre (pack pays).
/// Niveau de preuve : voir SaveBabe_Pack_RDC.pdf. Tout ce qui est `validatedByMinistry == false`
/// doit être confirmé auprès des programmes nationaux avant publication.
enum AncModel { who8, focused4 }

class CountryPack {
  final String code;
  final String name;
  final AncModel defaultAncModel;
  final List<int> ancWeeksWho8;      // OMS 2016 : 12, 20, 26, 30, 34, 36, 38, 40
  final List<int> ancWeeksFocused4;  // repli : 4 consultations
  final bool malariaZone;
  final int iptpFromWeek;            // OMS : pas avant 13 SA
  final int iptpMinIntervalDays;     // OMS : au moins 1 mois entre deux doses
  final List<String> vatSchedule;    // vaccin antitétanique (schéma OMS générique)
  final List<String> newbornBirthVaccines;
  final List<String> careTerms;      // vocabulaire local
  final String? emergencyNumber;     // null tant que non fourni par le ministère
  final bool validatedByMinistry;

  const CountryPack({
    required this.code,
    required this.name,
    required this.defaultAncModel,
    required this.ancWeeksWho8,
    required this.ancWeeksFocused4,
    required this.malariaZone,
    required this.iptpFromWeek,
    required this.iptpMinIntervalDays,
    required this.vatSchedule,
    required this.newbornBirthVaccines,
    required this.careTerms,
    this.emergencyNumber,
    this.validatedByMinistry = false,
  });

  List<int> get ancWeeks =>
      defaultAncModel == AncModel.who8 ? ancWeeksWho8 : ancWeeksFocused4;
}

/// Pack RDC — à valider (PNSR, PNLP, PEV, PNLS).
const CountryPack rdcPack = CountryPack(
  code: 'CD',
  name: 'RDC',
  defaultAncModel: AncModel.who8,
  ancWeeksWho8: [12, 20, 26, 30, 34, 36, 38, 40],
  ancWeeksFocused4: [16, 26, 31, 37],
  malariaZone: true,
  iptpFromWeek: 13,
  iptpMinIntervalDays: 30,
  vatSchedule: [
    'VAT1 : au 1er contact',
    'VAT2 : au moins 4 semaines après VAT1',
    'VAT3 : 6 mois après VAT2',
    'VAT4 : 1 an après VAT3',
    'VAT5 : 1 an après VAT4',
  ],
  newbornBirthVaccines: ['BCG', 'Polio orale 0'],
  careTerms: ['aire de santé', 'zone de santé', 'centre de santé', 'hôpital général de référence'],
  emergencyNumber: null,
  validatedByMinistry: false,
);

/// Pack générique OMS utilisé tant qu'aucun pack national validé n'est chargé.
/// Les éléments dépendant du pays (numéro d'urgence, calendrier vaccinal détaillé,
/// protocole antipaludique local) doivent être validés avant publication.
const CountryPack whoGenericPack = CountryPack(
  code: 'WHO',
  name: 'Référentiel OMS',
  defaultAncModel: AncModel.who8,
  ancWeeksWho8: [12, 20, 26, 30, 34, 36, 38, 40],
  ancWeeksFocused4: [16, 26, 31, 37],
  malariaZone: false,
  iptpFromWeek: 13,
  iptpMinIntervalDays: 30,
  vatSchedule: [
    'Vérifier le statut vaccinal au premier contact',
    'Compléter selon le programme national',
  ],
  newbornBirthVaccines: [],
  careTerms: ['centre de santé', 'maternité', 'hôpital'],
  emergencyNumber: null,
  validatedByMinistry: false,
);

/// Pack générique pour les pays/territoires d'Afrique subsaharienne où le
/// module paludisme doit être activé, en attente d'un pack national validé.
/// Il ne remplace pas le protocole du programme national de lutte contre le paludisme.
const CountryPack subSaharanMalariaGenericPack = CountryPack(
  code: 'SSA-MALARIA',
  name: 'Afrique subsaharienne — à valider',
  defaultAncModel: AncModel.who8,
  ancWeeksWho8: [12, 20, 26, 30, 34, 36, 38, 40],
  ancWeeksFocused4: [16, 26, 31, 37],
  malariaZone: true,
  iptpFromWeek: 13,
  iptpMinIntervalDays: 30,
  vatSchedule: [
    'Vérifier le statut vaccinal au premier contact',
    'Compléter selon le programme national',
  ],
  newbornBirthVaccines: [],
  careTerms: ['centre de santé', 'maternité', 'hôpital'],
  emergencyNumber: null,
  validatedByMinistry: false,
);

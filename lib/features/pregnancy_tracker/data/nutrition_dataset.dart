// Guide nutritionnel — noyau commun + repères RDC (à valider avec une nutritionniste locale).
import '../domain/models/nutrition_guide.dart';

const List<NutritionItem> nutritionItems = [
  NutritionItem(
    need: 'Fer',
    foods: ['Feuilles vertes cuites (pondu, matembele, amarante)', 'Niébé / haricots / lentilles', 'Sésame, arachide', 'Poisson, viande et abats bien cuits', 'Feuilles de moringa'],
    advice: 'Manger avec une source de vitamine C. Éviter le thé et le café pendant les repas. Les comprimés de fer + acide folique restent nécessaires (30 à 60 mg de fer + 400 µg d\'acide folique par jour, OMS). Moringa : feuilles uniquement, jamais la racine, l\'écorce ni les fleurs.',
    evidence: 'A',
  ),
  NutritionItem(
    need: 'Folates',
    foods: ['Feuilles vertes', 'Gombo', 'Niébé, haricots', 'Agrumes, avocat'],
    advice: 'L\'acide folique en comprimé reste indispensable (400 µg par jour).',
    evidence: 'A',
  ),
  NutritionItem(
    need: 'Énergie',
    foods: ['Igname', 'Patate douce', 'Manioc bien préparé', 'Banane plantain', 'Maïs, mil, sorgho, fonio, riz'],
    advice: 'Manioc : toujours bien préparé et cuit (le manioc amer mal traité est toxique). Varier les féculents.',
    evidence: 'B',
  ),
  NutritionItem(
    need: 'Protéines',
    foods: ['Poisson', 'Œufs bien cuits', 'Niébé, haricots', 'Arachide', 'Viande bien cuite', 'Lait ou yaourt pasteurisés'],
    advice: 'Cuire à cœur. Limiter le poisson très salé ou fumé en excès.',
    evidence: 'B',
  ),
  NutritionItem(
    need: 'Calcium',
    foods: ['Lait ou yaourt pasteurisés', 'Poissons mangés avec les petites arêtes', 'Feuilles vertes', 'Pulpe de baobab', 'Sésame'],
    advice: 'Si l\'apport en calcium est faible, un supplément peut être prescrit par un soignant.',
    evidence: 'A',
  ),
  NutritionItem(
    need: 'Vitamine A (bêta-carotène)',
    foods: ['Patate douce à chair orange', 'Mangue, papaye', 'Carotte', 'Huile de palme rouge'],
    advice: 'Foie et compléments de vitamine A à forte dose : seulement avec l\'avis d\'un soignant.',
    evidence: 'B',
  ),
  NutritionItem(
    need: 'Hydratation',
    foods: ['Eau potable', 'Eau de coco', 'Jus de fruits frais dilués'],
    advice: 'Environ 8 verres par jour. Si l\'eau n\'est pas sûre, la faire bouillir. Gingembre léger possible contre les nausées ; autres tisanes : avis d\'un soignant.',
    evidence: 'B',
  ),
];

const List<AvoidItem> avoidItems = [
  AvoidItem(item: 'Géophagie (manger de la terre, du kaolin, de l\'argile)', reason: 'Associée à l\'anémie, aux parasites et à l\'exposition aux métaux. Parlez-en au soignant : cela peut signaler un manque de fer.', evidence: 'A'),
  AvoidItem(item: 'Viande, poisson, œufs ou chenilles crus ou mal cuits ; lait non pasteurisé', reason: 'Risque d\'infections graves pour vous et le bébé.', evidence: 'B'),
  AvoidItem(item: 'Alcool (y compris boissons traditionnelles fermentées) et tabac', reason: 'Risques pour le développement du bébé.', evidence: 'B'),
  AvoidItem(item: 'Plantes, décoctions, racines et écorces non prescrites ; automédication', reason: 'Certaines peuvent provoquer des contractions ou être toxiques.', evidence: 'A'),
  AvoidItem(item: 'Arachides, maïs ou céréales moisis', reason: 'Risque d\'aflatoxines : les jeter.', evidence: 'B'),
  AvoidItem(item: 'Fruits et légumes non lavés ; eau non potable', reason: 'Risque d\'infections et de parasites.', evidence: 'B'),
];

const List<TrimesterTips> trimesterTips = [
  TrimesterTips(1, ['Acide folique chaque jour', 'Petits repas fréquents contre les nausées', 'Aucun alcool, aucun tabac', 'Pas de plantes ni de médicaments sans avis']),
  TrimesterTips(2, ['Fer + acide folique chaque jour', 'Aliments riches en fer avec vitamine C', 'Calcium (lait, poisson avec arêtes, feuilles vertes)', 'Prise de poids régulière, sans régime']),
  TrimesterTips(3, ['Petits repas pour les brûlures d\'estomac', 'Boire régulièrement', 'Continuer fer + acide folique', 'Préparer l\'allaitement et le sac de maternité']),
];

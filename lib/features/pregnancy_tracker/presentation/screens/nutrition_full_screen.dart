import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../widgets/pregnancy_page.dart';
import '../widgets/pregnancy_illustration.dart';

class AfricanMeal {
  final String name, region, description, benefit, image;
  const AfricanMeal(
    this.name,
    this.region,
    this.description,
    this.benefit,
    this.image,
  );
}

const africanMeals = <AfricanMeal>[
  AfricanMeal(
    'Fonio + légumes + œuf bien cuit',
    'Afrique de l’Ouest',
    'Fonio accompagné de légumes cuits et d’un œuf bien cuit.',
    'Céréale + protéines + légumes : composition adaptée au principe d’un repas équilibré.',
    '🌾',
  ),
  AfricanMeal(
    'Mafé léger aux légumes',
    'Afrique de l’Ouest',
    'Sauce à base d’arachide avec légumes et une protéine bien cuite, servie avec une portion modérée de céréale.',
    'Apporte protéines et énergie ; limiter l’excès d’huile et de sel.',
    '🥜',
  ),
  AfricanMeal(
    'Riz + sauce gombo + poisson bien cuit',
    'Afrique de l’Ouest / Centre',
    'Riz accompagné de gombo et de poisson bien cuit.',
    'Gombo et légumes pour les folates/fibres ; poisson pour les protéines.',
    '🍚',
  ),
  AfricanMeal(
    'Attiéké + poisson bien cuit + légumes',
    'Côte d’Ivoire',
    'Attiéké accompagné de poisson bien cuit et de crudités soigneusement lavées ou légumes cuits.',
    'Associer féculent, protéine et végétaux ; éviter le poisson cru.',
    '🐟',
  ),
  AfricanMeal(
    'Ndolé revisité',
    'Cameroun',
    'Feuilles bien cuites avec arachide et une protéine bien cuite, avec une portion de féculent.',
    'Feuilles + arachide + protéine ; éviter les préparations trop grasses.',
    '🥬',
  ),
  AfricanMeal(
    'Haricots + plantain + légumes',
    'Afrique centrale et de l’Ouest',
    'Haricots bien cuits, plantain cuit et légumes.',
    'Légumineuses riches en protéines et fer ; associer à une source de vitamine C.',
    '🍌',
  ),
  AfricanMeal(
    'Chikwangue/fufu + poisson + légumes',
    'Afrique centrale',
    'Féculent de manioc correctement préparé, avec poisson bien cuit et légumes.',
    'Le manioc doit être correctement préparé et cuit ; varier les féculents.',
    '🥔',
  ),
  AfricanMeal(
    'Couscous de mil + légumes + lait/yaourt pasteurisé',
    'Sahel / Afrique de l’Ouest',
    'Mil accompagné de légumes et d’un produit laitier pasteurisé.',
    'Céréale + végétaux + calcium.',
    '🥣',
  ),
  AfricanMeal(
    'Patate douce + haricots + avocat',
    'Afrique',
    'Patate douce cuite, haricots bien cuits et avocat.',
    'Énergie, protéines, folates et bonnes graisses alimentaires.',
    '🥑',
  ),
];

const juices = <Map<String, String>>[
  {
    'name': 'Jus de mangue dilué',
    'text':
        'Préparer avec fruit lavé, eau potable et peu ou pas de sucre ajouté.',
  },
  {
    'name': 'Jus de goyave',
    'text': 'Source de vitamine C ; privilégier le fruit frais et une préparation hygiénique.',
  },
  {
    'name': 'Jus de papaye',
    'text': 'Fruit riche en bêta-carotène ; éviter les excès de sucre ajouté.',
  },
  {
    'name': 'Eau de coco',
    'text': 'Peut contribuer à l’hydratation ; l’eau potable reste la boisson de base.',
  },
  {
    'name': 'Jus de baobab dilué',
    'text': 'Boisson à base de pulpe ; utiliser une préparation sûre et limiter le sucre ajouté.',
  },
  {
    'name': 'Gingembre léger',
    'text': 'Une petite quantité de gingembre peut parfois aider contre les nausées ; éviter les décoctions concentrées et demander conseil pour les plantes.',
  },
];

class NutritionFullScreen extends StatelessWidget {
  const NutritionFullScreen({super.key, this.trimester});

  final int? trimester;

  static const mealKeys = [
    'fonio',
    'mafe',
    'riz_gombo_poisson',
    'attieke_poisson',
    'ndole',
    'haricots_plantain',
    'fufu_poisson',
    'couscous_mil',
    'patate_haricots_avocat',
  ];
  static const juiceKeys = [
    'mangue',
    'goyave',
    'papaye',
    'coco',
    'baobab',
    'gingembre',
  ];

  List<int> get _visibleMonths {
    if (trimester == 1) return const [1, 2, 3];
    if (trimester == 2) return const [4, 5, 6];
    if (trimester == 3) return const [7, 8, 9];
    return const [1, 2, 3, 4, 5, 6, 7, 8, 9];
  }

  List<int> _mealIndexesForMonth(int month) {
    final start = ((month - 1) * 2) % africanMeals.length;
    return List.generate(3, (offset) => (start + offset) % africanMeals.length);
  }

  String _period(int month) =>
      'Mois $month · ${month == 1
          ? 'début de grossesse'
          : month <= 3
          ? '1er trimestre'
          : month <= 6
          ? '2e trimestre'
          : '3e trimestre'}';

  @override
  Widget build(BuildContext context) {
    return PregnancyPage(
      title: trimester == null
          ? 'Nutrition pendant toute la grossesse'
          : 'Nutrition · ${trimester}e trimestre',
      subtitle: trimester == null
          ? 'Du 1er au 9e mois · repères alimentaires africains'
          : 'Conseils et exemples pour cette période',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SbCard(
              child: Text(
                'Pendant la grossesse, privilégiez la variété : céréale ou tubercule + protéine + légumes/feuilles + fruit. Il ne s’agit pas de “manger pour deux”.',
                style: AppTypography.bodyM.copyWith(height: 1.4),
              ),
            ),
            const SizedBox(height: 16),
            ..._visibleMonths.map((month) {
              final i = month - 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  title: Text(_period(i + 1), style: AppTypography.labelM),
                  subtitle: Text(
                    i < 3
                        ? 'Fer + folates · nausées · hydratation'
                        : i < 6
                        ? 'Fer · calcium · fibres · variété'
                        : 'Hydratation · reflux · préparation de l’allaitement',
                  ),
                  children: [
                    Text(
                      i < 3
                          ? 'Priorités : petits repas fréquents si nausées, acide folique selon prescription, aliments riches en fer associés à vitamine C, eau potable.'
                          : i < 6
                          ? 'Priorités : continuer fer + acide folique, varier légumineuses, feuilles vertes, poissons et céréales/tubercules, surveiller la prise de poids.'
                          : 'Priorités : petits repas si brûlures, fibres et eau contre la constipation, continuer les compléments prescrits, préparer l’allaitement et le sac de maternité.',
                      style: AppTypography.bodyM.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Text('Exemples de plats', style: AppTypography.labelM),
                    const SizedBox(height: 6),
                    ..._mealIndexesForMonth(i + 1).map((mealIndex) {
                      final meal = africanMeals[mealIndex];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(
                          width: 72,
                          height: 58,
                          child: PregnancyIllustration.topic(
                            name: 'meal_${mealKeys[mealIndex]}',
                          ),
                        ),
                        title: Text(meal.name),
                        subtitle: Text(
                          '${meal.region}\n${meal.description}\n${meal.benefit}',
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Text('Boissons et jus', style: AppTypography.displayM),
            const SizedBox(height: 8),
            SbCard(
              child: Column(
                children: juices.asMap().entries.map((entry) {
                  final j = entry.value;
                  final key = juiceKeys[entry.key];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SizedBox(
                      width: 72,
                      height: 52,
                      child: PregnancyIllustration.topic(name: 'juice_$key'),
                    ),
                    title: Text(j['name']!),
                    subtitle: Text(j['text']!),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Text('À éviter ou limiter', style: AppTypography.displayM),
            const SizedBox(height: 8),
            const SbCard(
              child: Text(
                'Alcool et tabac ; viande/poisson/œufs crus ou mal cuits ; lait non pasteurisé ; fruits et légumes non lavés ; eau non potable ; géophagie ; plantes médicinales et décoctions non prescrites ; aliments moisis ; excès de sucre, sodas, sel et gras. Le foie et les compléments de vitamine A à forte dose nécessitent l’avis d’un soignant.',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Important : les plats ci-dessus sont des exemples culinaires africains. Ils ne remplacent pas un plan nutritionnel personnalisé et doivent être adaptés au pays, aux habitudes de la famille et aux conseils de votre soignant.',
              style: AppTypography.bodyS,
            ),
          ],
        ),
      ),
    );
  }
}

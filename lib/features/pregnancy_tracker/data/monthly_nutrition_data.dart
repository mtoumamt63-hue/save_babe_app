import 'package:flutter/foundation.dart';

@immutable
class MonthlyDish {
  final String id;
  final String name;
  final String region;
  final String image;
  final List<String> nutrients;
  final String shortDescription;
  final String whyThisMonth;
  final List<String> ingredients;
  final String safetyTips;
  final String proTip;

  const MonthlyDish({
    required this.id,
    required this.name,
    required this.region,
    required this.image,
    required this.nutrients,
    required this.shortDescription,
    required this.whyThisMonth,
    required this.ingredients,
    required this.safetyTips,
    required this.proTip,
  });
}

@immutable
class MonthlyDrink {
  final String name;
  final String image;
  final String benefit;
  final String howToPrepare;

  const MonthlyDrink({
    required this.name,
    required this.image,
    required this.benefit,
    required this.howToPrepare,
  });
}

@immutable
class MonthNutritionPlan {
  final int month;
  final int trimester;
  final String weeksRange;
  final String title;
  final String priority;
  final List<String> keyAdvice;
  final List<MonthlyDish> dishes;
  final MonthlyDrink drink;

  const MonthNutritionPlan({
    required this.month,
    required this.trimester,
    required this.weeksRange,
    required this.title,
    required this.priority,
    required this.keyAdvice,
    required this.dishes,
    required this.drink,
  });
}

const List<MonthNutritionPlan> monthlyNutritionPlans = [
  // ── MOIS 1 ──
  MonthNutritionPlan(
    month: 1,
    trimester: 1,
    weeksRange: '1 - 4 SA',
    title: 'Implantation & réserve d’acide folique',
    priority: 'Favoriser la fermeture du tube neural et poser les bases de la vitalité.',
    keyAdvice: [
      'Prendre quotidiennement le comprimé de fer + acide folique prescrit par le soignant.',
      'Miser sur les folates naturels : gombo, feuilles vertes bien cuites, niébé et agrumes.',
      'Boire au moins 2 litres d’eau potable par jour par petites gorgées régulières.',
    ],
    dishes: [
      MonthlyDish(
        id: 'm1_rice_gombo',
        name: 'Riz complet, sauce gombo & poisson bien cuit',
        region: 'Afrique de l’Ouest & Centrale',
        image: 'assets/pregnancy/photos/ng.jpg',
        nutrients: ['Folates naturels', 'Protéines', 'Fibres solubles'],
        shortDescription: 'Un plat doux et très digeste, idéal pour préserver l’estomac des premières nausées.',
        whyThisMonth: 'Le gombo est l’un des légumes les plus riches en acide folique (vitamine B9), indispensable pendant les 4 premières semaines pour la formation du tube neural du fœtus.',
        ingredients: [
          'Gombo frais soigneusement lavé et émincé',
          'Poisson frais d’eau douce ou de mer cuit à cœur',
          'Riz bien cuit',
          'Huile de cuisson en quantité modérée, oignons et tomates',
        ],
        safetyTips: 'Cuire le poisson à cœur (chair blanche opaque se détachant facilement). Éviter le piment excessif qui favorise les brûlures digestives.',
        proTip: 'Presser un filet de citron frais sur le poisson : la vitamine C augmente grandement l’assimilation du fer contenu dans le plat.',
      ),
      MonthlyDish(
        id: 'm1_fonio_legumes',
        name: 'Fonio fondant, légumes mijotés & œuf cuit',
        region: 'Sahel & Afrique de l’Ouest',
        image: 'assets/pregnancy/photos/fonio.jpg',
        nutrients: ['Zinc & Fer', 'Glucides complexes', 'Acides aminés'],
        shortDescription: 'Céréale ancestrale sans gluten, légère, hautement énergétique et très bien tolérée.',
        whyThisMonth: 'Le fonio apporte du zinc et des glucides lents qui maintiennent un taux de glycémie stable et limitent la fatigue matinale typique du premier mois.',
        ingredients: [
          'Fonio précuit à la vapeur',
          'Carottes, courgettes ou légumes locaux émincés',
          'Œuf de poule cuit dur (jaune et blanc fermes)',
          'Filet d’huile végétale de première pression',
        ],
        safetyTips: 'L’œuf doit être impérativement cuit dur (pas d’œuf à la coque ou coulant) pour écarter tout risque de salmonellose.',
        proTip: 'Associer ce repas à un verre d’eau fraîche pour une digestion légère sans sensation de lourdeur abdominale.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Infusion légère de gingembre frais',
      image: 'assets/pregnancy/photos/gim.jpg',
      benefit: 'Aide naturelle reconnue pour soulager les nausées matinales du début de grossesse.',
      howToPrepare: 'Faire infuser 2 fines lamelles de gingembre frais dans de l’eau bouillante pendant 5 minutes, filtrer et tiédir. Consommer avec modération sans sucre.',
    ),
  ),

  // ── MOIS 2 ──
  MonthNutritionPlan(
    month: 2,
    trimester: 1,
    weeksRange: '5 - 8 SA',
    title: 'Organogenèse & soulagement des nausées',
    priority: 'Fractionner les repas pour calmer l’écœurement tout en nourrissant les organes embryonnaires.',
    keyAdvice: [
      'Manger de petites quantités réparties en 5 à 6 prises légères au cours de la journée.',
      'Privilégier les aliments simples, non gras et peu odorants au réveil.',
      'Ne pas rester le ventre vide : garder un petit encas sec (morceau de pain ou manioc doux) au chevet.',
    ],
    dishes: [
      MonthlyDish(
        id: 'm2_patate_haricots',
        name: 'Patate douce vapeur, haricots rouges & avocat',
        region: 'Afrique Centrale & de l’Est',
        image: 'assets/pregnancy/photos/patates.jpg',
        nutrients: ['Bêta-carotène', 'Fibres douces', 'Bonnes graisses'],
        shortDescription: 'Une assiette réconfortante, naturellement sucrée et sans odeurs agressives.',
        whyThisMonth: 'La patate douce orange est une excellente source de provitamine A sûre pour le bébé. L’avocat fournit des acides gras essentiels et du potassium pour stabiliser la pression.',
        ingredients: [
          'Patate douce à chair orangée cuite à la vapeur ou à l’eau',
          'Haricots rouges bien trempés et cuits très tendres',
          'Quelques tranches d’avocat frais mûr à point',
          'Une pincée de sel modérée',
        ],
        safetyTips: 'Bien cuire les légumineuses après trempage préalable pour éliminer les facteurs indigestes et éviter les ballonnements douloureux.',
        proTip: 'Manger tiède plutôt que brûlant : les aliments tièdes dégagent moins d’arômes forts susceptibles de déclencher des nausées.',
      ),
      MonthlyDish(
        id: 'm2_fonio_vapeur',
        name: 'Fonio doux aux petits légumes vapeur',
        region: 'Afrique de l’Ouest',
        image: 'assets/pregnancy/photos/dish_fonio_vapeur.jpg',
        nutrients: ['Digestibilité maximale', 'Minéraux', 'Énergie douce'],
        shortDescription:
            'Un repas tout en douceur pour les journées d’appétit capricieux.',
        whyThisMonth: 'Au 2e mois, les variations hormonales ralentissent la motilité de l’estomac. Le fonio passe très facilement et évite les reflux acides.',
        ingredients: [
          'Fonio cuit à la vapeur',
          'Petits dés de carottes et courges locales fondantes',
          'Bouillon de volaille maison dégraissé',
        ],
        safetyTips: 'Éviter les cubes de bouillon industriels trop salés et riches en exhausteurs. Préférer les herbes aromatiques fraîches bien lavées.',
        proTip: 'Prendre de petites bouchées et bien mastiquer avant d’avaler pour faciliter le travail gastrique.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Eau de coco fraîche naturelle',
      image: 'assets/pregnancy/photos/juice_coconut.jpg',
      benefit: 'Riche en potassium et électrolytes naturels, parfaite pour réhydrater en cas de vomissements.',
      howToPrepare: 'Boire directement l’eau d’une noix de coco fraîchement ouverte. À consommer fraîche dans la journée.',
    ),
  ),

  // ── MOIS 3 ──
  MonthNutritionPlan(
    month: 3,
    trimester: 1,
    weeksRange: '9 - 12 SA',
    title: 'Fin du 1er trimestre & formation osseuse',
    priority: 'Reconstituer les stocks de fer et soutenir le bourgeonnement osseux du fœtus.',
    keyAdvice: [
      'Associer systématiquement les légumineuses et feuilles vertes à un fruit frais riche en vitamine C.',
      'Éviter thé, café et infusions de plantes non autorisées dans l’heure encadrant les repas.',
      'Commencer à intégrer des sources de calcium adaptées (petits poissons à arêtes ou yaourt pasteurisé).',
    ],
    dishes: [
      MonthlyDish(
        id: 'm3_beans_plantain',
        name: 'Haricots mijotés & banane plantain cuite',
        region: 'Afrique Centrale & de l’Ouest',
        image: 'assets/pregnancy/photos/h.jpg',
        nutrients: ['Fer hématopoïétique', 'Magnésium', 'Potassium'],
        shortDescription: 'Le duo traditionnel parfait entre protéines végétales et glucides complexes.',
        whyThisMonth: 'Le volume sanguin maternel commence son expansion continue. Ce plat apporte un soutien essentiel contre l’anémie précoce.',
        ingredients: [
          'Haricots rouges ou niébé cuits à feu doux',
          'Banane plantain mûre cuite à l’eau ou à la vapeur (non frite)',
          'Tomates fraîches, ail et persil',
          'Huile végétale de qualité en quantité mesurée',
        ],
        safetyTips: 'Privilégier le plantain bouilli ou vapeur plutôt que la friture (alloco) pour limiter les graisses saturées et la digestion lourde.',
        proTip: 'Ajouter une sauce tomate fraîche riche en lycopène pour optimiser l’absorption du fer contenu dans les haricots.',
      ),
      MonthlyDish(
        id: 'm3_attieke_poisson',
        name: 'Attiéké traditionnel & poisson braisé bien cuit',
        region: 'Côte d’Ivoire & Golfe de Guinée',
        image: 'assets/pregnancy/photos/a.jpg',
        nutrients: ['Protéines maigres', 'Oméga-3', 'Énergie digeste'],
        shortDescription: 'Semoule de manioc fermentée légère et poisson savoureux cuit à cœur.',
        whyThisMonth: 'Le poisson apporte des acides gras oméga-3 essentiels pour la rétine et le cerveau du fœtus en pleine structuration.',
        ingredients: [
          'Attiéké frais réchauffé à la vapeur',
          'Dorade, carpe ou capitaine cuit à cœur au four ou braisé',
          'Tomates et concombres soigneusement lavés à l’eau javellisée ou vinaigrée',
          'Jus de citron pressé',
        ],
        safetyTips: 'Les crudités d’accompagnement doivent être rigoureusement lavées avec de l’eau potable désinfectée pour éviter les parasites.',
        proTip: 'Arroser généreusement de citron et déguster avec une portion modérée d’attiéké bien aérée.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Jus de goyave fraîche dilué',
      image: 'assets/pregnancy/photos/go.jpg',
      benefit: 'L’un des fruits les plus riches en vitamine C au monde, décuple l’absorption du fer.',
      howToPrepare: 'Mixer de la goyave fraîche bien lavée avec de l’eau potable bouillie/filtrée. Passer au tamis et servir frais sans sucre.',
    ),
  ),

  // ── MOIS 4 ──
  MonthNutritionPlan(
    month: 4,
    trimester: 2,
    weeksRange: '13 - 16 SA',
    title: 'Début du 2e trimestre & regain d’appétit',
    priority: 'Profiter du retour d’énergie pour structurer une alimentation variée et colorée.',
    keyAdvice: [
      'L’appétit revient : privilégier la qualité nutritionnelle plutôt que la quantité excessive.',
      'Consommer chaque jour une portion de protéines saines (poisson, volaille bien cuite, œufs ou niébé).',
      'Boire régulièrement pour prévenir les infections urinaires fréquentes au 2e trimestre.',
    ],
    dishes: [
      MonthlyDish(
        id: 'm4_mafe_legumes',
        name: 'Mafé léger aux arachides, légumes & volaille',
        region: 'Afrique de l’Ouest',
        image: 'assets/pregnancy/photos/mafe.jpg',
        nutrients: ['Protéines complètes', 'Zinc', 'Vitamines B'],
        shortDescription: 'Sauce onctueuse à base de pâte d’arachide allégée, riche en minéraux.',
        whyThisMonth: 'La croissance du bébé s’accélère (taille multipliée par 3). L’arachide apporte les protéines et la vitamine E nécessaires à la tonicité utérine.',
        ingredients: [
          'Pâte d’arachide pure non sucrée en quantité modérée',
          'Morceaux de poulet cuits à cœur (bouillis puis mijotés)',
          'Carottes, patate douce, chou et gombo',
          'Riz brisé cuit à la vapeur',
        ],
        safetyTips: 'Ne pas faire une sauce trop lourde en huile : diluer la pâte d’arachide avec un bouillon léger et écumer les graisses surnageantes.',
        proTip: 'Les arachides bien conservées (sans moisissure) sont très saines. Ne jamais consommer d’arachides rances ou douteuses.',
      ),
      MonthlyDish(
        id: 'm4_rice_greens',
        name: 'Riz parfumé & sauce gombo aux herbes potagères',
        region: 'Afrique Centrale',
        image: 'assets/pregnancy/photos/dish_rice_greens.jpg',
        nutrients: ['Fibres mucilagineuses', 'Folates', 'Transit régulier'],
        shortDescription: 'Riz moelleux et sauce verte généreuse en légumes feuilles et gombo.',
        whyThisMonth: 'Au 4e mois, la progestérone détend les muscles de l’intestin et cause de la constipation. Le mucilage du gombo protège la muqueuse intestinale.',
        ingredients: [
          'Gombos frais pilés ou coupés fin',
          'Feuilles d’amarante et épinards locaux soigneusement triés',
          'Morceau de poisson blanc bien cuit à la vapeur',
          'Riz blanc ou complet',
        ],
        safetyTips: 'Bien laver les feuilles vertes pour éliminer les résidus de terre et de sable.',
        proTip: 'Associer ce plat à un grand verre d’eau pour que les fibres végétales gonflent et régulent en douceur le transit.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Jus de mangue naturelle dilué',
      image: 'assets/pregnancy/photos/j.jpg',
      benefit: 'Excellente source de bêta-carotène et d’antioxydants pour la peau et la vision.',
      howToPrepare: 'Éplucher une mangue mûre, mixer la pulpe avec de l’eau potable fraîche. Ne pas ajouter de sucre blanc.',
    ),
  ),

  // ── MOIS 5 ──
  MonthNutritionPlan(
    month: 5,
    trimester: 2,
    weeksRange: '17 - 20 SA',
    title: 'Ossification fœtale & éveil sensoriel',
    priority:
        'Renforcer les apports en calcium, magnésium et protéines bâtisseuses.',
    keyAdvice: [
      'Bébé bouge activement et consolide son squelette : le calcium et la vitamine D sont primordiaux.',
      'Maintenir une bonne hygiène bucco-dentaire en plus des apports calciques.',
      'Veiller à une activité physique modérée quotidienne (marche 30 minutes au frais).',
    ],
    dishes: [
      MonthlyDish(
        id: 'm5_ndole',
        name: 'Ndolé aux feuilles amères, arachide & poisson',
        region: 'Cameroun & Afrique Centrale',
        image: 'assets/pregnancy/photos/ndole.jpg',
        nutrients: ['Calcium végétal', 'Fer', 'Protéines nobles'],
        shortDescription: 'Feuilles de vernonia lavées avec soin, mijotées avec arachide et poisson frais.',
        whyThisMonth: 'Les feuilles vertes cuites combinées à la pâte d’arachide offrent une teneur remarquable en calcium biodisponible pour la minéralisation osseuse.',
        ingredients: [
          'Feuilles de ndolé soigneusement lavées et blanchies pour enlever l’amertume excessive',
          'Pâte d’arachide fraîche',
          'Poisson frais ou viande maigre bien cuits à cœur',
          'Plantain mûr bouilli ou bâton de manioc (miando/bobolo)',
        ],
        safetyTips: 'Bien rincer les feuilles pour enlever les résidus de sable et d’amertume. Limiter l’huile de friture au moment du dressage.',
        proTip: 'Accompagner de plantain vapeur pour un équilibre parfait sans surcharge calorique.',
      ),
      MonthlyDish(
        id: 'm5_couscous_mil',
        name: 'Couscous de mil, légumes du terroir & lait caillé',
        region: 'Sahel & Afrique de l’Ouest',
        image: 'assets/pregnancy/photos/millet_couscous.jpg',
        nutrients: ['Calcium lacté', 'Magnésium', 'Phosphore'],
        shortDescription: 'Céréale rustique très riche en minéraux, accompagnée de légumes et de calcium.',
        whyThisMonth: 'Le mil est une céréale phare pour la future maman : il prévient les crampes nocturnes aux mollets grâce à son abondance en magnésium.',
        ingredients: [
          'Grains de mil roulés et cuits à la vapeur',
          'Sauce de courges, carottes et tomates locales',
          'Yaourt nature ou lait caillé impérativement pasteurisé',
        ],
        safetyTips: 'Attention au lait cru : utiliser uniquement du lait de vache bouilli au préalable ou des produits laitiers industriels pasteurisés.',
        proTip: 'Le mil est digéré lentement, ce qui évite les fringales de fin d’après-midi.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Jus de pulpe de baobab (Bouye)',
      image: 'assets/pregnancy/photos/b.jpg',
      benefit: 'Contient 3 fois plus de calcium que le lait et 6 fois plus de vitamine C que l’orange.',
      howToPrepare: 'Dissoudre la pulpe sèche de baobab dans de l’eau potable tiède, filtrer pour enlever les graines, servir frais avec une pointe de vanille ou muscade.',
    ),
  ),

  // ── MOIS 6 ──
  MonthNutritionPlan(
    month: 6,
    trimester: 2,
    weeksRange: '21 - 24 SA',
    title: 'Croissance musculaire & volume sanguin',
    priority:
        'Prévenir l’anémie physiologique et soutenir la prise de masse fœtale.',
    keyAdvice: [
      'Faire doser son hémoglobine lors de la CPN pour vérifier l’absence d’anémie.',
      'Ne pas sauter de repas pour éviter les vertiges et les chutes de tension.',
      'Surveiller la prise de poids avec votre soignant (gain régulier et harmonieux).',
    ],
    dishes: [
      MonthlyDish(
        id: 'm6_fufu_poisson',
        name: 'Fufu de manioc & poisson frais en papillote',
        region: 'RDC, Congo & Afrique Centrale',
        image: 'assets/pregnancy/photos/f.jpg',
        nutrients: ['Énergie durable', 'Iode & Protéines', 'Minéraux'],
        shortDescription: 'Plat emblématique et réconfortant apportant satiété et forces vives.',
        whyThisMonth: 'Le poisson apporte l’iode indispensable au bon fonctionnement de la glande thyroïde fœtale, qui régule l’ensemble du métabolisme.',
        ingredients: [
          'Farine de manioc bien préparée et cuite en pâte homogène (fufu)',
          'Poisson frais de rivière ou de mer cuit à la vapeur ou à l’étouffée (liboke)',
          'Légumes d’accompagnement : feuilles de pondu ou matembele cuites',
        ],
        safetyTips: 'Le manioc doit toujours être issu de tubercules correctement rouis et cuits. Les feuilles de manioc (pondu) doivent cuire au moins 45 minutes.',
        proTip: 'Les feuilles de pondu bien cuites sont une mine d’or de fer et de vitamine A locale.',
      ),
      MonthlyDish(
        id: 'm6_niebe_ragout',
        name: 'Patate douce orange & ragoût de niébé',
        region: 'Toute l’Afrique subsaharienne',
        image: 'assets/pregnancy/photos/dish_niebe_ragout.jpg',
        nutrients: ['Protéines végétales', 'Bêta-carotène', 'Zinc'],
        shortDescription: 'Ragoût mijoté au chaudron de niébé et dés de patate douce caramélisée.',
        whyThisMonth: 'Le niébé est la légumineuse par excellence de la maman africaine : il fournit des protéines de haute valeur sans alourdir le cœur de graisses animales.',
        ingredients: [
          'Niébé (cornilles) trempé puis mijoté avec oignons et tomates',
          'Patate douce à chair jaune/orange cuite à l’eau ou rôtie',
          'Herbes potagères et persil frais',
        ],
        safetyTips: 'Bien faire tremper les légumineuses la veille pour éliminer l’acide phytique et faciliter la digestion.',
        proTip: 'Assaisonner avec du gingembre râpé et du persil pour stimuler l’appétit de manière naturelle.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Jus de papaye fraîche nature',
      image: 'assets/pregnancy/photos/p.jpg',
      benefit: 'Riche en enzymes digestives douces et provitamine A, aide à garder un teint radieux.',
      howToPrepare: 'Choisir une papaye bien mûre (jamais verte !), retirer graines et peau, mixer avec un peu d’eau potable et déguster frais.',
    ),
  ),

  // ── MOIS 7 ──
  MonthNutritionPlan(
    month: 7,
    trimester: 3,
    weeksRange: '25 - 28 SA',
    title: 'Début du 3e trimestre & prévention des reflux',
    priority: 'Fournir une énergie constante tout en évitant les brûlures d’estomac dues à la pression de l’utérus.',
    keyAdvice: [
      'Bébé prend de la place et compresse l’estomac : fractionner en repas plus légers et plus fréquents.',
      'Ne pas s’allonger immédiatement après le repas : attendre au moins 1 heure à 1 heure 30.',
      'Dormir sur le côté gauche avec un oreiller sous le ventre pour soulager la circulation veineuse.',
    ],
    dishes: [
      MonthlyDish(
        id: 'm7_greens_fish',
        name: 'Feuilles vertes mijotées & poisson vapeur',
        region: 'Afrique Centrale & de l’Est',
        image: 'assets/pregnancy/photos/l.jpg',
        nutrients: ['Fer héminique', 'Fibres douces', 'Folates'],
        shortDescription: 'Bouillon de feuilles fraîches (amarante / matembele) et poisson tendre.',
        whyThisMonth: 'Les feuilles vertes cuites fournissent le fer nécessaire à l’oxygénation du fœtus en pleine prise de poids, tout en restant très digestes.',
        ingredients: [
          'Feuilles d’amarante ou de patate douce fraîches hachées',
          'Filet de poisson d’eau douce cuit à l’étouffée',
          'Tomates fraîches concassées et oignons doux',
        ],
        safetyTips: 'Cuire suffisamment les feuilles pour désactiver les oxalates et garantir une absorption maximale des minéraux.',
        proTip: 'Presser quelques gouttes de citron pour libérer tout le fer végétal.',
      ),
      MonthlyDish(
        id: 'm7_jollof_rice',
        name: 'Riz Jollof léger aux légumes & œuf cuit',
        region: 'Afrique de l’Ouest',
        image: 'assets/pregnancy/photos/rice.jpg',
        nutrients: ['Glucides complexes', 'Lycopène', 'Protéines'],
        shortDescription: 'Riz cuit dans un coulis de tomates fraîches, poivrons doux et œuf dur.',
        whyThisMonth: 'Une source d’énergie propre et digeste pour prévenir les baisses de forme du début de 3e trimestre sans provoquer de brûlures.',
        ingredients: [
          'Riz parfumé étuvé',
          'Coulis de tomates mûres, oignons et poivrons doux cuits sans excès d’huile',
          'Œuf dur bien ferme coupé en deux',
        ],
        safetyTips: 'Limiter le piment fort dans le coulis pour préserver l’estomac sensible de la maman.',
        proTip:
            'Déguster chaud avec une tranche de concombre frais bien nettoyé.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Infusion fraîche de Bissap (Fleurs d’hibiscus)',
      image: 'assets/pregnancy/photos/bi.jpg',
      benefit: 'Riche en vitamine C et antioxydants, boisson rafraîchissante très appréciée.',
      howToPrepare: 'Infuser les calices d’hibiscus séchés dans de l’eau bouillante, filtrer, refroidir et aromatiser avec quelques feuilles de menthe. Ne pas trop sucrer.',
    ),
  ),

  // ── MOIS 8 ──
  MonthNutritionPlan(
    month: 8,
    trimester: 3,
    weeksRange: '29 - 32 SA',
    title: 'Maturation fœtale & réduction des œdèmes',
    priority: 'Soulager le gonflement des jambes et des pieds en réduisant le sel et en buvant abondamment.',
    keyAdvice: [
      'Bannir les cubes de bouillon industriels et les poissons trop salés qui retiennent l’eau.',
      'Boire 2 à 2,5 litres d’eau potable en journée, mais réduire 1 heure avant le coucher.',
      'Élever les jambes 15 minutes chaque après-midi pour stimuler le retour veineux.',
    ],
    dishes: [
      MonthlyDish(
        id: 'm8_kati_kati',
        name: 'Poulet braisé doux (Kati-kati) & féculent',
        region: 'Cameroun & Afrique Centrale',
        image: 'assets/pregnancy/photos/meal.jpg',
        nutrients: ['Protéines musculaires', 'Fer héminique', 'Satiété'],
        shortDescription: 'Poulet mijoté aux aromates doux sans excès de gras, servi avec légumes du terroir.',
        whyThisMonth: 'La masse musculaire et les réserves de glycogène de bébé se consolident. Ce plat apporte les acides aminés indispensables.',
        ingredients: [
          'Morceaux de volaille bien dégraissés et cuits à cœur',
          'Tomates fraîches, céleri, ail et poireaux émincés',
          'Portion de plantain vapeur ou féculent local',
        ],
        safetyTips: 'Cuire la volaille à cœur : aucune trace rosée à l’os.',
        proTip: 'L’ail et le céleri agissent comme de légers diurétiques naturels très bénéfiques en cas de chevilles gonflées.',
      ),
      MonthlyDish(
        id: 'm8_thieboudienne',
        name: 'Thiéboudienne (Ceebu Jën) au poisson noble',
        region: 'Sénégal & Afrique de l’Ouest',
        image: 'assets/pregnancy/photos/dish_thieboudienne.jpg',
        nutrients: ['Oméga-3 DHA', 'Iode naturel', 'Légumes variés'],
        shortDescription: 'Riz mijoté avec poisson frais de roche, manioc, carotte et chou blanc.',
        whyThisMonth: 'Le cerveau de bébé connaît son pic de croissance. Les acides gras DHA du poisson sont transférés en masse vers le fœtus.',
        ingredients: [
          'Poisson frais blanc (thiof ou dorade) cuit à cœur',
          'Riz brisé cuit dans le bouillon de légumes',
          'Carottes, navets, chou et courge bien cuits',
        ],
        safetyTips: 'Éviter le poisson salé/séché en excès dans la recette pour contrôler la tension artérielle.',
        proTip: 'Le citron et le persil rehaussent le goût sans nécessiter d’ajout de sel.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Citronnade douce maison au miel pur',
      image: 'assets/pregnancy/photos/c.jpg',
      benefit: 'Riche en vitamine C et flavonoïdes pour tonifier la paroi des vaisseaux sanguins et éliminer les toxines.',
      howToPrepare: 'Presser un demi-citron frais dans de l’eau potable tiède ou fraîche. Adoucir avec une cuillère à café de miel pur si besoin.',
    ),
  ),

  // ── MOIS 9 ──
  MonthNutritionPlan(
    month: 9,
    trimester: 3,
    weeksRange: '33 - 40 SA',
    title: 'Préparation à l’accouchement & à la lactation',
    priority: 'Faire le plein d’énergie durable pour le travail de l’accouchement et préparer la montée de lait.',
    keyAdvice: [
      'Repas simples, très digestes et riches en glucides lents pour emmagasiner le glycogène musculaire.',
      'Garder des petites collations saines et de l’eau dans le sac de maternité.',
      'Continuer la prise de fer jusqu’au terme et après l’accouchement selon la prescription médicale.',
    ],
    dishes: [
      MonthlyDish(
        id: 'm9_alloco_plantain',
        name: 'Alloco doux de plantain mûr & poisson',
        region: 'Côte d’Ivoire',
        image: 'assets/pregnancy/photos/al.jpg',
        nutrients: ['Énergie rapide et durable', 'Potassium', 'Protéines'],
        shortDescription: 'Dés de banane plantain bien dorés, accompagnés de poisson braisé et sauce tomate douce.',
        whyThisMonth: 'L’accouchement demande un effort physique considérable. Le plantain mûr fournit une réserve de glucose musculaire optimale.',
        ingredients: [
          'Banane plantain bien mûre dorée avec peu d’huile',
          'Filet de poisson d’eau douce ou mer bien cuit',
          'Sauce douce à la tomate et aux oignons fondants',
        ],
        safetyTips: 'Éponger soigneusement le plantain sur du papier absorbant pour éviter l’excès d’huile de friture.',
        proTip: 'Le plantain mûr apporte un réconfort immédiat et calme la nervosité d’avant terme.',
      ),
      MonthlyDish(
        id: 'm9_egusi_soup',
        name: 'Soupe d’Egusi aux graines de courge & légumes',
        region: 'Nigeria, Cameroun',
        image: 'assets/pregnancy/photos/so.jpg',
        nutrients: ['Protéines galactogènes', 'Bonnes graisses', 'Zinc'],
        shortDescription: 'Sauce traditionnelle onctueuse aux graines de courge pilées et légumes feuilles.',
        whyThisMonth: 'Recommandé traditionnellement pour préparer la montée de lait maternel et apporter les oligo-éléments réparateurs pour le post-partum.',
        ingredients: [
          'Graines de courge (egusi/agoussi) finement moulues',
          'Feuilles d’épinards ou amarante fraîches',
          'Morceaux de poisson blanc ou volaille bien cuits',
        ],
        safetyTips: 'Bien cuire la sauce pour que les graines de courge soient digestes et onctueuses.',
        proTip: 'Excellente source de zinc qui favorisera la cicatrisation tissulaire après l’accouchement.',
      ),
    ],
    drink: MonthlyDrink(
      name: 'Cocktail de fruits frais pressés du verger',
      image: 'assets/pregnancy/photos/co.jpg',
      benefit: 'Stimulant naturel d’énergie, de vitamines et d’hydratation pour aborder le grand jour en pleine forme.',
      howToPrepare: 'Presser des fruits frais de saison (orange, pastèque ou ananas) avec de l’eau potable fraîche. Boire frais pour un regain de tonus immédiat.',
    ),
  ),
];

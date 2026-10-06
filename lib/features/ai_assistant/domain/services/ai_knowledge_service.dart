class AiKnowledgeService {
  const AiKnowledgeService();

  static const List<Map<String, dynamic>> _kb = [
    {
      'keywords': ['dos', 'mal au dos', 'lombaire'],
      'answer': 'Le mal de dos est fréquent pendant la grossesse car le ventre modifie votre posture. Reposez-vous sur le côté, portez des chaussures plates et évitez de porter des charges lourdes. Si la douleur est intense ou accompagnée de contractions, consultez.',
    },
    {
      'keywords': ['aliment', 'manger', 'nourriture', 'nutrition', 'repas'],
      'answer': 'Privilégiez les légumes verts (feuilles de manioc, gombo), les légumineuses (haricots, niébé), le poisson bien cuit, les fruits et les céréales. Buvez de l\'eau potable. Évitez la viande crue, l\'alcool et limitez le café.',
    },
    {
      'keywords': ['paludisme', 'moustique', 'palu', 'fièvre'],
      'answer': 'Dormez sous une moustiquaire imprégnée chaque nuit. Le traitement préventif (TPI) est proposé lors des consultations prénatales. En cas de fièvre, consultez rapidement.',
    },
    {
      'keywords': ['nausée', 'vomi', 'vomissement', 'mal de cœur'],
      'answer': 'Les nausées sont courantes au premier trimestre. Mangez de petites quantités souvent, buvez par petites gorgées. Si vous ne gardez rien, consultez.',
    },
    {
      'keywords': ['saign', 'sang', 'perte'],
      'answer': '⚠️ Un saignement pendant la grossesse nécessite de consulter rapidement un professionnel de santé. Utilisez le bouton Urgence si besoin.',
    },
    {
      'keywords': ['bouge', 'mouvement', 'coup de pied', 'activité'],
      'answer': 'À partir de 20 semaines, vous sentez bébé bouger. Si les mouvements diminuent nettement, allongez-vous sur le côté gauche et comptez ; si moins de 10 mouvements en 2 h, consultez.',
    },
    {
      'keywords': ['sport', 'marche', 'exercice', 'activité physique'],
      'answer': 'La marche quotidienne de 30 minutes est excellente. Évitez les sports à risque de chute ou de choc.',
    },
  ];

  String answer(String query) {
    final lower = query.toLowerCase();
    for (final item in _kb) {
      final List<String> keywords = item['keywords'] as List<String>;
      for (final kw in keywords) {
        if (lower.contains(kw)) {
          return item['answer'] as String;
        }
      }
    }
    return 'Je n\'ai pas encore de réponse enregistrée pour cette question. Notez-la pour votre prochaine consultation, ou parlez-en à votre sage-femme. En cas de doute, contactez un professionnel de santé.';
  }
}

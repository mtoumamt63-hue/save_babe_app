import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../widgets/pregnancy_illustration.dart';
import '../widgets/pregnancy_page.dart';

class NewbornGuideScreen extends StatelessWidget {
  const NewbornGuideScreen({super.key});

  @override
  Widget build(BuildContext context) => PregnancyPage(
    title: 'Suivi du nouveau-né',
    subtitle: 'Premiers jours · allaitement · sommeil · signes de danger',
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PregnancyIllustration.topic(name: 'newborn_first_days'),
          const SizedBox(height: 12),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Premiers jours', style: AppTypography.labelL),
                const SizedBox(height: 8),
                Text(
                  'Peau à peau dès la naissance si possible. Retarder le premier bain d’au moins 24 h. Garder le cordon propre et sec et ne rien appliquer de traditionnel. Mère et bébé dans la même chambre jour et nuit. Contrôles : jour 3, jours 7–14 et 6 semaines.',
                  style: AppTypography.bodyM.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PregnancyIllustration.topic(name: 'newborn_breastfeeding'),
          const SizedBox(height: 12),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Allaitement', style: AppTypography.labelL),
                const SizedBox(height: 8),
                Text(
                  'Allaitement exclusif pendant les 6 premiers mois selon les recommandations de santé, puis aliments complémentaires et poursuite jusqu’à 2 ans ou plus. Mettre au sein dans la première heure si possible et proposer à la demande, jour et nuit. Une mauvaise prise du sein ou une douleur persistante justifie une aide d’une sage-femme ou d’une conseillère en allaitement.',
                  style: AppTypography.bodyM.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PregnancyIllustration.topic(name: 'newborn_safe_sleep'),
          const SizedBox(height: 12),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sommeil sécurisé', style: AppTypography.labelL),
                const SizedBox(height: 8),
                Text(
                  'Coucher le bébé sur le dos pour les siestes et la nuit, sur une surface ferme et plane, sans oreiller, couverture épaisse ou objets mous. Garder le bébé dans la même chambre mais sur une surface de sommeil séparée. Éviter de s’endormir avec le bébé sur un canapé.',
                  style: AppTypography.bodyM.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PregnancyIllustration.topic(name: 'newborn_emergency'),
          const SizedBox(height: 12),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Urgence chez le bébé', style: AppTypography.labelL),
                const SizedBox(height: 8),
                Text(
                  'Consultez immédiatement si le bébé refuse de téter, est très somnolent ou difficile à réveiller, convulse, respire très vite ou avec difficulté, a une température ≥ 37,5 °C ou < 35,5 °C, devient jaune dans les premières 24 h, a un cordon rouge/purulent, du pus aux yeux, des pustules, ne bouge pas spontanément, vomit tout ou a une diarrhée importante.',
                  style: AppTypography.bodyM.copyWith(
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../widgets/pregnancy_illustration.dart';
import '../widgets/pregnancy_page.dart';

class ChildbirthScreen extends StatelessWidget {
  const ChildbirthScreen({super.key});

  @override
  Widget build(BuildContext context) => PregnancyPage(
    title: 'Préparer l’accouchement',
    subtitle:
        'Comprendre les douleurs, savoir quand partir et préparer son plan',
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PregnancyIllustration.topic(name: 'labor_pain'),
          const SizedBox(height: 12),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Les douleurs du travail', style: AppTypography.labelL),
                const SizedBox(height: 8),
                Text(
                  'Les contractions deviennent généralement régulières, plus fortes et plus rapprochées. La douleur peut être ressentie dans le bas-ventre, le dos ou le bassin et varie beaucoup d’une femme à l’autre.',
                  style: AppTypography.bodyM.copyWith(height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pour se préparer : respiration lente et profonde, changement de position, marche si elle est autorisée, présence d’une personne choisie et échanges avec l’équipe de maternité sur les méthodes antalgiques disponibles.',
                  style: AppTypography.bodyM.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PregnancyIllustration.topic(name: 'go_maternity'),
          const SizedBox(height: 12),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quand partir à la maternité ?',
                  style: AppTypography.labelL,
                ),
                const SizedBox(height: 8),
                Text(
                  'Partez sans attendre en cas de contractions régulières et de plus en plus fortes, perte des eaux, saignement, baisse des mouvements du bébé, fièvre, douleur continue ou maux de tête intenses avec troubles de la vue. Si vous habitez loin de la maternité, anticipez le trajet dès le début du travail.',
                  style: AppTypography.bodyM.copyWith(height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Le bon moment pour partir dépend aussi des consignes de votre maternité. Demandez-les lors d’une consultation prénatale et gardez-les avec votre dossier.',
                  style: AppTypography.bodyS.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plan de naissance', style: AppTypography.labelL),
                const SizedBox(height: 8),
                ...[
                  'Choisir la structure de santé et connaître l’itinéraire',
                  'Prévoir voiture, moto ou ambulance et un contact de confiance',
                  'Préparer carnet de santé, résultats, identité/assurance, vêtements maman/bébé, serviettes, eau et collation',
                  'Prévoir la garde des autres enfants',
                  'Identifier une structure capable de faire une césarienne ou de gérer une urgence',
                ].map(
                  (x) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• '),
                        Expanded(child: Text(x)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SbCard(
            child: Text(
              'Césarienne et épisiotomie : une césarienne est décidée pour des raisons médicales. L’épisiotomie ne doit pas être systématique ; elle est réservée à certaines situations selon le soignant.',
              style: AppTypography.bodyM.copyWith(height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          SbCard(
            child: Text(
              'Autour de la naissance : peau à peau et allaitement dans la première heure si possible ; clampage du cordon pas avant 1 minute en général sauf urgence ; premier bain retardé d’au moins 24 h ; mère et bébé restent ensemble et en structure au moins 24 h selon les recommandations de l’équipe soignante.',
              style: AppTypography.bodyM.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    ),
  );
}

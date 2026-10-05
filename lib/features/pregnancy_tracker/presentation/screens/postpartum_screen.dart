import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../widgets/pregnancy_illustration.dart';
import '../widgets/pregnancy_page.dart';

class PostpartumScreen extends StatelessWidget {
  const PostpartumScreen({super.key});

  @override
  Widget build(BuildContext context) => PregnancyPage(
    title: 'Après l’accouchement',
    subtitle: 'Récupération de la maman · 24 h à 6 semaines',
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PregnancyIllustration.topic(name: 'postpartum_visits'),
        const SizedBox(height: 12),
        SbCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Les rendez-vous postnatals', style: AppTypography.labelL),
          const SizedBox(height: 8),
          ...['Dans les 24 h : surveillance de la mère et du bébé','Jour 3 (48–72 h) : contrôle mère + bébé','Jours 7–14 : contrôle mère + bébé, si possible à domicile','6 semaines : contrôle mère + bébé, contraception/espacement des naissances et santé mentale'].map((x) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('• $x'))),
        ])),
        const SizedBox(height: 12),
        PregnancyIllustration.topic(name: 'postpartum_recovery'),
        const SizedBox(height: 12),
        SbCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ce qui peut être normal', style: AppTypography.labelL),
          const SizedBox(height: 8),
          Text('Lochies : rouges au début puis plus claires et diminuant sur 4 à 6 semaines. Contractions de l’utérus pendant l’allaitement les premiers jours. Fatigue, sommeil fractionné, seins gonflés vers le 3e–4e jour, sueurs et chute de cheveux plus tard. Une douleur de cicatrice qui diminue progressivement peut être attendue.', style: AppTypography.bodyM.copyWith(height: 1.4)),
        ])),
        const SizedBox(height: 12),
        SbCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Récupérer son corps', style: AppTypography.labelL),
          const SizedBox(height: 8),
          Text('Boire et garder une alimentation variée, sans régime strict. Poursuivre fer + acide folique selon l’avis du soignant. Reprendre la marche dès que possible et les exercices du plancher pelvien ; la reprise du sport se fait progressivement et selon l’avis du soignant, notamment après une césarienne.', style: AppTypography.bodyM.copyWith(height: 1.4)),
        ])),
        const SizedBox(height: 12),
        PregnancyIllustration.topic(name: 'postpartum_warning'),
        const SizedBox(height: 12),
        SbCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Signes qui nécessitent une consultation urgente', style: AppTypography.labelL),
          const SizedBox(height: 8),
          Text('Saignement très abondant ou qui reprend fortement ; fièvre ≥ 38 °C, frissons, pertes malodorantes ou douleur abdominale croissante ; maux de tête intenses, troubles visuels ou convulsions ; difficulté à respirer, douleur thoracique ou jambe gonflée et douloureuse ; cicatrice rouge, qui coule ou s’ouvre ; tristesse profonde persistante ou idées noires.', style: AppTypography.bodyM.copyWith(height: 1.4, fontWeight: FontWeight.w600)),
        ])),
        const SizedBox(height: 12),
        SbCard(child: Text('Santé mentale : le baby blues peut durer quelques jours. Au-delà de 2 semaines, ou en cas d’idées noires, il faut en parler rapidement à un soignant et à une personne de confiance.', style: AppTypography.bodyM.copyWith(height: 1.4))),
      ]),
    ),
  );
}

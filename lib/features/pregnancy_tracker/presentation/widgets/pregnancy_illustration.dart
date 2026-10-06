import 'package:flutter/material.dart';

class PregnancyIllustration extends StatelessWidget {
  const PregnancyIllustration.week({super.key, required this.week})
    : name = null;

  const PregnancyIllustration.topic({super.key, required this.name})
    : week = null;

  final int? week;
  final String? name;

  // All screens use bundled photographs so they remain visible offline.
  static const _weeklyPhoto = <int, String>{
    8: 'fetus_08',
    12: 'fetus_12',
    20: 'fetus_20',
    32: 'fetus_32',
  };

  static const _topicPhoto = <String, String>{
    'prenatal': 'prenatal',
    'go_maternity': 'maternity',
    'newborn_first_days': 'maternity',
    'newborn_breastfeeding': 'breastfeeding',
    'newborn_safe_sleep': 'maternity',
    'newborn_emergency': 'maternity',
    'postpartum_recovery': 'maternity',
    'postpartum_warning': 'maternity',
    'postpartum_visits': 'prenatal',
    'labor_pain': 'maternity',
    'meal_fufu_poisson': 'fufu',
    'meal_riz_gombo_poisson': 'rice_gombo',
    'meal_ndole': 'ndole',
    'meal_fonio': 'fonio',
    'meal_mafe': 'mafe',
    'meal_attieke_poisson': 'attieke',
    'meal_haricots_plantain': 'beans_plantain',
    'meal_couscous_mil': 'millet_couscous',
    'meal_patate_haricots_avocat': 'patate_haricots',
    'juice_mangue': 'juice_mango',
    'juice_goyave': 'juice_guava',
    'juice_papaye': 'juice_papaya',
    'juice_coco': 'juice_coconut',
    'juice_baobab': 'juice_baobab',
    'juice_gingembre': 'juice_ginger',
  };

  static int? exactPhotoWeek(int week) =>
      _weeklyPhoto.containsKey(week) ? week : null;

  @override
  Widget build(BuildContext context) {
    final referenceWeek = week == null ? null : exactPhotoWeek(week!);
    final photoKey = week != null
        ? (referenceWeek == null ? null : _weeklyPhoto[referenceWeek])
        : _topicPhoto[name];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: photoKey == null
            ? Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Text(
                  week == null
                      ? 'Aucune photo vérifiée disponible pour ce sujet.'
                      : 'Aucune échographie vérifiée pour la semaine $week.',
                  textAlign: TextAlign.center,
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/pregnancy/photos/$photoKey.jpg',
                    fit: BoxFit.cover,
                  ),
                  if (referenceWeek != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Échographie réelle · SA $referenceWeek',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

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
    if (week != null) {
      final w = week!.clamp(1, 40);
      final weekAsset = 'assets/pregnancy/weekly/week_${w.toString().padLeft(2, '0')}.png';
      final referenceWeek = exactPhotoWeek(week!);
      final echoPhoto = referenceWeek != null ? _weeklyPhoto[referenceWeek] : null;

      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E2448)
                : const Color(0xFFF0F4FC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      weekAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => echoPhoto != null
                          ? Image.asset(
                              'assets/pregnancy/photos/$echoPhoto.jpg',
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.child_care_rounded,
                              size: 60,
                              color: Colors.blueAccent,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Semaine $w',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final photoKey = _topicPhoto[name];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: photoKey == null
            ? Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Aucune photo vérifiée disponible pour ce sujet.',
                  textAlign: TextAlign.center,
                ),
              )
            : Image.asset(
                'assets/pregnancy/photos/$photoKey.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF3B57D4),
                  child: const Icon(Icons.photo, color: Colors.white),
                ),
              ),
      ),
    );
  }
}

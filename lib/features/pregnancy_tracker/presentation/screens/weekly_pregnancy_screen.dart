import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../data/pregnancy_dataset.dart';
import '../widgets/pregnancy_illustration.dart';
import '../widgets/pregnancy_page.dart';

class WeeklyPregnancyScreen extends ConsumerStatefulWidget {
  const WeeklyPregnancyScreen({super.key, this.initialWeek});
  final int? initialWeek;

  @override
  ConsumerState<WeeklyPregnancyScreen> createState() =>
      _WeeklyPregnancyScreenState();
}

class _WeeklyPregnancyScreenState extends ConsumerState<WeeklyPregnancyScreen> {
  late int selectedWeek;
  final ScrollController _weekController = ScrollController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserStateProvider);
    final age = DateFormatter.gestationalAge(user.lmp);
    selectedWeek = (widget.initialWeek ?? age?.weeks ?? 1).clamp(1, 40).toInt();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedWeek());
  }

  @override
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }

  void _centerSelectedWeek() {
    if (!_weekController.hasClients) return;
    final target = ((selectedWeek - 1) * 48.0 - 120).clamp(
      0.0,
      _weekController.position.maxScrollExtent,
    );
    _weekController.animateTo(
      target,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _selectWeek(int week) {
    setState(() => selectedWeek = week);
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedWeek());
  }

  @override
  Widget build(BuildContext context) {
    final info = pregnancyDataset.firstWhere((e) => e.week == selectedWeek);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trimester = selectedWeek <= 13
        ? 1
        : selectedWeek <= 27
        ? 2
        : 3;

    return PregnancyPage(
      title: 'Ma grossesse, semaine par semaine',
      subtitle: 'SA 1 à SA 40',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 58,
              child: ListView.separated(
                controller: _weekController,
                padding: const EdgeInsets.only(bottom: 8),
                scrollDirection: Axis.horizontal,
                itemCount: 40,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final week = index + 1;
                  final active = week == selectedWeek;
                  return ChoiceChip(
                    label: Text('$week'),
                    selected: active,
                    onSelected: (_) => _selectWeek(week),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: active ? Colors.white : null,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
            SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SA $selectedWeek · Trimestre $trimester',
                    style: AppTypography.displayM.copyWith(
                      color: isDark
                          ? AppColors.darkCardForeground
                          : AppColors.cardForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    info.babySize,
                    style: AppTypography.labelM.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  PregnancyIllustration.week(week: selectedWeek),
                  const SizedBox(height: 16),
                  _Section(title: 'Évolution du bébé', text: info.development),
                  _Section(
                    title: 'Ce que vous pouvez ressentir',
                    text: info.motherBody,
                  ),
                  _Section(
                    title: 'Ce que vous pouvez faire cette semaine',
                    text: info.tip,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push('/nutrition?trimester=$trimester'),
              icon: const Icon(Icons.restaurant_menu_rounded),
              label: const Text('Voir la nourriture de cette période'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push('/prenatal'),
              icon: const Icon(Icons.event_rounded),
              label: const Text('Voir les consultations prénatales'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.labelM),
        const SizedBox(height: 4),
        Text(text, style: AppTypography.bodyM.copyWith(height: 1.4)),
      ],
    ),
  );
}

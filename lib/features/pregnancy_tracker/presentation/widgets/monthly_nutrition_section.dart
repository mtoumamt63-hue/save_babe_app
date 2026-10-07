import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/monthly_nutrition_data.dart';

class MonthlyNutritionSection extends StatefulWidget {
  final int selectedWeek;
  final int trimester;
  final bool isDark;

  const MonthlyNutritionSection({
    super.key,
    required this.selectedWeek,
    required this.trimester,
    required this.isDark,
  });

  @override
  State<MonthlyNutritionSection> createState() => _MonthlyNutritionSectionState();
}

class _MonthlyNutritionSectionState extends State<MonthlyNutritionSection> {
  late int _activeMonth;
  final ScrollController _horizontalMonthScrollController = ScrollController();

  int get _calculatedCurrentMonth =>
      ((widget.selectedWeek - 1) ~/ 4 + 1).clamp(1, 9);

  @override
  void initState() {
    super.initState();
    _activeMonth = _calculatedCurrentMonth;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
    });
  }

  @override
  void didUpdateWidget(covariant MonthlyNutritionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedWeek != widget.selectedWeek) {
      final newCurrentMonth = _calculatedCurrentMonth;
      if (_activeMonth != newCurrentMonth) {
        setState(() {
          _activeMonth = newCurrentMonth;
        });
        _scrollToSelectedMonth();
      }
    }
  }

  @override
  void dispose() {
    _horizontalMonthScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedMonth() {
    if (!_horizontalMonthScrollController.hasClients) return;
    const itemWidth = 104.0;
    final targetOffset = ((_activeMonth - 1) * itemWidth) - 40.0;
    _horizontalMonthScrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _horizontalMonthScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  MonthNutritionPlan get _currentPlan {
    return monthlyNutritionPlans.firstWhere(
      (p) => p.month == _activeMonth,
      orElse: () => monthlyNutritionPlans.first,
    );
  }

  void _showDishDetailsModal(BuildContext context, MonthlyDish dish) {
    final isDark = widget.isDark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161B36) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 25,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Poignée de glissement
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Grande photo immersive avec coins arrondis
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Image.asset(
                                dish.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.primary,
                                  child: const Center(
                                    child: Icon(
                                      Icons.restaurant_rounded,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      size: 13,
                                      color: AppColors.pink,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      dish.region,
                                      style: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => Navigator.of(ctx).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Nom du plat
                      Text(
                        dish.name,
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF1A2244),
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Badges de nutriments
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: dish.nutrients.map((n) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF222B55)
                                  : const Color(0xFFEBF1FD),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF333E78)
                                    : const Color(0xFFD4E1FB),
                              ),
                            ),
                            child: Text(
                              n,
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFF8DB0FA)
                                    : AppColors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      // Description courte
                      Text(
                        dish.shortDescription,
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFFB5C1E0)
                              : const Color(0xFF4B5563),
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Encadré : Pourquoi ce plat ce mois-ci ?
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E2850)
                              : const Color(0xFFF3F7FE),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2B3A72)
                                : const Color(0xFFD8E4FC),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFF59E0B),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Pourquoi recommandé au Mois $_activeMonth ?',
                                  style: TextStyle(
                                    fontFamily: 'Figtree',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1B254E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dish.whyThisMonth,
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 13,
                                color: isDark
                                    ? const Color(0xFFC7D2EE)
                                    : const Color(0xFF374151),
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Ingrédients & Composition équilibrée
                      Text(
                        'Ingrédients & Composition locale',
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF1A2244),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...dish.ingredients.map(
                        (ing) => Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ing,
                                  style: TextStyle(
                                    fontFamily: 'Figtree',
                                    fontSize: 13,
                                    color: isDark
                                        ? const Color(0xFFC7D2EE)
                                        : const Color(0xFF374151),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Conseils de préparation & sécurité sanitaire
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF332026)
                              : const Color(0xFFFDF2F4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF5A2A38)
                                : const Color(0xFFF9CFD7),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.health_and_safety_rounded,
                                  color: Color(0xFFE11D48),
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Hygiène & Sécurité médicale',
                                  style: TextStyle(
                                    fontFamily: 'Figtree',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFE11D48),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dish.safetyTips,
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 12.5,
                                color: isDark
                                    ? const Color(0xFFF5B6C5)
                                    : const Color(0xFF881337),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Astuce du nutritionniste SaveBabe
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E3228)
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2E5341)
                                : const Color(0xFFBBF7D0),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.tips_and_updates_rounded,
                              color: Color(0xFF16A34A),
                              size: 19,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Astuce nutrition SaveBabe',
                                    style: TextStyle(
                                      fontFamily: 'Figtree',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dish.proTip,
                                    style: TextStyle(
                                      fontFamily: 'Figtree',
                                      fontSize: 12.5,
                                      color: isDark
                                          ? const Color(0xFFB4E4C6)
                                          : const Color(0xFF166534),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Bouton fermer
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'J’ai compris',
                            style: TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDrinkDetailsModal(BuildContext context, MonthlyDrink drink) {
    final isDark = widget.isDark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161B36) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            drink.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primary,
                              child: const Icon(
                                Icons.local_drink_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        drink.name,
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF1A2244),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1F2B48)
                              : const Color(0xFFEEF5FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bienfait pour la maman :',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              drink.benefit,
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 13,
                                color: isDark
                                    ? const Color(0xFFC7D6F6)
                                    : const Color(0xFF2B3A67),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Préparation saine et hygiène :',
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF1A2244),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        drink.howToPrepare,
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFFB5C1E0)
                              : const Color(0xFF4B5563),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Fermer',
                            style: TextStyle(
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final plan = _currentPlan;
    final realCurrentMonth = _calculatedCurrentMonth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de section et description
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alimentation & Recettes',
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1B2349),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/nutrition-full'),
                child: const Row(
                  children: [
                    Text(
                      'Tout voir',
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Choisissez le mois pour filtrer les propositions de nutrition adaptées.',
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 12.5,
              color: isDark ? const Color(0xFF8E9BBF) : const Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 14),

          // ── SÉLECTEUR HORIZONTAL DES MOIS (Mois 1 à 9) ──
          SizedBox(
            height: 74,
            child: ListView.separated(
              controller: _horizontalMonthScrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 9,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final monthNumber = index + 1;
                final isSelected = _activeMonth == monthNumber;
                final isCurrentPregnancyMonth = realCurrentMonth == monthNumber;
                final trimester = monthNumber <= 3
                    ? 1
                    : monthNumber <= 6
                    ? 2
                    : 3;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _activeMonth = monthNumber;
                    });
                    _scrollToSelectedMonth();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    width: 98,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2E63E7),
                                Color(0xFF1E48BA),
                              ],
                            )
                          : null,
                      color: isSelected
                          ? null
                          : (isDark
                              ? const Color(0xFF1B2245)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                ? const Color(0xFF2A3462)
                                : const Color(0xFFE2E8F4)),
                        width: isSelected ? 0 : 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2E63E7).withValues(
                                  alpha: 0.38,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.2 : 0.03,
                                ),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'T$trimester',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.85)
                                    : (isDark
                                        ? const Color(0xFF7E8EA8)
                                        : const Color(0xFF8B98A5)),
                              ),
                            ),
                            if (isCurrentPregnancyMonth) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.pink,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Mois $monthNumber',
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937)),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          planForMonth(monthNumber).weeksRange,
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.8)
                                : (isDark
                                    ? const Color(0xFF8E9BBF)
                                    : const Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // ── CARTE RÉSUMÉ & PRIORITÉ DU MOIS SÉLECTIONNÉ ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2246) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2B3666)
                    : const Color(0xFFE3E9F6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mois $_activeMonth · ${plan.weeksRange}',
                            style: const TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plan.title,
                            style: TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1B2349),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222C56)
                        : const Color(0xFFF3F7FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          plan.priority,
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFCAD7F5)
                                : const Color(0xFF273860),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...plan.keyAdvice.map(
                  (advice) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 15,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            advice,
                            style: TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 12.5,
                              color: isDark
                                  ? const Color(0xFFB5C1E0)
                                  : const Color(0xFF4B5563),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ── TITRE PROPOSITIONS DE PLATS DU MOIS ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plats recommandés — Mois $_activeMonth',
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1B2349),
                ),
              ),
              Text(
                'Appuyez pour voir la fiche',
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF8897BA)
                      : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── CARTES DES PLATS AVEC IMAGES ÉLÉGANTES ET CLIQUABLES ──
          ...plan.dishes.map((dish) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () => _showDishDetailsModal(context, dish),
                child: Container(
                  width: double.infinity,
                  height: 215,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.35 : 0.10,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image du plat
                        Image.asset(
                          dish.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primary,
                            child: const Center(
                              child: Icon(
                                Icons.restaurant_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Dégradé sombre pour garantir un contraste parfait
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.15),
                                Colors.black.withValues(alpha: 0.40),
                                Colors.black.withValues(alpha: 0.90),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),

                        // Badges en haut de l'image
                        Positioned(
                          top: 14,
                          left: 14,
                          right: 14,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      size: 13,
                                      color: AppColors.pink,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      dish.region,
                                      style: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.85,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  dish.nutrients.first,
                                  style: const TextStyle(
                                    fontFamily: 'Figtree',
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Contenu textuel et bouton d'action en bas
                        Positioned(
                          bottom: 14,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dish.name,
                                style: const TextStyle(
                                  fontFamily: 'Figtree',
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                dish.shortDescription,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Figtree',
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: dish.nutrients.take(2).map((nut) {
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(right: 6),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.18,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          nut,
                                          style: const TextStyle(
                                            fontFamily: 'Figtree',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Détails',
                                          style: TextStyle(
                                            fontFamily: 'Figtree',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1B2349),
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 13,
                                          color: Color(0xFF1B2349),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          // ── BOISSON CONSEILLÉE DU MOIS ──
          GestureDetector(
            onTap: () => _showDrinkDetailsModal(context, plan.drink),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B2245) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2A3462)
                      : const Color(0xFFE2E8F4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.2 : 0.04,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: Image.asset(
                        plan.drink.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primary,
                          child: const Icon(
                            Icons.local_drink_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Boisson saine du mois',
                            style: TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan.drink.name,
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1B2349),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          plan.drink.benefit,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 11.5,
                            color: isDark
                                ? const Color(0xFF8E9BBF)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  MonthNutritionPlan planForMonth(int m) {
    return monthlyNutritionPlans.firstWhere(
      (p) => p.month == m,
      orElse: () => monthlyNutritionPlans.first,
    );
  }
}


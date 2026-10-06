import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_logo.dart';
import '../../../../core/widgets/sb_private_badge.dart';
import '../../../pregnancy_tracker/data/pregnancy_dataset.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _askQuestion(String query) {
    if (query.trim().isEmpty) return;
    _questionController.clear();
    context.push('/chat', extra: query.trim());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final displayName = user.name.isNotEmpty ? user.name : 'Grâce';
    final age = DateFormatter.gestationalAge(user.lmp);
    final weeks = age?.weeks ?? DateFormatter.weeksOf(user.lmp);
    final safeWeek = weeks.clamp(1, 41).toInt();
    final currentWeekInfo = pregnancyDataset.firstWhere(
      (e) => e.week == safeWeek,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SbLogo(size: SbLogoSize.md),
                  GestureDetector(
                    onTap: () => context.push('/emergency'),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.pink,
                            size: 22,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.destructive,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Salutation & Semaine
              Text(
                'Bonjour, $displayName',
                style: AppTypography.displayL.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                age != null
                    ? '${age.weeks} SA + ${age.days} jours'
                    : 'Semaine de grossesse non calculée',
                style: AppTypography.bodyM.copyWith(
                  color: isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 14),
              // Badges
              Row(
                children: [
                  _StatusChip(
                    icon: Icons.download_done_rounded,
                    label: 'Hors connexion',
                    bg: isDark ? AppColors.darkCard : AppColors.accent,
                    fg: isDark
                        ? AppColors.darkPrimary
                        : AppColors.cardForeground,
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    icon: Icons.lock_outline_rounded,
                    label: 'Données chiffrées',
                    bg: isDark ? AppColors.darkCard : AppColors.successSoft,
                    fg: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SbCard(
                onTap: () => context.push('/app/tracking'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conseil de la semaine',
                      style: AppTypography.labelM.copyWith(
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentWeekInfo.tip,
                      style: AppTypography.bodyM.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Card Assistant SaveBabe
              SbCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkPrimary.withValues(alpha: 0.2)
                                : AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Assistant SaveBabe',
                          style: AppTypography.labelL.copyWith(
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.push('/voice'),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCard
                                  : AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.mic_rounded,
                              size: 18,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBorder.withValues(alpha: 0.4)
                            : const Color(0xFFF1F3F9),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                      ),
                      child: Text(
                        'Bonjour $displayName, comment puis-je vous aider aujourd\'hui ?',
                        style: AppTypography.bodyM.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _QuickChip(
                          text: 'Est-ce normal d\'avoir mal au dos ?',
                          onTap: () => _askQuestion(
                            'Est-ce normal d\'avoir mal au dos ?',
                          ),
                        ),
                        _QuickChip(
                          text: 'Quels aliments privilégier ?',
                          onTap: () =>
                              _askQuestion('Quels aliments privilégier ?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.border,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _questionController,
                              onSubmitted: _askQuestion,
                              decoration: InputDecoration(
                                hintText: 'Écrivez votre question…',
                                hintStyle: AppTypography.bodyS.copyWith(
                                  color: isDark
                                      ? AppColors.darkMutedForeground
                                      : AppColors.mutedForeground,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _askQuestion(_questionController.text),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Grille 3 actions principales
              Row(
                children: [
                  _ModuleCard(
                    icon: Icons.favorite_rounded,
                    label: 'Suivi de grossesse',
                    bg: isDark ? AppColors.darkCard : AppColors.secondary,
                    fg: isDark ? AppColors.darkPrimary : AppColors.primary,
                    onTap: () => context.push('/app/tracking'),
                  ),
                  const SizedBox(width: 10),
                  _ModuleCard(
                    icon: Icons.calendar_today_rounded,
                    label: 'Mes rendez-vous',
                    bg: AppColors.accent,
                    fg: AppColors.pink,
                    onTap: () => context.push('/app/appointments'),
                  ),
                  const SizedBox(width: 10),
                  _ModuleCard(
                    icon: Icons.child_care_rounded,
                    label: 'Suivi du bébé',
                    bg: isDark ? AppColors.darkCard : AppColors.successSoft,
                    fg: AppColors.success,
                    onTap: () => context.push(
                      user.baby != null ? '/app/baby' : '/app/baby/create',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Grille 2 cartes
              Row(
                children: [
                  Expanded(
                    child: SbCard(
                      onTap: () => context.push('/import'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Importer carnet',
                              style: AppTypography.labelS.copyWith(
                                color: isDark
                                    ? AppColors.darkCardForeground
                                    : AppColors.cardForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SbCard(
                      onTap: () => context.push('/invite'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_add_alt_1_rounded,
                            color: AppColors.pink,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Inviter un proche',
                              style: AppTypography.labelS.copyWith(
                                color: isDark
                                    ? AppColors.darkCardForeground
                                    : AppColors.cardForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Carte Urgence
              SbCard(
                onTap: () => context.push('/emergency'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.destructive,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'En cas d\'urgence',
                        style: AppTypography.labelM.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.mutedForeground,
                      size: 22,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const SbPrivateBadge(
                text: 'Vos données restent privées et protégées',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });

  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
          ),
          child: Column(
            children: [
              Icon(icon, color: fg, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Figtree',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appUserStateProvider.select((s) => s.theme));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final options = [
      {'key': 'light', 'title': 'Mode clair', 'icon': Icons.wb_sunny_outlined},
      {
        'key': 'dark',
        'title': 'Mode sombre',
        'icon': Icons.nightlight_round_outlined,
      },
      {
        'key': 'system',
        'title': 'Automatique (système)',
        'icon': Icons.brightness_auto_outlined,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Apparence',
                subtitle: 'Choisissez votre affichage préféré',
                onBack: () => context.pop(),
              ),
              ...options.map((opt) {
                final k = opt['key'] as String;
                final isSelected = currentTheme == k;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SbCard(
                    onTap: () {
                      ref
                          .read(appUserStateNotifierProvider.notifier)
                          .setTheme(k);
                    },
                    borderColor: isSelected
                        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                        : null,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          opt['icon'] as IconData,
                          size: 24,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            opt['title'] as String,
                            style: AppTypography.labelM.copyWith(
                              color: isDark
                                  ? AppColors.darkCardForeground
                                  : AppColors.cardForeground,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

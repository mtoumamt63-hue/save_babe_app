import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  static const Map<String, Map<String, List<String>>> _regionsData = {
    'Afrique de l\'Ouest': {
      'countries': [
        'Côte d\'Ivoire',
        'Sénégal',
        'Mali',
        'Burkina Faso',
        'Bénin',
        'Togo',
        'Niger',
        'Guinée',
        'Nigeria',
        'Ghana',
      ],
      'languages': [
        'Français',
        'Wolof',
        'Bambara',
        'Dioula',
        'Mooré',
        'Fon',
        'Haoussa',
        'Yoruba',
        'Peul',
      ],
    },
    'Afrique Centrale': {
      'countries': [
        'Cameroun',
        'Tchad',
        'Gabon',
        'Congo',
        'RD Congo',
        'Centrafrique',
      ],
      'languages': ['Français', 'Lingala', 'Sango', 'Ewondo', 'Arabe tchadien'],
    },
    'Afrique de l\'Est': {
      'countries': ['Kenya', 'Tanzanie', 'Éthiopie', 'Rwanda', 'Ouganda'],
      'languages': ['Swahili', 'Amharique', 'Kinyarwanda', 'English'],
    },
    'Afrique Australe': {
      'countries': ['Afrique du Sud', 'Mozambique', 'Zambie', 'Madagascar'],
      'languages': ['Zoulou', 'Xhosa', 'Português', 'Malagasy', 'English'],
    },
    'Afrique du Nord': {
      'countries': ['Maroc', 'Algérie', 'Tunisie', 'Égypte'],
      'languages': ['العربية', 'Tamazight', 'Français'],
    },
  };

  late String _selectedRegion;
  late String _selectedCountry;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserStateProvider);
    _selectedCountry = user.country.isNotEmpty
        ? user.country
        : 'Côte d\'Ivoire';
    _selectedLanguage = user.language.isNotEmpty ? user.language : 'Français';

    _selectedRegion = _regionsData.keys.firstWhere(
      (r) => _regionsData[r]!['countries']!.contains(_selectedCountry),
      orElse: () => 'Afrique de l\'Ouest',
    );
  }

  void _save() {
    ref
        .read(appUserStateNotifierProvider.notifier)
        .setLanguage(_selectedLanguage, _selectedCountry);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Langue : $_selectedLanguage')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final countries = _regionsData[_selectedRegion]!['countries']!;
    final languages = _regionsData[_selectedRegion]!['languages']!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Mes préférences linguistiques',
                onBack: () => context.pop(),
              ),
              Text(
                'Région',
                style: AppTypography.labelM.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _regionsData.keys.map((r) {
                  final isSelected = _selectedRegion == r;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRegion = r;
                        _selectedCountry = _regionsData[r]!['countries']!.first;
                        _selectedLanguage =
                            _regionsData[r]!['languages']!.first;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary)
                            : (isDark ? AppColors.darkCard : AppColors.card),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isSelected
                              ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary)
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.border),
                        ),
                      ),
                      child: Text(
                        r,
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.darkCardForeground
                                    : AppColors.cardForeground),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Choisir mon pays',
                style: AppTypography.labelM.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: countries.contains(_selectedCountry)
                        ? _selectedCountry
                        : countries.first,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                    items: countries.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(
                          c,
                          style: AppTypography.bodyM.copyWith(
                            color: isDark
                                ? AppColors.darkCardForeground
                                : AppColors.cardForeground,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCountry = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Langue de l\'application',
                style: AppTypography.labelM.copyWith(
                  color: isDark
                      ? AppColors.darkCardForeground
                      : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final isSelected = _selectedLanguage == lang;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedLanguage = lang),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? AppColors.darkPrimary.withValues(alpha: 0.2)
                                  : AppColors.secondary)
                            : (isDark ? AppColors.darkCard : AppColors.card),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary)
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.border),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        lang,
                        style: AppTypography.labelM.copyWith(
                          color: isSelected
                              ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary)
                              : (isDark
                                    ? AppColors.darkCardForeground
                                    : AppColors.cardForeground),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SbCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.download_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pack hors connexion « $_selectedLanguage » disponible',
                        style: AppTypography.bodyS.copyWith(
                          color: isDark
                              ? AppColors.darkCardForeground
                              : AppColors.cardForeground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SbButton(text: 'Enregistrer mes préférences', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

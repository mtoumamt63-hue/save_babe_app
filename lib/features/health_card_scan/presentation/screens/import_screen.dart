import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_private_badge.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source);
      if (file != null && mounted) {
        context.push('/ocr', extra: file.path);
      }
    } catch (_) {
      // Si la caméra n'\''est pas supportée ou annulée (ex. sur simulateur), simuler un chemin
      if (mounted) {
        context.push('/ocr', extra: 'simulated_scan');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Importer mon carnet',
                subtitle: 'Carnet de santé ou ordonnance',
                onBack: () => context.pop(),
              ),
              const SizedBox(height: 12),
              // Zone de capture photo stylisée
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkPrimary.withValues(alpha: 0.5)
                        : AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkPrimary.withValues(alpha: 0.2)
                            : AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 32,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Prendre une photo du carnet',
                      style: AppTypography.labelL.copyWith(
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Cadrez bien la page avec vos informations',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyS.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SbButton(
                      text: 'Prendre une photo',
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                    const SizedBox(height: 12),
                    SbButton(
                      text: 'Choisir depuis la galerie',
                      variant: SbButtonVariant.outline,
                      icon: Icon(
                        Icons.photo_library_outlined,
                        size: 18,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SbCard(
                backgroundColor: isDark
                    ? AppColors.darkCard
                    : AppColors.successSoft,
                borderColor: Colors.transparent,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Scan 100% hors connexion. Vos photos ne quittent jamais cet appareil.',
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
              const SbPrivateBadge(),
            ],
          ),
        ),
      ),
    );
  }
}

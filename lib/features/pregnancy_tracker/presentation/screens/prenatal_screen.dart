import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_card.dart';
import '../widgets/pregnancy_page.dart';
import '../widgets/pregnancy_illustration.dart';
import '../../domain/models/country_pack.dart';
import '../../domain/services/pregnancy_calculation_service.dart';

class PrenatalScreen extends ConsumerWidget {
  const PrenatalScreen({super.key});
  static const service = PregnancyCalculationService();

  CountryPack _pack(String country) {
    final c = country.toLowerCase();
    if (c.contains('rdc') || c.contains('congo') && c.contains('démocratique')) return rdcPack;
    if (['mali','bénin','benin','cameroun','cameroon','côte d’ivoire','côte d\'ivoire','congo'].any(c.contains)) return subSaharanMalariaGenericPack;
    return whoGenericPack;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStateProvider);
    final lmp = DateFormatter.parseLmp(user.lmp);
    if (lmp == null) return const Scaffold(body: Center(child: Text('Renseignez d’abord la date des dernières règles.')));
    final contacts = service.ancSchedule(lmp, _pack(user.country));
    final today = DateTime.now();
    return PregnancyPage(
      title: 'Consultations prénatales',
      subtitle: 'Les dates sont calculées à partir de votre DDR',
      child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PregnancyIllustration.topic(name: 'prenatal'),
            const SizedBox(height: 12),
            SbCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Comment prévoir les dates ?', style: AppTypography.labelL),
              const SizedBox(height: 8),
              Text('SaveBabe part du premier jour des dernières règles (DDR), calcule les semaines d’aménorrhée puis ajoute les semaines prévues pour chaque contact.', style: AppTypography.bodyM.copyWith(height: 1.4)),
              const SizedBox(height: 8),
              Text('Le calendrier de référence affiché ici est celui des 8 contacts : 12, 20, 26, 30, 34, 36, 38 et 40 SA. Les protocoles nationaux peuvent différer et doivent être validés localement.', style: AppTypography.bodyS),
            ])),
            const SizedBox(height: 16),
            ...contacts.map((c) {
              final isPast = c.date.isBefore(DateTime(today.year, today.month, today.day));
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SbCard(
                  borderColor: isPast ? null : AppColors.primary,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(isPast ? Icons.check_circle_rounded : Icons.event_available_rounded, color: isPast ? AppColors.success : AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.label, style: AppTypography.labelM),
                      const SizedBox(height: 3),
                      Text(DateFormatter.formatFR(c.date), style: AppTypography.bodyM.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(c.keyPoints.join(' • '), style: AppTypography.bodyS.copyWith(height: 1.35)),
                      if (c.iptpDose) ...[
                        const SizedBox(height: 6),
                        Text('Zone palustre : TPIg-SP selon le protocole local, à partir de 13 SA et avec au moins 1 mois entre les doses.', style: AppTypography.bodyS.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
                      ],
                    ])),
                  ]),
                ),
              );
            }),
            SbCard(child: Text('Si vous avez manqué une consultation, prenez contact avec votre structure de santé plutôt que d’attendre la prochaine date.', style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w700))),
          ]),
        ),
    );
  }
}

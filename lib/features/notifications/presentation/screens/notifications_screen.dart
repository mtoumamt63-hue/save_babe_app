import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/state/app_user_provider.dart';
import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../data/pregnancy_tips.dart';
import '../providers/notification_providers.dart';

enum NotificationFilter { all, tips, appointments, health }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final NotificationFilter category;
  final String? route;
  final String? actionLabel;
  final bool isUnread;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.category,
    this.route,
    this.actionLabel,
    this.isUnread = false,
  });
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  NotificationFilter _selectedFilter = NotificationFilter.all;
  final Set<String> _readIds = {};
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userState = ref.watch(appUserStateProvider);

    final notifications = _buildNotifications(userState);
    final filtered = _selectedFilter == NotificationFilter.all
        ? notifications
        : notifications.where((n) => n.category == _selectedFilter).toList();

    final unreadCount = notifications.where((n) => !_readIds.contains(n.id)).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── En-tête ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.pLg,
                  AppDimensions.pLg,
                  AppDimensions.pLg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SbHeader(
                      title: 'Notifications',
                      subtitle: unreadCount > 0
                          ? '$unreadCount nouveau(x) rappel(s) aujourd\'hui'
                          : 'Tous vos rappels et conseils sont à jour',
                      onBack: () => context.pop(),
                      trailing: unreadCount > 0
                          ? TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  for (final n in notifications) {
                                    _readIds.add(n.id);
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Toutes les notifications marquées comme lues'),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.done_all_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              label: Text(
                                'Tout lire',
                                style: AppTypography.labelS.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
                    ),

                    // ── Statut des rappels & test ───────────────
                    _buildStatusBanner(context, isDark, userState),
                    const SizedBox(height: AppDimensions.pMd),

                    // ── Filtres ─────────────────────────────────
                    _buildFilterChips(isDark),
                    const SizedBox(height: AppDimensions.pMd),
                  ],
                ),
              ),
            ),

            // ── Liste des notifications ─────────────────────────
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(isDark),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pLg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = filtered[index];
                      final isRead = _readIds.contains(item.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildNotificationCard(context, item, isRead, isDark),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.p2xl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, bool isDark, AppUserState userState) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rappels automatiques actifs',
                  style: AppTypography.bodyM.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.foregroundDark : AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Conseil quotidien à 08:00 • Rappels de RDV prénataux',
                  style: AppTypography.labelS.copyWith(
                    color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _notificationsEnabled,
            activeTrackColor: AppColors.primary,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              if (val) {
                ref.read(notificationSchedulerProvider).scheduleAll(userState);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rappels et conseils réactivés'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ref.read(notificationServiceProvider).cancelAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rappels mis en pause'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = [
      (NotificationFilter.all, 'Toutes'),
      (NotificationFilter.tips, '💛 Conseils'),
      (NotificationFilter.appointments, '📅 Rendez-vous'),
      (NotificationFilter.health, '🌸 Santé & Soins'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f.$2),
              selected: isSelected,
              showCheckmark: false,
              labelStyle: AppTypography.labelS.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.foregroundDark : AppColors.foreground),
              ),
              backgroundColor: isDark ? AppColors.cardDark : AppColors.card,
              selectedColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.borderDark : AppColors.border),
                ),
              ),
              onSelected: (_) {
                setState(() => _selectedFilter = f.$1);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    bool isRead,
    bool isDark,
  ) {
    return SbCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: isRead
          ? (isDark ? AppColors.cardDark.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.7))
          : (isDark ? AppColors.cardDark : Colors.white),
      borderColor: isRead
          ? (isDark ? AppColors.borderDark : AppColors.border.withValues(alpha: 0.5))
          : item.color.withValues(alpha: 0.4),
      onTap: () {
        setState(() => _readIds.add(item.id));
        if (item.route != null) {
          context.push(item.route!);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône stylisée
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(width: 14),

              // Contenu principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTypography.bodyM.copyWith(
                              fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                              color: isDark ? AppColors.foregroundDark : AppColors.foreground,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: item.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: AppTypography.bodyS.copyWith(
                        color: isDark
                            ? AppColors.mutedForegroundDark
                            : AppColors.mutedForeground,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Horodatage et Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 13,
                              color: isDark
                                  ? AppColors.mutedForegroundDark
                                  : AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.timeAgo,
                              style: AppTypography.bodyXs.copyWith(
                                color: isDark
                                    ? AppColors.mutedForegroundDark
                                    : AppColors.mutedForeground,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        if (item.actionLabel != null && item.route != null)
                          GestureDetector(
                            onTap: () {
                              setState(() => _readIds.add(item.id));
                              context.push(item.route!);
                            },
                            child: Row(
                              children: [
                                Text(
                                  item.actionLabel!,
                                  style: AppTypography.labelS.copyWith(
                                    color: item.color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: item.color,
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
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.p2xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Aucune notification dans cette catégorie',
              textAlign: TextAlign.center,
              style: AppTypography.displayS.copyWith(
                color: isDark ? AppColors.foregroundDark : AppColors.foreground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vos rappels de rendez-vous et vos conseils de grossesse apparaîtront automatiquement ici.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyM.copyWith(
                color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<NotificationItem> _buildNotifications(AppUserState userState) {
    final list = <NotificationItem>[];

    // 1. Calcul semaine de grossesse
    int currentWeek = 1;
    if (userState.lmp.isNotEmpty) {
      try {
        final lmp = DateTime.parse(userState.lmp);
        currentWeek = (DateTime.now().difference(lmp).inDays ~/ 7) + 1;
      } catch (_) {}
    }
    if (currentWeek < 1) currentWeek = 1;
    if (currentWeek > 42) currentWeek = 40;

    // Conseil du jour
    final tip = getTipForWeek(currentWeek);
    if (tip != null) {
      list.add(
        NotificationItem(
          id: 'tip_week_$currentWeek',
          title: '💛 Conseil du jour — Semaine $currentWeek',
          message: tip.tip,
          timeAgo: 'Aujourd\'hui à 08:00',
          icon: Icons.lightbulb_outline_rounded,
          color: const Color(0xFFE59819),
          backgroundColor: const Color(0xFFFFF7E6),
          category: NotificationFilter.tips,
          actionLabel: 'Explorer la semaine',
          route: '/pregnancy-weeks?week=$currentWeek',
        ),
      );
    }

    // 2. Rappels de rendez-vous réels
    final now = DateTime.now();
    for (final appt in userState.appointments) {
      if (appt.date.isEmpty) continue;
      try {
        final apptDate = DateTime.parse(appt.date);
        final diffDays = apptDate.difference(now).inDays;

        if (diffDays >= 0) {
          String statusText;
          if (diffDays == 0) {
            statusText = 'Aujourd\'hui';
          } else if (diffDays == 1) {
            statusText = 'Demain';
          } else {
            statusText = 'Dans $diffDays jours';
          }

          list.add(
            NotificationItem(
              id: 'appt_${appt.id}',
              title: '📅 Rendez-vous : ${appt.title}',
              message:
                  '$statusText à ${appt.time.isNotEmpty ? appt.time : "09:00"}${appt.place.isNotEmpty ? " • ${appt.place}" : ""}. N\'oubliez pas votre carnet de santé.',
              timeAgo: 'Rappel programmé',
              icon: Icons.calendar_month_rounded,
              color: AppColors.primary,
              backgroundColor: AppColors.secondary,
              category: NotificationFilter.appointments,
              actionLabel: 'Voir agenda',
              route: '/app/appointments',
            ),
          );
        }
      } catch (_) {}
    }

    // Si pas de RDV, rappel pour planifier
    if (userState.appointments.isEmpty) {
      list.add(
        const NotificationItem(
          id: 'no_appt_reminder',
          title: '📅 Consultation prénatale (CPN)',
          message:
              'Avez-vous planifié votre prochaine visite médicale ? Un suivi régulier protège votre santé et celle de bébé.',
          timeAgo: 'Cette semaine',
          icon: Icons.event_note_rounded,
          color: AppColors.primary,
          backgroundColor: AppColors.secondary,
          category: NotificationFilter.appointments,
          actionLabel: 'Prendre rendez-vous',
          route: '/app/appointments',
        ),
      );
    }

    // 3. Décompte accouchement / DPA
    if (userState.lmp.isNotEmpty) {
      try {
        final lmpDate = DateTime.parse(userState.lmp);
        final dpa = lmpDate.add(const Duration(days: 280));
        final weeksLeft = dpa.difference(now).inDays ~/ 7;

        if (weeksLeft > 0 && weeksLeft <= 40) {
          list.add(
            NotificationItem(
              id: 'dpa_countdown',
              title: '🤱 Votre bébé arrive bientôt !',
              message:
                  'Plus que $weeksLeft semaine(s) avant votre date prévue d\'accouchement. Avez-vous préparé votre valise de maternité ?',
              timeAgo: 'Suivi de terme',
              icon: Icons.child_friendly_rounded,
              color: AppColors.pink,
              backgroundColor: AppColors.accent,
              category: NotificationFilter.health,
              actionLabel: 'Guide accouchement',
              route: '/childbirth',
            ),
          );
        }
      } catch (_) {}
    }

    // 4. Soins & Nutrition quotidiens
    list.add(
      const NotificationItem(
        id: 'daily_hydration',
        title: '💧 Hydratation & Vitalité',
        message:
            'Pensez à boire votre bouteille d\'eau aujourd\'hui pour soutenir la circulation placentaire et le liquide amniotique.',
        timeAgo: 'Rappel quotidien',
        icon: Icons.water_drop_outlined,
        color: Color(0xFF0284C7),
        backgroundColor: Color(0xFFE0F2FE),
        category: NotificationFilter.health,
        actionLabel: 'Guide nutrition',
        route: '/nutrition-full',
      ),
    );

    // 5. Vigilance signes de danger
    list.add(
      const NotificationItem(
        id: 'danger_signs_alert',
        title: '⚠️ Signes à surveiller',
        message:
            'Saignements, maux de tête intenses, fièvre ou vision floue ? N\'attendez pas : consultez un centre de santé sans tarder.',
        timeAgo: 'Sécurité SaveBabe',
        icon: Icons.health_and_safety_rounded,
        color: AppColors.destructive,
        backgroundColor: Color(0xFFFEE2E2),
        category: NotificationFilter.health,
        actionLabel: 'Voir les signes',
        route: '/danger-signs',
      ),
    );

    // 6. Suivi bébé si présent
    if (userState.baby != null) {
      list.add(
        NotificationItem(
          id: 'baby_log_reminder',
          title: '👶 Suivi de ${userState.baby!.name}',
          message:
              'Pensez à noter les tétées, couches et siestes de votre bout de chou pour suivre sa croissance sereinement.',
          timeAgo: 'Suivi postnatal',
          icon: Icons.baby_changing_station_rounded,
          color: AppColors.success,
          backgroundColor: AppColors.successSoft,
          category: NotificationFilter.health,
          actionLabel: 'Ouvrir suivi bébé',
          route: '/app/baby',
        ),
      );
    }

    return list;
  }
}

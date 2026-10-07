import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
import '../../domain/notification_scheduler.dart';

/// Fournisseur du service de notification natif
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationServiceImpl();
});

/// Fournisseur du planificateur automatique des rappels & conseils
final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return NotificationScheduler(service);
});

import 'package:flutter/material.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/state/app_user_state.dart';
import '../data/pregnancy_tips.dart';

class NotificationScheduler {
  final NotificationService _service;

  NotificationScheduler(this._service);

  Future<void> scheduleAll(AppUserState state) async {
    await _service.cancelAll();
    if (!state.consent.health) return;

    await _scheduleDailyTip(state);
    await _scheduleAppointmentReminders(state.appointments);
    await _scheduleDpaReminder(state.lmp);

    // Suivi bébé postnatal si un bébé est enregistré
    if (state.baby != null) {
      await _scheduleBabyReminders(state.baby!);
    }
  }

  Future<void> _scheduleDailyTip(AppUserState state) async {
    if (state.lmp.trim().isEmpty) return;
    try {
      final DateTime lmpDate = DateTime.parse(state.lmp);
      final int currentWeek =
          (DateTime.now().difference(lmpDate).inDays ~/ 7) + 1;

      final PregnancyTip? tip = getTipForWeek(currentWeek);
      if (tip == null) return;

      await _service.scheduleDaily(
        id: 1,
        title: '💛 Conseil du jour — Semaine $currentWeek',
        body: tip.tip,
        time: const TimeOfDay(hour: 8, minute: 0),
      );
    } catch (_) {}
  }

  Future<void> _scheduleAppointmentReminders(
    List<Appointment> appointments,
  ) async {
    for (final appointment in appointments) {
      if (appointment.date.trim().isEmpty) continue;
      try {
        final DateTime apptDate = DateTime.parse(appointment.date);
        if (apptDate.isBefore(DateTime.now())) continue;

        // Ajout du Jour J (0) en plus de J-1, J-3, J-7
        final Map<int, String> reminders = {
          7: 'Dans 7 jours',
          3: 'Dans 3 jours',
          1: 'Demain',
          0: 'Aujourd\'hui',
        };

        for (final entry in reminders.entries) {
          final DateTime reminderDate = apptDate.subtract(
            Duration(days: entry.key),
          );

          if (reminderDate.isAfter(DateTime.now()) || entry.key == 0) {
            final int id = appointment.id.hashCode + entry.key;

            await _service.scheduleOnDate(
              id: id,
              title: '📅 Rappel rendez-vous — ${entry.value}',
              body: entry.key == 0
                  ? 'Vous avez un rendez-vous aujourd\'hui : "${appointment.title}".'
                  : 'Votre rendez-vous "${appointment.title}" approche.',
              dateTime: DateTime(
                reminderDate.year,
                reminderDate.month,
                reminderDate.day,
                8,
                0,
              ),
            );
          }
        }
      } catch (_) {}
    }
  }

  Future<void> _scheduleDpaReminder(String lmp) async {
    if (lmp.trim().isEmpty) return;
    try {
      final DateTime lmpDate = DateTime.parse(lmp);
      final DateTime dpa = lmpDate.add(const Duration(days: 280));
      final int weeksLeft = dpa.difference(DateTime.now()).inDays ~/ 7;

      if (weeksLeft <= 0) return;

      await _service.scheduleOnDate(
        id: 999,
        title: '🤱 Votre bébé arrive bientôt !',
        body:
            'Plus que $weeksLeft semaine(s) avant votre date d\'accouchement estimée.',
        dateTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          9,
          0,
        ),
      );
    } catch (_) {}
  }

  // Rappels de santé postnatal pour le bébé
  Future<void> _scheduleBabyReminders(Baby baby) async {
    await _service.scheduleDaily(
      id: 2000,
      title: '👶 Suivi de bébé',
      body:
          'Pensez à noter l\'alimentation et les soins de ${baby.name} aujourd\'hui.',
      time: const TimeOfDay(hour: 10, minute: 0),
    );
  }
}

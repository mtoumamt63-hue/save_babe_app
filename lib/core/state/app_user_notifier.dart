import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_keys.dart';
import '../services/local_storage_service.dart';
import 'app_user_state.dart';

class AppUserNotifier extends StateNotifier<AppUserState> {
  AppUserNotifier(this._storageService, this._uid)
    : super(_loadInitialState(_storageService, _uid));

  final LocalStorageService _storageService;

  /// UID Firebase de l'utilisateur — chaque compte a sa propre clé Hive
  final String _uid;

  /// Clé de stockage unique par utilisateur
  static String _key(String uid) => 'savebabe-state-$uid';

  /// Charge l'état depuis Hive de manière synchrone au démarrage
  static AppUserState _loadInitialState(
    LocalStorageService storageService,
    String uid,
  ) {
    try {
      final raw = storageService.get<String>(AppKeys.userStateBox, _key(uid));
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw) as Map<dynamic, dynamic>;
        return AppUserState.fromJson(map);
      }
    } catch (_) {
      // Fallback sur l'état initial en cas d'erreur
    }
    return const AppUserState();
  }

  /// Persiste l'état courant dans Hive sous la clé propre à l'UID
  Future<void> _persist() async {
    try {
      final raw = jsonEncode(state.toJson());
      await _storageService.save(AppKeys.userStateBox, _key(_uid), raw);
    } catch (_) {}
  }

  Future<void> update(
    AppUserState Function(AppUserState current) updater,
  ) async {
    state = updater(state);
    await _persist();
  }

  Future<void> setOnboardingData({
    required String name,
    required String contact,
    required String lmp,
    required String firstPregnancy,
    required String center,
    required ConsentSettings consent,
  }) async {
    state = state.copyWith(
      name: name,
      contact: contact,
      lmp: lmp,
      firstPregnancy: firstPregnancy,
      center: center,
      consent: consent,
      onboarded: true,
    );
    await _persist();
  }

  Future<void> addAppointment(Appointment appt) async {
    final list = [...state.appointments, appt];
    state = state.copyWith(appointments: list);
    await _persist();
  }

  Future<void> removeAppointment(String id) async {
    final list = state.appointments.where((a) => a.id != id).toList();
    state = state.copyWith(appointments: list);
    await _persist();
  }

  Future<void> addMeasure(Measure measure) async {
    final list = [measure, ...state.measures];
    state = state.copyWith(measures: list);
    await _persist();
  }

  Future<void> setPregnancyProfile({
    required double prePregnancyWeightKg,
    required double heightM,
  }) async {
    state = state.copyWith(
      prePregnancyWeightKg: prePregnancyWeightKg,
      heightM: heightM,
    );
    await _persist();
  }

  Future<void> setHealthRecords(List<HealthRecord> records) async {
    state = state.copyWith(record: records);
    await _persist();
  }

  Future<void> addHealthRecord(HealthRecord record) async {
    final list = [...state.record, record];
    state = state.copyWith(record: list);
    await _persist();
  }

  Future<void> setPartner(Partner? partner) async {
    state = state.copyWith(partner: partner, clearPartner: partner == null);
    await _persist();
  }

  Future<void> setBaby(Baby? baby) async {
    state = state.copyWith(baby: baby, clearBaby: baby == null);
    await _persist();
  }

  Future<void> addBabyLog(BabyLogEntry entry) async {
    final list = [entry, ...state.babyLog];
    state = state.copyWith(babyLog: list);
    await _persist();
  }

  Future<void> setAiPrivacy(AiPrivacySettings settings) async {
    state = state.copyWith(aiPrivacy: settings);
    await _persist();
  }

  Future<void> setTheme(String theme) async {
    state = state.copyWith(theme: theme);
    await _persist();
  }

  Future<void> setLanguage(String language, String country) async {
    state = state.copyWith(language: language, country: country);
    await _persist();
  }

  /// Efface les données de CET utilisateur de Hive et remet l'état à zéro
  Future<void> reset() async {
    try {
      await _storageService.delete(AppKeys.userStateBox, _key(_uid));
    } catch (_) {}
    state = const AppUserState();
  }
}

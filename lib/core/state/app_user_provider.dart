import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/network_info.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';
import '../services/ocr_service.dart';
import 'app_user_notifier.dart';
import 'app_user_state.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageServiceImpl();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(Connectivity());
});

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioServiceImpl();
});

final ocrServiceProvider = Provider<OcrService>((ref) {
  return OcrServiceImpl();
});

final appUserStateNotifierProvider =
    StateNotifierProvider<AppUserNotifier, AppUserState>((ref) {
      final storage = ref.watch(localStorageServiceProvider);
      final user = ref.watch(firebaseUserProvider).valueOrNull;
      final uid = user?.uid ?? 'guest';
      return AppUserNotifier(storage, uid);
    });

final appUserStateProvider = Provider<AppUserState>((ref) {
  return ref.watch(appUserStateNotifierProvider);
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final theme = ref.watch(appUserStateProvider.select((s) => s.theme));
  switch (theme) {
    case 'dark':
      return ThemeMode.dark;
    case 'system':
      return ThemeMode.system;
    case 'light':
    default:
      return ThemeMode.light;
  }
});

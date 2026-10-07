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

/// Convertit le nom de langue stocké en Locale Flutter.
/// Langues africaines sans support Flutter natif → fallback sur fr ou en.
final localeProvider = Provider<Locale>((ref) {
  final language = ref.watch(appUserStateProvider.select((s) => s.language));
  const Map<String, Locale> langToLocale = {
    'Français': Locale('fr', 'FR'),
    'English': Locale('en', 'US'),
    'Arabe standard': Locale('ar', 'MA'),
    'Arabe tchadien': Locale('ar', 'TD'),
    'Kiswahili': Locale('sw', 'TZ'),
    'Amharique': Locale('am', 'ET'),
    'Oromo': Locale('om', 'ET'),
    'Tigrinya': Locale('ti', 'ER'),
    'Somali': Locale('so', 'SO'),
    'Zoulou': Locale('zu', 'ZA'),
    'Xhosa': Locale('xh', 'ZA'),
    'Kinyarwanda': Locale('rw', 'RW'),
    'Yoruba': Locale('yo', 'NG'),
    'Haoussa': Locale('ha', 'NE'),
    'Igbo': Locale('ig', 'NG'),
    'Twi / Akan': Locale('ak', 'GH'),
    'Malagasy': Locale('mg', 'MG'),
    // Langues sans locale Flutter officielle → fallback français
    'Wolof': Locale('fr', 'SN'),
    'Bambara': Locale('fr', 'ML'),
    'Dioula': Locale('fr', 'CI'),
    'Baoulé': Locale('fr', 'CI'),
    'Mooré': Locale('fr', 'BF'),
    'Fon': Locale('fr', 'BJ'),
    'Éwé / Mina': Locale('fr', 'TG'),
    'Peul / Fulfulde': Locale('fr', 'GN'),
    'Lingala': Locale('fr', 'CD'),
    'Kikongo': Locale('fr', 'CG'),
    'Tshiluba': Locale('fr', 'CD'),
    'Sango': Locale('fr', 'CF'),
    'Ewondo / Beti': Locale('fr', 'CM'),
    'Douala': Locale('fr', 'CM'),
    'Tamazight': Locale('fr', 'MA'),
    'Kirundi': Locale('rn', 'BI'),
    'Luganda': Locale('lg', 'UG'),
    'Shona': Locale('sn', 'ZW'),
    'Chichewa': Locale('ny', 'MW'),
    'Português (África)': Locale('pt', 'MZ'),
  };
  return langToLocale[language] ?? const Locale('fr', 'FR');
});

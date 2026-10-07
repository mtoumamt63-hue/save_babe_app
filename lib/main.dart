import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/notification_service.dart';
import 'core/state/app_user_provider.dart';
import 'core/state/app_user_state.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/presentation/providers/notification_providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialisation du stockage local Hive
  final storageService = LocalStorageServiceImpl();
  await storageService.init();

  // Initialisation du service de notification
  final notificationService = NotificationServiceImpl();
  await notificationService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(storageService),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const SaveBabeApp(),
    ),
  );
}

class SaveBabeApp extends ConsumerStatefulWidget {
  const SaveBabeApp({super.key});

  @override
  ConsumerState<SaveBabeApp> createState() => _SaveBabeAppState();
}

class _SaveBabeAppState extends ConsumerState<SaveBabeApp> {
  @override
  void initState() {
    super.initState();
    // Planification initiale des rappels et conseils dès l'ouverture de l'application
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(appUserStateProvider);
      ref.read(notificationSchedulerProvider).scheduleAll(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Écoute automatique des changements (ajout de RDV, mise à jour du profil, etc.)
    ref.listen<AppUserState>(appUserStateProvider, (previous, next) {
      if (previous != next) {
        ref.read(notificationSchedulerProvider).scheduleAll(next);
      }
    });

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'SaveBabe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('fr', 'SN'), // Wolof / Bambara / Dioula / etc.
        Locale('fr', 'ML'),
        Locale('fr', 'CI'),
        Locale('fr', 'BF'),
        Locale('fr', 'BJ'),
        Locale('fr', 'TG'),
        Locale('fr', 'GN'),
        Locale('fr', 'CD'),
        Locale('fr', 'CG'),
        Locale('fr', 'CF'),
        Locale('fr', 'CM'),
        Locale('fr', 'MA'),
        Locale('en', 'US'),
        Locale('en', 'NG'),
        Locale('en', 'GH'),
        Locale('ar', 'MA'),
        Locale('ar', 'TD'),
        Locale('ar', 'SA'),
        Locale('sw', 'TZ'),
        Locale('am', 'ET'),
        Locale('om', 'ET'),
        Locale('ti', 'ER'),
        Locale('so', 'SO'),
        Locale('rw', 'RW'),
        Locale('rn', 'BI'),
        Locale('lg', 'UG'),
        Locale('mg', 'MG'),
        Locale('zu', 'ZA'),
        Locale('xh', 'ZA'),
        Locale('sn', 'ZW'),
        Locale('ny', 'MW'),
        Locale('pt', 'MZ'),
        Locale('yo', 'NG'),
        Locale('ha', 'NE'),
        Locale('ig', 'NG'),
        Locale('ak', 'GH'),
      ],
    );
  }
}


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

    return MaterialApp.router(
      title: 'SaveBabe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      locale: const Locale('fr', 'FR'),
    );
  }
}


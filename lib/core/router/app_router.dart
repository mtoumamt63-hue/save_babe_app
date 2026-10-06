import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_assistant/presentation/screens/ai_privacy_screen.dart';
import '../../features/ai_assistant/presentation/screens/chat_screen.dart';
import '../../features/ai_assistant/presentation/screens/voice_screen.dart';
import '../../features/appointments/presentation/screens/appointments_screen.dart';
import '../../features/baby_tracker/presentation/screens/baby_create_screen.dart';
import '../../features/baby_tracker/presentation/screens/baby_screen.dart';
import '../../features/emergency/presentation/screens/emergency_screen.dart';
import '../../features/health_card_scan/presentation/screens/confirm_screen.dart';
import '../../features/health_card_scan/presentation/screens/import_screen.dart';
import '../../features/health_card_scan/presentation/screens/ocr_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/consent_screen.dart';
import '../../features/onboarding/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/pregnancy_screen.dart';
import '../../features/onboarding/presentation/screens/ready_screen.dart';
import '../../features/onboarding/presentation/screens/signup_screen.dart';
import '../../features/onboarding/presentation/screens/sync_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/childbirth_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/danger_signs_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/metrics_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/newborn_guide_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/nutrition_full_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/postpartum_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/prenatal_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/weekly_pregnancy_screen.dart';
import '../../features/pregnancy_tracker/presentation/screens/tracking_screen.dart';
import '../../features/profile/presentation/screens/language_screen.dart';
import '../../features/profile/presentation/screens/offline_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/theme_screen.dart';
import '../../features/trusted_person/presentation/screens/invite_screen.dart';
import '../services/auth_service.dart';
import '../state/app_user_provider.dart';
import 'scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(
      firebaseUserProvider,
      (_, __) => notifyListeners(),
    );
    _ref.listen<bool>(
      appUserStateNotifierProvider.select((s) => s.onboarded),
      (_, __) => notifyListeners(),
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);
  final initialOnboarded = ref.read(appUserStateNotifierProvider).onboarded;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: notifier,
    initialLocation: initialOnboarded ? '/app/home' : '/onboarding/welcome',
    redirect: (context, state) {
      final userState = ref.read(appUserStateNotifierProvider);
      final isOnboarding = state.matchedLocation.startsWith('/onboarding');
      final isRoot = state.matchedLocation == '/';

      if (!userState.onboarded && !isOnboarding) {
        return '/onboarding/welcome';
      }

      if (userState.onboarded &&
          (isRoot ||
              state.matchedLocation == '/onboarding/welcome' ||
              state.matchedLocation == '/onboarding/login' ||
              state.matchedLocation == '/onboarding/signup')) {
        return '/app/home';
      }

      return null;
    },
    routes: [
      // ── Routes Onboarding ─────────────────────────────────────
      GoRoute(
        path: '/onboarding/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding/pregnancy',
        builder: (context, state) => const PregnancyScreen(),
      ),
      GoRoute(
        path: '/onboarding/consent',
        builder: (context, state) => const ConsentScreen(),
      ),
      GoRoute(
        path: '/onboarding/sync',
        builder: (context, state) => const SyncScreen(),
      ),
      GoRoute(
        path: '/onboarding/ready',
        builder: (context, state) => const ReadyScreen(),
      ),

      // ── Shell principal avec Barre de navigation inférieure ───
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/app/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/app/tracking',
            builder: (context, state) => const TrackingScreen(),
            routes: [
              GoRoute(
                path: 'metrics',
                builder: (context, state) => const MetricsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/app/appointments',
            builder: (context, state) => const AppointmentsScreen(),
          ),
          GoRoute(
            path: '/app/baby',
            builder: (context, state) => const BabyScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const BabyCreateScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/app/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'offline',
                builder: (context, state) => const OfflineScreen(),
              ),
              GoRoute(
                path: 'language',
                builder: (context, state) => const LanguageScreen(),
              ),
              GoRoute(
                path: 'theme',
                builder: (context, state) => const ThemeScreen(),
              ),
              GoRoute(
                path: 'ai-privacy',
                builder: (context, state) => const AiPrivacyScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Routes Modales / Plein écran (hors navigation shell) ──
      GoRoute(
        path: '/chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ChatScreen(
          initialQuery: state.extra as String?,
        ),
      ),
      GoRoute(
        path: '/voice',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VoiceScreen(),
      ),
      GoRoute(
        path: '/import',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ImportScreen(),
      ),
      GoRoute(
        path: '/ocr',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => OcrScreen(
          imagePath: state.extra as String?,
        ),
      ),
      GoRoute(
        path: '/confirm',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ConfirmScreen(),
      ),
      GoRoute(
        path: '/emergency',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EmergencyScreen(),
      ),
      GoRoute(
        path: '/danger-signs',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DangerSignsScreen(),
      ),
      GoRoute(
        path: '/pregnancy-weeks',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final week = int.tryParse(state.uri.queryParameters['week'] ?? '');
          return WeeklyPregnancyScreen(initialWeek: week);
        },
      ),
      GoRoute(
        path: '/prenatal',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrenatalScreen(),
      ),
      GoRoute(
        path: '/nutrition-full',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NutritionFullScreen(),
      ),
      GoRoute(
        path: '/childbirth',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChildbirthScreen(),
      ),
      GoRoute(
        path: '/postpartum',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PostpartumScreen(),
      ),
      GoRoute(
        path: '/newborn-guide',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NewbornGuideScreen(),
      ),
      GoRoute(
        path: '/metrics',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MetricsScreen(),
      ),
      GoRoute(
        path: '/nutrition',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final trimester = int.tryParse(state.uri.queryParameters['trimester'] ?? '');
          return NutritionFullScreen(trimester: trimester);
        },
      ),
      GoRoute(
        path: '/invite',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InviteScreen(),
      ),
    ],
  );
});

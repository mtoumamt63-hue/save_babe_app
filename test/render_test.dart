import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_babe/core/services/local_storage_service.dart';
import 'package:save_babe/core/state/app_user_provider.dart';
import 'package:save_babe/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:save_babe/features/pregnancy_tracker/presentation/screens/metrics_screen.dart';

class MockStorage implements LocalStorageService {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  testWidgets('NotificationsScreen pumps without crashing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageServiceProvider.overrideWithValue(MockStorage()),
        ],
        child: const MaterialApp(
          home: NotificationsScreen(),
        ),
      ),
    );
    await tester.pump();
  });

  testWidgets('MetricsScreen pumps without crashing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageServiceProvider.overrideWithValue(MockStorage()),
        ],
        child: const MaterialApp(
          home: MetricsScreen(),
        ),
      ),
    );
    await tester.pump();
  });
}

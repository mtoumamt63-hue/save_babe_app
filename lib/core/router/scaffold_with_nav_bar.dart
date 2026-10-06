import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/app_user_provider.dart';
import '../widgets/sb_tab_bar.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.child});

  final Widget child;

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/app/home')) {
      return 0;
    }
    if (location.startsWith('/app/tracking')) {
      return 1;
    }
    if (location.startsWith('/app/appointments')) {
      return 2;
    }
    if (location.startsWith('/app/baby')) {
      return 3;
    }
    if (location.startsWith('/app/profile')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, WidgetRef ref) {
    switch (index) {
      case 0:
        context.go('/app/home');
        break;
      case 1:
        context.go('/app/tracking');
        break;
      case 2:
        context.go('/app/appointments');
        break;
      case 3:
        final hasBaby = ref.read(appUserStateProvider).baby != null;
        context.go(hasBaby ? '/app/baby' : '/app/baby/create');
        break;
      case 4:
        context.go('/app/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: SbTabBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context, ref),
      ),
    );
  }
}

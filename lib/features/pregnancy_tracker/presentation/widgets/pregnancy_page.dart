import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/sb_header.dart';

class PregnancyPage extends StatelessWidget {
  const PregnancyPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: SbHeader(
                title: title,
                subtitle: subtitle,
                onBack: () => context.pop(),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

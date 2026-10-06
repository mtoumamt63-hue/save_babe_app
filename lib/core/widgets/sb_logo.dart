import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum SbLogoSize { md, lg }

class SbLogo extends StatelessWidget {
  const SbLogo({super.key, this.size = SbLogoSize.md});

  final SbLogoSize size;

  @override
  Widget build(BuildContext context) {
    final isLg = size == SbLogoSize.lg;
    final fontSize = isLg ? 36.0 : 24.0;
    final badgeSize = isLg ? 46.0 : 36.0;
    final heartSize = isLg ? 22.0 : 16.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: badgeSize,
          height: badgeSize,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '♥',
            style: TextStyle(
              color: AppColors.pink,
              fontSize: heartSize,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(
                text: 'Save',
                style: TextStyle(color: AppColors.primary),
              ),
              TextSpan(
                text: 'Babe',
                style: TextStyle(color: AppColors.pink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

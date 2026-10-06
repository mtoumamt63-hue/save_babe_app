import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class SbCard extends StatelessWidget {
  const SbCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg =
        backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.card);
    final cardBorder =
        borderColor ?? (isDark ? AppColors.darkBorder : AppColors.border);
    final radius =
        borderRadius ?? BorderRadius.circular(AppDimensions.radius2xl);

    final Widget content = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.pLg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: radius,
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(borderRadius: radius, onTap: onTap, child: content),
      );
    }

    return content;
  }
}

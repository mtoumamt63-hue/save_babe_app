import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

enum SbButtonVariant { primary, outline, ghost, danger }

class SbButton extends StatefulWidget {
  const SbButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = SbButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final SbButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool fullWidth;

  @override
  State<SbButton> createState() => _SbButtonState();
}

class _SbButtonState extends State<SbButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Color backgroundColor;
    Color textColor;
    Border? border;
    List<BoxShadow>? shadows;

    switch (widget.variant) {
      case SbButtonVariant.primary:
        backgroundColor = isDark ? AppColors.darkPrimary : AppColors.primary;
        textColor = AppColors.primaryForeground;
        shadows = isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null;
        break;
      case SbButtonVariant.outline:
        backgroundColor = isDark ? AppColors.darkCard : AppColors.card;
        textColor = isDark ? AppColors.darkPrimary : AppColors.primary;
        border = Border.all(
          color: isDark ? AppColors.darkPrimary : AppColors.primary,
          width: 2,
        );
        break;
      case SbButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = isDark ? AppColors.darkPrimary : AppColors.primary;
        break;
      case SbButtonVariant.danger:
        backgroundColor = AppColors.destructive;
        textColor = Colors.white;
        shadows = isEnabled
            ? [
                BoxShadow(
                  color: AppColors.destructive.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null;
        break;
    }

    final label = Text(
      widget.text,
      textAlign: TextAlign.center,
      maxLines: 2,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.button.copyWith(
        color: textColor,
        decoration: widget.variant == SbButtonVariant.ghost
            ? TextDecoration.underline
            : TextDecoration.none,
      ),
    );
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillWidth = widget.fullWidth && constraints.hasBoundedWidth;
          final content = Row(
            mainAxisSize: fillWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                ),
                const SizedBox(width: 10),
              ] else if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              if (fillWidth) Expanded(child: label) else label,
            ],
          );

          return GestureDetector(
            onTapDown: isEnabled ? _onTapDown : null,
            onTapUp: isEnabled ? _onTapUp : null,
            onTapCancel: isEnabled ? _onTapCancel : null,
            onTap: isEnabled ? widget.onPressed : null,
            behavior: HitTestBehavior.opaque,
            child: Opacity(
              opacity: isEnabled ? 1.0 : 0.5,
              child: Container(
                width: fillWidth ? constraints.maxWidth : null,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: AppDimensions.pLg,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: border,
                  boxShadow: shadows,
                ),
                child: content,
              ),
            ),
          );
        },
      ),
    );
  }
}

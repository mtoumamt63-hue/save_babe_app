import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_card.dart';

class MetricChartCard extends StatelessWidget {
  const MetricChartCard({
    super.key,
    required this.title,
    required this.unit,
    required this.measures,
    required this.kind,
  });

  final String title;
  final String unit;
  final List<Measure> measures;
  final String kind;

  double? _numericValue(Measure measure) {
    final raw = measure.value.trim().replaceAll(',', '.');
    if (kind == 'tension') {
      final parts = raw.split('/');
      if (parts.isEmpty) return null;
      return double.tryParse(parts.first.trim());
    }
    return double.tryParse(raw);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final points =
        measures
            .map(
              (m) =>
                  _ChartPoint(DateFormatter.parseFR(m.date), _numericValue(m)),
            )
            .where((p) => p.date != null && p.value != null)
            .toList()
          ..sort((a, b) => a.date!.compareTo(b.date!));

    final visible = points.length > 12
        ? points.sublist(points.length - 12)
        : points;

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelM.copyWith(
              color: isDark
                  ? AppColors.darkCardForeground
                  : AppColors.cardForeground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            visible.isEmpty
                ? 'Ajoutez des mesures pour afficher la courbe.'
                : '${visible.length} mesure${visible.length > 1 ? 's' : ''} récente${visible.length > 1 ? 's' : ''} · $unit',
            style: AppTypography.bodyS.copyWith(
              color: isDark
                  ? AppColors.darkMutedForeground
                  : AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: visible.length < 2
                ? Center(
                    child: Text(
                      visible.isEmpty ? 'Aucune donnée' : 'Ajoutez une deuxième mesure pour tracer une tendance.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyS.copyWith(
                        color: isDark
                            ? AppColors.darkMutedForeground
                            : AppColors.mutedForeground,
                      ),
                    ),
                  )
                : CustomPaint(
                    painter: _MetricChartPainter(
                      values: visible.map((e) => e.value!).toList(),
                      lineColor: isDark
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                      gridColor: isDark
                          ? AppColors.darkBorder
                          : AppColors.border,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChartPoint {
  const _ChartPoint(this.date, this.value);
  final DateTime? date;
  final double? value;
}

class _MetricChartPainter extends CustomPainter {
  const _MetricChartPainter({
    required this.values,
    required this.lineColor,
    required this.gridColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final dotPaint = Paint()..color = lineColor;

    const left = 8.0;
    const right = 8.0;
    const top = 8.0;
    const bottom = 12.0;
    final width = math.max(1.0, size.width - left - right);
    final height = math.max(1.0, size.height - top - bottom);

    for (var i = 0; i <= 3; i++) {
      final y = top + height * i / 3;
      canvas.drawLine(Offset(left, y), Offset(left + width, y), gridPaint);
    }

    var minV = values.reduce(math.min);
    var maxV = values.reduce(math.max);
    if ((maxV - minV).abs() < 0.001) {
      minV -= 1;
      maxV += 1;
    }
    final pad = (maxV - minV) * 0.12;
    minV -= pad;
    maxV += pad;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = left + width * i / (values.length - 1);
      final normalized = (values[i] - minV) / (maxV - minV);
      final y = top + height * (1 - normalized);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _MetricChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gridColor != gridColor;
  }
}

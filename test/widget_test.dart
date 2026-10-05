import 'package:flutter_test/flutter_test.dart';
import 'package:save_babe/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter Tests', () {
    test('weeksOf returns valid clamped weeks', () {
      final now = DateTime.now();
      final lmp = now.subtract(const Duration(days: 140)).toIso8601String();
      final weeks = DateFormatter.weeksOf(lmp);
      expect(weeks, equals(20));
    });

    test('weeksOf returns 0 on empty lmp', () {
      expect(DateFormatter.weeksOf(''), equals(0));
    });

    test('trimester calculates correct trimester', () {
      expect(DateFormatter.trimester(8), equals(1));
      expect(DateFormatter.trimester(20), equals(2));
      expect(DateFormatter.trimester(32), equals(3));
    });
  });
}

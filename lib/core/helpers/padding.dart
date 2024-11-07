import 'dart:io';

class UnitSystem {
  static double bottomPlatformPadding() {
    if (Platform.isIOS) {
      return 36.0;
    }
    return 0.0;
  }

  static double multipleUnit(int multipleNumber, {double unit = unit}) {
    if (multipleNumber <= 0) throw Exception('multipleNumber should be more than 0');
    return unit * multipleNumber;
  }

  static const double unit = 8.0;

  // 16.0
  static double unitX2 = multipleUnit(2);

  // 32.0
  static double unitX4 = multipleUnit(4);

  // 48.0
  static double unitX6 = multipleUnit(6);

  // 56.0
  static double unitX7 = multipleUnit(7);

  // 64.0
  static double unitX8 = multipleUnit(64);
}

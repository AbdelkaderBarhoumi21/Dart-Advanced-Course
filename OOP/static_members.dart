import 'dart:math';

class MathUtils {
  static const double pi = 3.14159;
  static int _instanceCount = 0;

  MathUtils() {
    _instanceCount++;
  }

  static int get instanceCount => _instanceCount;

  static double circleArea(double radius) {
    return pi * radius * radius;
  }

  static double distance(double x1, double y1, double x2, double y2) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    return sqrt(dx * dx + dy * dy);
  }
}

void main() {
  // Usage
  print(MathUtils.pi);
  print(MathUtils.circleArea(5));
}

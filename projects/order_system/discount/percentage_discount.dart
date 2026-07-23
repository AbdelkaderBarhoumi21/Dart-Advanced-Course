import 'discount_stratgey.dart';

class PercentageDiscount extends Discountstrategy {
  final double percent;
  PercentageDiscount(this.percent)
    : assert(
        percent >= 0 && percent <= 100,
        'Percentage must be between 0 and 100',
      );
  @override
  double apply(double subtotal) => subtotal * percent / 100;
  @override
  String describe() => '${percent.toStringAsFixed(0)}% off';
}

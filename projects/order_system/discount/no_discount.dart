import 'discount_stratgey.dart';

class NoDiscount implements Discountstrategy {
  @override
  double apply(double subtotal) => 0.0;

  @override
  String describe() => 'No Discount';
}

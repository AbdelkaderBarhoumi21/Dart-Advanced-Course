import 'discount_stratgey.dart';

class FixedDiscount extends Discountstrategy {
  final double amount;
  FixedDiscount(this.amount)
    : assert(amount >= 0, 'Amount must be non-negative');

  @override
  double apply(double subtotal) => subtotal < amount ? subtotal : amount;
  @override
  String describe() => '${amount.toStringAsFixed(2)} fixed off';
}

import '../discount/discount_stratgey.dart';
import '../discount/no_discount.dart';
import '../domain/cart_item.dart';
import '../domain/product.dart';

class CartService {
  final _items = <String, CartItem>{};
  Discountstrategy _discountStrategy = NoDiscount();

  void addProduct(Product product, int qty) {
    if (_items.containsKey(product.id)) {
      final exisiting = _items[product.id]!;
      final newQty = _clamp(exisiting.quantity + qty, product);
      _items[product.id] = exisiting.withQuantity(newQty);
    } else {
      _items[product.id] = CartItem(product: product, quantity: qty);
    }
  }

  void increment(String productId) {
    _updateQty(productId, 1);
  }

  void decrement(String productId) {
    final item = _getItem(productId);
    if (item.quantity <= item.product.minQty) {
      print(
        'Minimum quantity for ${item.product.name}  is ${item.product.minQty} - remove it instead',
      );
      return;
    }
    _updateQty(productId, -1);
  }

  void removeItem(String productId) {
    if (_items.remove(productId) == null) {
      throw StateError('Product not in cart: $productId');
    }
    print('  ✓ Removed from cart');
  }

  void applyDiscount(Discountstrategy strategy) {
    _discountStrategy = strategy;
    print('  ✓ Discount applied: ${strategy.describe()}');
  }

  void clear() {
    _items.clear();
    _discountStrategy = NoDiscount();
    print('  ✓ Cart cleared');
  }

  bool get isEmpty => _items.isEmpty;
  double get subtotal => _items.values.fold(
    0,
    (previous, cartItem) => previous + cartItem.subtotal,
  );

  double get discountAmount => _discountStrategy.apply(subtotal);
  double get total => subtotal - discountAmount;
  List<CartItem> snapshot() => List.unmodifiable(_items.values.toList());

  void printSummary() {
    if (_items.isEmpty) {
      print('  Cart is empty.');
      return;
    }
    print('\n  ┌─────────────────────────────────────────────┐');
    print('  │                   CART                      │');
    print('  ├─────────────────────────────────────────────┤');
    for (final i in _items.values) {
      print(
        '  │  ${i.product.name.padRight(20)} x${i.quantity.toString().padRight(3)} '
        '${i.subtotal.toStringAsFixed(2).padLeft(8)} €  │',
      );
    }
    print('  ├─────────────────────────────────────────────┤');
    print(
      '  │  Subtotal:                   ${subtotal.toStringAsFixed(2).padLeft(8)} €  │',
    );
    print(
      '  │  Discount (${_discountStrategy.describe().padRight(14)})  '
      '${discountAmount.toStringAsFixed(2).padLeft(8)} €  │',
    );
    print('  ├─────────────────────────────────────────────┤');
    print(
      '  │  TOTAL:                      ${total.toStringAsFixed(2).padLeft(8)} €  │',
    );
    print('  └─────────────────────────────────────────────┘');
  }

  // ── private helpers ──
  void _updateQty(String productId, int delta) {
    final item = _getItem(productId);
    _items[productId] = item.withQuantity(
      _clamp(item.quantity + delta, item.product),
    );
  }

  CartItem _getItem(String productId) {
    final item = _items[productId];
    if (item == null) throw StateError('Product not in cart: $productId');
    return item;
  }

  int _clamp(int qty, Product product) =>
      qty.clamp(product.minQty, product.maxQty);
}

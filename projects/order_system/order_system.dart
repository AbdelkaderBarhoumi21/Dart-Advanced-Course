import 'discount/fixed_discount.dart';
import 'discount/percentage_discount.dart';
import 'domain/product.dart';
import 'repository/file_order_repository.dart';
import 'services/cart_service.dart';
import 'services/order_service.dart';

void main(List<String> args) {
  // --- Catalogue ---
  final apple = Product(
    id: 'P001',
    name: 'Apple',
    price: 0.50,
    minQty: 1,
    maxQty: 100,
  );
  final laptop = Product(
    id: 'P002',
    name: 'Laptop',
    price: 999.99,
    minQty: 1,
    maxQty: 5,
  );
  final book = Product(
    id: 'P003',
    name: 'Clean Code',
    price: 34.90,
    minQty: 1,
    maxQty: 20,
  );
  // --- Wiring (DIP) ---
  final repo = FileOrderRepository('orders.json');
  final cart = CartService();
  final service = OrderService(repo);

  print('\n════════════════════════════════════');
  print('       ORDER SYSTEM — Dart          ');
  print('════════════════════════════════════');

  // --- Add products ---
  print('\n▶ Adding products to cart...');
  cart.addProduct(apple, 5);
  cart.addProduct(laptop, 1);
  cart.addProduct(book, 3);
  cart.printSummary();

  // --- Increment / Decrement ---
  print('\n▶ Incrementing Apple qty...');
  cart.increment('P001');
  print('\n▶ Decrementing Laptop qty (min=1)...');
  cart.decrement('P002'); // warns — already at min

  // --- Remove ---
  print('\n▶ Removing Book from cart...');
  cart.removeItem('P003');
  // --- Discount ---
  print('\n▶ Applying 10% discount...');
  cart.applyDiscount(PercentageDiscount(10));
  cart.printSummary();
  // --- Place order ---
  print('\n▶ Placing order...');
  final order = service.placeOrder(cart);
  print('  ✓ Order placed: ${order.id}');
  print('  ✓ Total paid:   ${order.total.toStringAsFixed(2)} €');
  print('  ✓ Saved to:     orders_dart.json');

  // --- Second order ---
  print('\n▶ New order with fixed discount...');
  cart.addProduct(book, 3);
  cart.applyDiscount(FixedDiscount(5.00));
  cart.printSummary();
  final order2 = service.placeOrder(cart);
  print('  ✓ Order placed: ${order2.id}');

  // --- Load history ---
  print('\n▶ Order history:');
  for (final o in service.orderHistory()) {
    print('  [${o['id']}] ${o['placedAt']} — total: ${o['total']} €');
  }

  print('\n════════════════════════════════════');
  print('  All orders saved to orders_dart.json');
  print('════════════════════════════════════\n');
}

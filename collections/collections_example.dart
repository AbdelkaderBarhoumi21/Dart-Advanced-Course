class Product {
  final String id;
  final String name;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, this.quantity);

  double get subtotal => product.price * quantity;
}

abstract class Discount {
  double apply(double total, List<CartItem> items);
  String get description;
}

class PercentageDiscount implements Discount {
  final double percentage;
  final double minAmount;

  PercentageDiscount(this.percentage, {this.minAmount = 0});

  @override
  double apply(double total, List<CartItem> items) {
    if (total >= minAmount) {
      return total * (1 - percentage / 100);
    }
    return total;
  }

  @override
  String get description => '$percentage% off (min: \$$minAmount)';
}

class CategoryDiscount implements Discount {
  final String category;
  final double discount;

  CategoryDiscount(this.category, this.discount);

  @override
  double apply(double total, List<CartItem> items) {
    final categoryTotal = items
        .where((item) => item.product.category == category)
        .fold<double>(0, (sum, item) => sum + item.subtotal);

    final categoryDiscount = categoryTotal * (discount / 100);
    return total - categoryDiscount;
  }

  @override
  String get description => '$discount% off $category items';
}

class BuyXGetYDiscount implements Discount {
  final int buyQuantity;
  final int freeQuantity;

  BuyXGetYDiscount(this.buyQuantity, this.freeQuantity);

  @override
  double apply(double total, List<CartItem> items) {
    var discount = 0.0;

    for (var item in items) {
      final sets = item.quantity ~/ (buyQuantity + freeQuantity);
      final freeItems = sets * freeQuantity;
      discount += freeItems * item.product.price;
    }

    return total - discount;
  }

  @override
  String get description => 'Buy $buyQuantity Get $freeQuantity Free';
}

class ShoppingCart {
  final Map<String, CartItem> _items = {};
  final List<Discount> _discounts = [];

  void addItem(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product, quantity);
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
    } else {
      _items[productId]?.quantity = quantity;
    }
  }

  void addDiscount(Discount discount) {
    _discounts.add(discount);
  }

  void clearDiscounts() {
    _discounts.clear();
  }

  double get subtotal {
    return _items.values.fold<double>(0, (sum, item) => sum + item.subtotal);
  }

  double get total {
    var total = subtotal;
    final items = _items.values.toList();

    for (var discount in _discounts) {
      total = discount.apply(total, items);
    }

    return total;
  }

  double get savings => subtotal - total;

  Map<String, int> getCategorySummary() {
    final summary = <String, int>{};

    for (var item in _items.values) {
      final category = item.product.category;
      summary[category] = (summary[category] ?? 0) + item.quantity;
    }

    return summary;
  }

  List<CartItem> get items => _items.values.toList();

  String generateReceipt() {
    final buffer = StringBuffer();
    buffer.writeln('=' * 50);
    buffer.writeln('SHOPPING CART RECEIPT');
    buffer.writeln('=' * 50);

    for (var item in _items.values) {
      buffer.writeln(
        '${item.product.name} x${item.quantity} @ \$${item.product.price}'
        ' = \$${item.subtotal.toStringAsFixed(2)}',
      );
    }

    buffer.writeln('-' * 50);
    buffer.writeln('Subtotal: \$${subtotal.toStringAsFixed(2)}');

    if (_discounts.isNotEmpty) {
      buffer.writeln('\nDiscounts Applied:');
      for (var discount in _discounts) {
        buffer.writeln('  - ${discount.description}');
      }
      buffer.writeln('Savings: -\$${savings.toStringAsFixed(2)}');
    }

    buffer.writeln('=' * 50);
    buffer.writeln('TOTAL: \$${total.toStringAsFixed(2)}');
    buffer.writeln('=' * 50);

    return buffer.toString();
  }
}

// Usage
void main() {
  final cart = ShoppingCart();

  final laptop = Product(
    id: 'P1',
    name: 'Laptop',
    price: 999.99,
    category: 'Electronics',
  );

  final mouse = Product(
    id: 'P2',
    name: 'Mouse',
    price: 29.99,
    category: 'Electronics',
  );

  final book = Product(
    id: 'P3',
    name: 'Programming Book',
    price: 49.99,
    category: 'Books',
  );

  cart.addItem(laptop);
  cart.addItem(mouse, quantity: 2);
  cart.addItem(book, quantity: 3);

  cart.addDiscount(PercentageDiscount(10, minAmount: 100));
  cart.addDiscount(CategoryDiscount('Electronics', 5));

  print(cart.generateReceipt());
  print('\nCategory Summary: ${cart.getCategorySummary()}');
}

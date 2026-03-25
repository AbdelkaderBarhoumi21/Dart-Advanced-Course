class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
  });
}

// Strategy
abstract class SortStrategy {
  List<Product> sort(List<Product> products);
}

class SortByPriceAsc implements SortStrategy {
  @override
  List<Product> sort(List<Product> products) =>
      [...products]..sort((a, b) => a.price.compareTo(b.price));
}

class SortByPriceDesc implements SortStrategy {
  @override
  List<Product> sort(List<Product> products) =>
      [...products]..sort((a, b) => b.price.compareTo(a.price));
}

class SortByRating implements SortStrategy {
  @override
  List<Product> sort(List<Product> products) =>
      [...products]..sort((a, b) => b.rating.compareTo(a.rating));
}

class SortByName implements SortStrategy {
  @override
  List<Product> sort(List<Product> products) =>
      [...products]..sort((a, b) => a.name.compareTo(b.name));
}

// Context
class ProductCatalog {
  SortStrategy _strategy;
  ProductCatalog(this._strategy);

  void setStrategy(SortStrategy strategy) {
    _strategy = strategy;
  }

  List<Product> displayProducts(List<Product> products) {
    return _strategy.sort(products);
  }

  void printProducts(List<Product> products) {
    final sorted = _strategy.sort(products);
    print('\n📦 Products:');
    for (var product in sorted) {
      print('  ${product.name} - \$${product.price.toStringAsFixed(2)} ⭐${product.rating}');
    }
  }
}

void main() {
  // Create sample products
  final products = [
    Product(id: '1', name: 'Laptop', price: 999.99, rating: 4.5),
    Product(id: '2', name: 'Mouse', price: 25.50, rating: 4.8),
    Product(id: '3', name: 'Keyboard', price: 75.00, rating: 4.2),
    Product(id: '4', name: 'Monitor', price: 350.00, rating: 4.7),
  ];

  // Use catalog with different sorting strategies
  final catalog = ProductCatalog(SortByPriceAsc());
  print('🔼 Sorting by Price (Ascending):');
  catalog.printProducts(products);

  catalog.setStrategy(SortByPriceDesc());
  print('\n🔽 Sorting by Price (Descending):');
  catalog.printProducts(products);

  catalog.setStrategy(SortByRating());
  print('\n⭐ Sorting by Rating:');
  catalog.printProducts(products);

  catalog.setStrategy(SortByName());
  print('\n🔤 Sorting by Name:');
  catalog.printProducts(products);
}

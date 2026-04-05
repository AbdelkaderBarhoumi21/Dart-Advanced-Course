/// # D — Dependency Inversion Principle (DIP)
///
/// > High-level modules should not depend on low-level modules.
/// Both should depend on **abstractions**.

// ─────────────────────────────────────────────────────────────
// ❌ BAD — Widget directly depends on concrete HTTP call
// ─────────────────────────────────────────────────────────────

/// Bad: hard-coded dependency — can't test without a real server,
/// can't switch data source without editing the widget.
///
/// ```dart
/// class ProductListPage extends StatefulWidget {
///   @override
///   _ProductListPageState createState() => _ProductListPageState();
/// }
///
/// class _ProductListPageState extends State<ProductListPage> {
///   Future<void> _loadProducts() async {
///     // ❌ Tightly coupled to HTTP
///     final response = await http.get(Uri.parse('https://api.example.com/products'));
///     final data = jsonDecode(response.body);
///     // ...
///   }
/// }
/// ```

// ─────────────────────────────────────────────────────────────
// ✅ GOOD — Depend on abstraction, not concrete implementation
// ─────────────────────────────────────────────────────────────

/// The abstraction — both high-level and low-level depend on this.
abstract class ProductRepository {
  Future<List<String>> getProducts();
}

/// Concrete: fetches from API.
class ApiProductRepository implements ProductRepository {
  @override
  Future<List<String>> getProducts() async {
    // In real code: http.get(...) + jsonDecode(...)
    return ['Product A', 'Product B'];
  }
}

/// Concrete: fake for testing — no server needed.
class FakeProductRepository implements ProductRepository {
  @override
  Future<List<String>> getProducts() async {
    return ['Test Product 1', 'Test Product 2'];
  }
}

/// Concrete: switched to Firebase? Just a new class — nothing else changes.
class FirebaseProductRepository implements ProductRepository {
  @override
  Future<List<String>> getProducts() async {
    // Firebase logic here...
    return ['Firebase Product 1'];
  }
}

/// High-level service depends on [ProductRepository] (abstraction),
/// not on any concrete class.
class ProductService {
  final ProductRepository _repository;

  ProductService(this._repository);

  Future<void> printProducts() async {
    final products = await _repository.getProducts();
    for (final p in products) {
      print(p);
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Usage
// ─────────────────────────────────────────────────────────────

void main() async {
  // Production:
  final service = ProductService(ApiProductRepository());
  await service.printProducts();

  // Testing:
  final testService = ProductService(FakeProductRepository());
  await testService.printProducts();

  // Switched to Firebase? Just swap the implementation:
  final fbService = ProductService(FirebaseProductRepository());
  await fbService.printProducts();
}

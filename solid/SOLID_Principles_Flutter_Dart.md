# SOLID Principles in Dart & Flutter

## A Complete Guide with Real-World Examples

---

## Table of Contents

1. [What is SOLID?](#what-is-solid)
2. [Why Do We Need SOLID?](#why-do-we-need-solid)
3. [The Flow: How SOLID Works Together](#the-flow-how-solid-works-together)
4. [S — Single Responsibility Principle](#s--single-responsibility-principle-srp)
5. [O — Open/Closed Principle](#o--openclosed-principle-ocp)
6. [L — Liskov Substitution Principle](#l--liskov-substitution-principle-lsp)
7. [I — Interface Segregation Principle](#i--interface-segregation-principle-isp)
8. [D — Dependency Inversion Principle](#d--dependency-inversion-principle-dip)
9. [Putting It All Together: A Flutter Example](#putting-it-all-together-a-flutter-example)
10. [Summary Cheat Sheet](#summary-cheat-sheet)

---

## What is SOLID?

SOLID is an acronym for five design principles introduced by Robert C. Martin (Uncle Bob). These principles guide developers in writing code that is clean, maintainable, testable, and scalable. Each letter represents one principle:

| Letter | Principle | One-Line Summary |
|--------|-----------|------------------|
| **S** | Single Responsibility | A class should do one thing only. |
| **O** | Open/Closed | Open for extension, closed for modification. |
| **L** | Liskov Substitution | Subtypes must be replaceable for their base types. |
| **I** | Interface Segregation | Don't force classes to implement what they don't need. |
| **D** | Dependency Inversion | Depend on abstractions, not concrete implementations. |

---

## Why Do We Need SOLID?

Without SOLID, Flutter apps tend to fall into common traps as they grow:

**The Problems SOLID Solves:**

- **Spaghetti code**: One class does everything — fetches data, validates input, builds UI, handles navigation. When you change one thing, everything breaks.
- **Rigid code**: Adding a new feature requires modifying existing, working code. This introduces bugs in features that were already finished.
- **Untestable code**: Your widget directly calls `http.get(...)`. How do you write a unit test without hitting a real server?
- **Copy-paste duplication**: You end up copying logic because the original class is too tangled to reuse.
- **Fear of change**: Developers are afraid to touch the codebase because a small edit causes a cascade of failures.

SOLID gives you a set of rules to prevent all of these problems. The result is code that is easy to read, easy to test, easy to extend, and safe to change.

---

## The Flow: How SOLID Works Together

Think of SOLID as a pipeline. Each principle builds on the previous one:

```
Step 1: Break things apart (SRP)
   ↓
Step 2: Make each piece extensible without editing it (OCP)
   ↓
Step 3: Ensure replaceable parts truly behave as expected (LSP)
   ↓
Step 4: Keep interfaces small and focused (ISP)
   ↓
Step 5: Wire everything together through abstractions (DIP)
```

Here is the mental model:

1. **SRP** splits your giant class into small, focused classes.
2. **OCP** ensures you can add new behavior to those classes without rewriting them.
3. **LSP** guarantees that when you swap one implementation for another, nothing breaks.
4. **ISP** makes sure the contracts (abstract classes / interfaces) you create are lean — no unnecessary baggage.
5. **DIP** ties it all together by making high-level logic depend on abstractions, not on the concrete small classes from step 1.

When you follow all five, you get a codebase where features are isolated, testable, and independently deployable.

---

## S — Single Responsibility Principle (SRP)

### The Rule

> A class should have only **one reason to change**.

This means each class should do exactly one job. If a class handles two different concerns, a change in one concern could break the other.

### The Problem It Solves

Imagine a `UserProfile` widget in Flutter that:

- Fetches user data from an API
- Validates the user's email format
- Builds the UI
- Handles navigation

If the API response format changes, you have to edit the same file that builds the UI. If the validation rules change, you risk breaking the navigation. Everything is tangled.

### Bad Example (Violating SRP)

```dart
class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  // PROBLEM: This class fetches data...
  Future<void> _fetchUser() async {
    final response = await http.get(Uri.parse('https://api.example.com/user/1'));
    setState(() {
      userData = jsonDecode(response.body);
    });
  }

  // PROBLEM: ...validates data...
  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // PROBLEM: ...AND builds UI. Three responsibilities in one class.
  @override
  Widget build(BuildContext context) {
    if (userData == null) return CircularProgressIndicator();
    return Column(
      children: [
        Text(userData!['name']),
        Text(userData!['email']),
        if (!_isEmailValid(userData!['email']))
          Text('Invalid email', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
```

**Why this is bad:** If you change the API URL, you edit the UI file. If you add a new validation rule, you edit the UI file. Every change touches the same place. Testing is also impossible without running the full widget.

### Good Example (Following SRP)

Split the class into three focused pieces:

```dart
// --- Responsibility 1: Data fetching ---
class UserRepository {
  Future<User> fetchUser(int id) async {
    final response = await http.get(Uri.parse('https://api.example.com/user/$id'));
    final json = jsonDecode(response.body);
    return User.fromJson(json);
  }
}

// --- Responsibility 2: Validation ---
class EmailValidator {
  bool isValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

// --- Responsibility 3: UI only ---
class UserProfilePage extends StatelessWidget {
  final User user;
  final EmailValidator validator;

  const UserProfilePage({required this.user, required this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(user.name),
        Text(user.email),
        if (!validator.isValid(user.email))
          Text('Invalid email', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
```

**Why this is good:** Each class has one reason to change. The repository changes only when the API changes. The validator changes only when validation rules change. The widget changes only when the UI layout changes. You can test each piece independently.

---

## O — Open/Closed Principle (OCP)

### The Rule

> A class should be **open for extension** but **closed for modification**.

You should be able to add new behavior without changing existing, working code.

### The Problem It Solves

You have a payment system that supports credit cards. The client now wants PayPal. Without OCP, you open the existing payment class and add `if/else` branches. Every new payment method means editing the same class, risking bugs in the credit card logic that was already working.

### Bad Example (Violating OCP)

```dart
class PaymentService {
  void pay(String method, double amount) {
    if (method == 'credit_card') {
      print('Charging credit card: \$$amount');
      // credit card-specific logic...
    } else if (method == 'paypal') {
      print('Charging PayPal: \$$amount');
      // paypal-specific logic...
    } else if (method == 'apple_pay') {
      // Every new method = modifying this class
      print('Charging Apple Pay: \$$amount');
    }
  }
}
```

**Why this is bad:** Every time a new payment method is added, you modify this class. You could introduce a typo in the credit card branch while adding Apple Pay. The class grows endlessly with `if/else` chains.

### Good Example (Following OCP)

```dart
// Define an abstraction (a contract)
abstract class PaymentMethod {
  void pay(double amount);
}

// Each payment method is its own class — you EXTEND, never MODIFY.
class CreditCardPayment implements PaymentMethod {
  @override
  void pay(double amount) {
    print('Charging credit card: \$$amount');
  }
}

class PayPalPayment implements PaymentMethod {
  @override
  void pay(double amount) {
    print('Charging PayPal: \$$amount');
  }
}

// Adding Apple Pay? Just create a new class. No existing code is touched.
class ApplePayPayment implements PaymentMethod {
  @override
  void pay(double amount) {
    print('Charging Apple Pay: \$$amount');
  }
}

// The service works with any PaymentMethod — it never changes.
class PaymentService {
  void processPayment(PaymentMethod method, double amount) {
    method.pay(amount);
  }
}
```

**Why this is good:** To add a new payment method, you create a new class. The `PaymentService` class never changes. Old code stays stable. New features are isolated in new files.

---

## L — Liskov Substitution Principle (LSP)

### The Rule

> If class `B` is a subtype of class `A`, then you should be able to replace `A` with `B` **without breaking the program**.

Subtypes must honor the contract of their parent type. They should not throw unexpected errors, ignore expected behavior, or change the meaning of a method.

### The Problem It Solves

You create a base class `Bird` with a `fly()` method. Then you create `Penguin extends Bird`. Penguins cannot fly. Now any code that calls `bird.fly()` will crash when it receives a Penguin. The subtype broke the contract.

### Bad Example (Violating LSP)

```dart
class Bird {
  void fly() {
    print('Flying...');
  }
}

class Penguin extends Bird {
  @override
  void fly() {
    // PROBLEM: Penguins can't fly. This violates the parent's contract.
    throw Exception('Penguins cannot fly!');
  }
}

// This function trusts that every Bird can fly.
void makeBirdFly(Bird bird) {
  bird.fly(); // CRASH if bird is a Penguin
}
```

**Why this is bad:** Any function that accepts a `Bird` expects `fly()` to work. Passing a `Penguin` causes a runtime crash. The substitution broke the program.

### Good Example (Following LSP)

```dart
// Separate the abilities into focused abstractions.
abstract class Bird {
  void eat();
}

abstract class FlyingBird extends Bird {
  void fly();
}

// Sparrow can fly — it extends FlyingBird.
class Sparrow extends FlyingBird {
  @override
  void eat() => print('Sparrow eating seeds');

  @override
  void fly() => print('Sparrow flying');
}

// Penguin cannot fly — it extends Bird directly.
class Penguin extends Bird {
  @override
  void eat() => print('Penguin eating fish');
}

// This function only accepts birds that can fly.
void makeBirdFly(FlyingBird bird) {
  bird.fly(); // Safe — every FlyingBird truly can fly.
}
```

**Why this is good:** You can never accidentally pass a Penguin to `makeBirdFly()` because Penguin is not a FlyingBird. The type system protects you. Substitution is always safe.

---

## I — Interface Segregation Principle (ISP)

### The Rule

> A class should **not be forced to implement methods it does not use**.

Instead of one large interface, create several small, focused ones.

### The Problem It Solves

You create a `Worker` interface with `code()`, `test()`, and `attendMeeting()`. A `Robot` worker can code and test, but it does not attend meetings. Yet the interface forces Robot to implement `attendMeeting()`, which it throws an exception for or leaves empty. This is wasted effort and a potential source of bugs.

### Bad Example (Violating ISP)

```dart
// One fat interface forces every class to implement everything.
abstract class Worker {
  void code();
  void test();
  void attendMeeting();
  void writeDocumentation();
}

class Developer implements Worker {
  @override
  void code() => print('Writing Dart code');

  @override
  void test() => print('Running tests');

  @override
  void attendMeeting() => print('In a meeting');

  @override
  void writeDocumentation() => print('Writing docs');
}

class Robot implements Worker {
  @override
  void code() => print('Generating code');

  @override
  void test() => print('Running automated tests');

  @override
  void attendMeeting() {
    // PROBLEM: Robot doesn't attend meetings, but is forced to implement this.
    throw UnimplementedError('Robots do not attend meetings');
  }

  @override
  void writeDocumentation() {
    // PROBLEM: Robot doesn't write docs either.
    throw UnimplementedError('Robots do not write docs');
  }
}
```

**Why this is bad:** Robot is forced to have methods it cannot meaningfully implement. Any code calling `worker.attendMeeting()` on a Robot will crash.

### Good Example (Following ISP)

```dart
// Small, focused interfaces. Each class picks only what it needs.
abstract class Coder {
  void code();
}

abstract class Tester {
  void test();
}

abstract class MeetingAttendee {
  void attendMeeting();
}

abstract class DocumentationWriter {
  void writeDocumentation();
}

// Developer uses all four.
class Developer implements Coder, Tester, MeetingAttendee, DocumentationWriter {
  @override
  void code() => print('Writing Dart code');

  @override
  void test() => print('Running tests');

  @override
  void attendMeeting() => print('In a meeting');

  @override
  void writeDocumentation() => print('Writing docs');
}

// Robot only uses what it can do.
class Robot implements Coder, Tester {
  @override
  void code() => print('Generating code');

  @override
  void test() => print('Running automated tests');
}
```

**Why this is good:** Robot is never forced to implement `attendMeeting()`. The interfaces are small and focused. Each class implements only the contracts it can fulfill.

---

## D — Dependency Inversion Principle (DIP)

### The Rule

> High-level modules should not depend on low-level modules. Both should depend on **abstractions**.

Instead of your widget directly creating an `HttpClient`, it should receive an abstract `DataSource`. This way, you can swap the real API for a fake one during testing without changing a single line in the widget.

### The Problem It Solves

Your widget directly calls `http.get(...)`. During testing, every test hits the real server — it is slow, unreliable, and sometimes fails because the server is down. You cannot test the widget in isolation.

In production, if you switch from REST to GraphQL, you have to edit every widget that calls the API.

### Bad Example (Violating DIP)

```dart
// The widget directly depends on a concrete implementation (http package).
class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // PROBLEM: Hard-coded dependency on http.
    // Cannot test without hitting the real server.
    // Cannot switch to GraphQL without editing this widget.
    final response = await http.get(Uri.parse('https://api.example.com/products'));
    final List data = jsonDecode(response.body);
    setState(() {
      products = data.map((json) => Product.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => Text(products[index].name),
    );
  }
}
```

**Why this is bad:** The widget is tightly coupled to the HTTP package. You cannot test it without a real server. Switching to a different data source (local database, GraphQL, Firebase) requires editing the widget code.

### Good Example (Following DIP)

```dart
// Step 1: Define an abstraction.
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

// Step 2: Create the concrete implementation.
class ApiProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('https://api.example.com/products'));
    final List data = jsonDecode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  }
}

// Step 3: Create a fake for testing.
class FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    return [
      Product(name: 'Test Product 1'),
      Product(name: 'Test Product 2'),
    ];
  }
}

// Step 4: The widget depends on the ABSTRACTION, not the concrete class.
class ProductListPage extends StatefulWidget {
  final ProductRepository repository; // Depends on abstraction

  const ProductListPage({required this.repository});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final result = await widget.repository.getProducts();
    setState(() {
      products = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => Text(products[index].name),
    );
  }
}
```

**How you use it:**

```dart
// In production:
ProductListPage(repository: ApiProductRepository())

// In tests:
ProductListPage(repository: FakeProductRepository())

// Switched to Firebase? Just create a new class:
class FirebaseProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    // Firebase logic here...
  }
}
// The widget code stays exactly the same.
```

**Why this is good:** The widget does not know or care where the data comes from. You can swap implementations freely. Tests are fast and reliable because they use a fake. Adding a new data source never requires editing the widget.

---

## Putting It All Together: A Flutter Example

Here is a realistic Flutter example that applies all five principles. We are building a feature that displays a list of articles.

```dart
// ============================================================
// MODEL (Data class — single responsibility: hold data)
// ============================================================
class Article {
  final String id;
  final String title;
  final String body;
  final DateTime publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.body,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      publishedAt: DateTime.parse(json['published_at']),
    );
  }
}

// ============================================================
// ABSTRACTIONS (ISP: small, focused interfaces)
// ============================================================
abstract class ArticleReader {
  Future<List<Article>> getArticles();
}

abstract class ArticleWriter {
  Future<void> saveArticle(Article article);
}

// A class that needs both can implement both.
// A class that only reads does not need to implement saveArticle().

// ============================================================
// CONCRETE IMPLEMENTATION (SRP: only handles API communication)
// ============================================================
class ApiArticleRepository implements ArticleReader {
  final String baseUrl;

  ApiArticleRepository({required this.baseUrl});

  @override
  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse('$baseUrl/articles'));
    final List data = jsonDecode(response.body);
    return data.map((json) => Article.fromJson(json)).toList();
  }
}

// OCP: Adding a cached version? Extend, don't modify.
class CachedArticleRepository implements ArticleReader {
  final ArticleReader _source;
  List<Article>? _cache;

  CachedArticleRepository(this._source);

  @override
  Future<List<Article>> getArticles() async {
    _cache ??= await _source.getArticles();
    return _cache!;
  }
}

// ============================================================
// USE CASE / BUSINESS LOGIC (SRP: only orchestrates logic)
// ============================================================
class GetArticlesUseCase {
  final ArticleReader _reader;

  GetArticlesUseCase(this._reader); // DIP: depends on abstraction

  Future<List<Article>> call() async {
    final articles = await _reader.getArticles();
    // Business rule: only show articles from the last 30 days
    final cutoff = DateTime.now().subtract(Duration(days: 30));
    return articles.where((a) => a.publishedAt.isAfter(cutoff)).toList();
  }
}

// ============================================================
// UI LAYER (SRP: only builds the visual interface)
// ============================================================
class ArticleListPage extends StatelessWidget {
  final GetArticlesUseCase getArticles;

  const ArticleListPage({required this.getArticles});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: getArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final articles = snapshot.data!;
        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(articles[index].title),
              subtitle: Text(articles[index].body),
            );
          },
        );
      },
    );
  }
}

// ============================================================
// WIRING (at the app's entry point or with a DI framework)
// ============================================================
void main() {
  final apiRepo = ApiArticleRepository(baseUrl: 'https://api.example.com');
  final cachedRepo = CachedArticleRepository(apiRepo);
  final useCase = GetArticlesUseCase(cachedRepo);

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Articles')),
      body: ArticleListPage(getArticles: useCase),
    ),
  ));
}
```

**How each principle is applied in this example:**

| Principle | Where It Appears |
|-----------|------------------|
| **SRP** | `Article` holds data. `ApiArticleRepository` fetches data. `GetArticlesUseCase` applies business rules. `ArticleListPage` renders UI. Each class has one job. |
| **OCP** | `CachedArticleRepository` adds caching behavior without modifying `ApiArticleRepository`. |
| **LSP** | `CachedArticleRepository` and `ApiArticleRepository` both implement `ArticleReader`. You can substitute one for the other without breaking anything. |
| **ISP** | `ArticleReader` and `ArticleWriter` are separate interfaces. The UI only needs `ArticleReader` and is never burdened with write methods. |
| **DIP** | `GetArticlesUseCase` depends on `ArticleReader` (abstraction), not `ApiArticleRepository` (concrete class). The widget depends on the use case, not on HTTP directly. |

---

## Summary Cheat Sheet

| Principle | Remember This | Ask Yourself |
|-----------|---------------|--------------|
| **SRP** | One class = one job | "Does this class have more than one reason to change?" |
| **OCP** | Add new code, don't edit old code | "Can I add this feature without touching existing classes?" |
| **LSP** | Subtypes must behave like parents | "If I swap this subclass in, will everything still work?" |
| **ISP** | Small interfaces beat fat ones | "Is any class forced to implement methods it doesn't need?" |
| **DIP** | Depend on abstractions | "Does my widget know about HTTP, Firebase, or SQL directly?" |

**The golden rule:** If your Flutter app follows SOLID, any developer can open any file, understand what it does, change it safely, and test it in isolation. That is the goal.

---

*Document prepared for Dart/Flutter developers. All code examples use Dart syntax and Flutter framework patterns.*

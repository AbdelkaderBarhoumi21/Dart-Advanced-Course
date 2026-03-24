# Dart Learning Repository

A comprehensive collection of Dart examples, design patterns, and advanced concepts for learning and reference.

## 📁 Project Structure

### 🎨 [design_pattern/](design_pattern/)
Design patterns implemented in Dart with detailed explanations and examples.

- **`singleton_pattern.dart`** - Singleton pattern with private constructors, ensuring only one instance exists throughout the application
- **`factory_method_example2.dart`** - Factory Method pattern for creating different notification types (Push, Email, SMS) from JSON data

### 🔷 [OOP/](OOP/)
Object-Oriented Programming fundamentals and advanced concepts in Dart.

Contains core OOP principles, inheritance, polymorphism, encapsulation, and abstraction examples.

### 📦 [collections/](collections/)
Dart collection types and operations.

Covers Lists, Sets, Maps, Iterables, and collection manipulation methods with practical examples.

### 🏷️ [enums/](enums/)
Enumeration examples and use cases.

Demonstrates how to use enums for type-safe constants and enhanced enums with methods and properties.

### 🔧 [functions/](functions/)
Function types, higher-order functions, and functional programming concepts.

Includes anonymous functions, arrow syntax, closures, and function composition examples.

### ⚡ [isolates/](isolates/)
Dart isolates for concurrent programming.

Examples of:
- Creating and managing isolates
- Message passing between isolates
- Heavy computation offloading
- Parallel processing patterns

### ❓ [null_safety/](null_safety/)
Null safety features and best practices.

Covers nullable types, null-aware operators, late variables, and handling null values safely.

### 🎯 [optionals/](optionals/)
Optional values and handling missing data patterns.

Demonstrates various approaches to dealing with optional/nullable data in Dart.

## 🚀 Getting Started

### Prerequisites
- Dart SDK 3.0 or higher
- A code editor (VS Code, IntelliJ IDEA, or Android Studio recommended)

### Running Examples

1. Clone the repository:
```bash
git clone <repository-url>
cd Dart
```

2. Run any example file:
```bash
dart run design_pattern/singleton_pattern.dart
dart run design_pattern/factory_method_example2.dart
dart run isolates/<example-file>.dart
```

## 📚 Learning Path

**Recommended order for beginners:**

1. **OOP/** - Start with object-oriented fundamentals
2. **collections/** - Learn about data structures
3. **functions/** - Understand functional programming
4. **enums/** - Type-safe constants
5. **null_safety/** - Modern Dart null safety
6. **optionals/** - Handling optional values
7. **design_pattern/** - Software design patterns
8. **isolates/** - Advanced concurrency

## 🎓 Key Concepts Covered

### Design Patterns
- **Singleton Pattern** - Single instance management with private constructors
- **Factory Method Pattern** - Object creation with runtime type determination

### Concurrency
- Isolates for parallel execution
- Message passing between isolates
- Heavy computation offloading

### Modern Dart Features
- Sound null safety
- Enhanced enums
- Late initialization
- Extension methods
- Pattern matching (if applicable)

## 📖 Documentation Style

Each example file includes:
- ✅ Clear explanations with inline comments
- ✅ Real-world use cases
- ✅ Common pitfalls to avoid (❌ Bad vs ✅ Good examples)
- ✅ Working code that you can run immediately
- ✅ Best practices and recommendations

## 🤝 Contributing

Contributions are welcome! If you'd like to add more examples or improve existing ones:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-example`)
3. Commit your changes (`git commit -m 'Add: new example'`)
4. Push to the branch (`git push origin feature/new-example`)
5. Open a Pull Request

## 📝 Code Style

- Use clear, descriptive variable names
- Include comprehensive documentation comments
- Provide both correct and incorrect examples where applicable
- Follow Dart's official style guide

## 🔗 Resources

- [Dart Official Documentation](https://dart.dev/guides)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Dart Design Patterns](https://refactoring.guru/design-patterns/dart)

## 📄 License

This project is open source and available for educational purposes.

## 👤 Author

**AbdelkaderBarhoumi21**

---

⭐ If you find this repository helpful, please consider giving it a star!

**Happy Learning! 🎉**

/// # L — Liskov Substitution Principle (LSP)
/// A Subtypes is a class that extends or implements another class (the base type). 
/// Subtypes must honor the contract of their parent type.
/// They should not throw unexpected errors, ignore expected behavior, or change the meaning of a method.
/// > Subtypes must be **replaceable** for their base types without breaking
/// the program.

// ─────────────────────────────────────────────────────────────
// ❌ BAD — Penguin breaks the Bird contract
// ─────────────────────────────────────────────────────────────

/// Bad: any code calling `bird.fly()` crashes with a Penguin.
class BadBird {
  void fly() => print('Flying...');
}

class BadPenguin extends BadBird {
  @override
  void fly() => throw Exception('Penguins cannot fly!');
}

void makeBadBirdFly(BadBird bird) {
  bird.fly(); // 💥 CRASH if bird is a BadPenguin
}

// ─────────────────────────────────────────────────────────────
// ✅ GOOD — Separate abilities so substitution is always safe
// ─────────────────────────────────────────────────────────────

/// Base — all birds can eat.
abstract class Bird {
  void eat();
}

/// Only birds that can fly extend this.
abstract class FlyingBird extends Bird {
  void fly();
}

/// Sparrow can fly — extends [FlyingBird].
class Sparrow extends FlyingBird {
  @override
  void eat() => print('Sparrow eating seeds');

  @override
  void fly() => print('Sparrow flying');
}

/// Penguin cannot fly — extends [Bird] directly.
class Penguin extends Bird {
  @override
  void eat() => print('Penguin eating fish');
}

/// Safe — only accepts birds that truly can fly.
void makeBirdFly(FlyingBird bird) {
  bird.fly(); // ✅ Always safe
}

// ─────────────────────────────────────────────────────────────
// Usage
// ─────────────────────────────────────────────────────────────

void main() {
  final sparrow = Sparrow();
  final penguin = Penguin();

  makeBirdFly(sparrow); // ✅ Works
  // makeBirdFly(penguin); // ❌ Compile error — Penguin is not a FlyingBird
  penguin.eat(); // ✅ Penguin does what it can
}

/// # O — Open/Closed Principle (OCP)
///
/// > A class should be **open for extension** but **closed for modification**.
/// Add new behavior by creating new classes, not by editing existing ones.

// ─────────────────────────────────────────────────────────────
// ❌ BAD — Every new payment method modifies this class
// ─────────────────────────────────────────────────────────────

/// Bad: growing if/else chain — editing existing code risks breaking it.
class BadPaymentService {
  void pay(String method, double amount) {
    if (method == 'credit_card') {
      print('Charging credit card: \$$amount');
    } else if (method == 'paypal') {
      print('Charging PayPal: \$$amount');
    } else if (method == 'apple_pay') {
      // Every new method = modifying this class
      print('Charging Apple Pay: \$$amount');
    }
  }
}

// ─────────────────────────────────────────────────────────────
// ✅ GOOD — Extend with new classes, never touch existing ones
// ─────────────────────────────────────────────────────────────

/// The contract — all payment methods implement this.
abstract class PaymentMethod {
  void pay(double amount);
}

/// Credit card payment.
class CreditCardPayment implements PaymentMethod {
  @override
  void pay(double amount) => print('Charging credit card: \$$amount');
}

/// PayPal payment.
class PayPalPayment implements PaymentMethod {
  @override
  void pay(double amount) => print('Charging PayPal: \$$amount');
}

/// Apple Pay — added without touching any existing class.
class ApplePayPayment implements PaymentMethod {
  @override
  void pay(double amount) => print('Charging Apple Pay: \$$amount');
}

/// The service works with any [PaymentMethod] — it never changes.
class PaymentService {
  void processPayment(PaymentMethod method, double amount) {
    method.pay(amount);
  }
}

// ─────────────────────────────────────────────────────────────
// Usage
// ─────────────────────────────────────────────────────────────

void main() {
  final service = PaymentService();

  service.processPayment(CreditCardPayment(), 29.99);
  service.processPayment(PayPalPayment(), 15.00);
  service.processPayment(ApplePayPayment(), 9.99);
}

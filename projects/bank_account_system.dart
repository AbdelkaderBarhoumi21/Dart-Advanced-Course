class InsufficientFundsException implements Exception {
  final double shortfall;
  final String message;
  InsufficientFundsException(double requested, double available)
    : shortfall = requested - available,
      message =
          'Requested ${requested.toStringAsFixed(2)} but only '
          '${available.toStringAsFixed(2)} available';
  @override
  String toString() => message;
}

// Dart: interface == any class used with `implements`. Mixins/abstract too.
abstract class Account {
  final String id;
  double _balance; // _ = library-private (Dart's "protected")

  Account(this.id, this._balance) {
    if (_balance < 0) throw ArgumentError('Initial balance < 0');
  }

  double get balance => _balance; // getter

  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    _balance += amount;
  }

  void withdraw(double amount); // abstract method

  void transferTo(Account target, double amount) {
    withdraw(amount);
    target.deposit(amount);
  }

  @override
  String toString() =>
      '$runtimeType[$id] balance=${_balance.toStringAsFixed(2)}';
}

class SavingsAccount extends Account {
  final double rate;
  SavingsAccount(
    super.id,
    super.initial,
    this.rate,
  ); // super params (Dart 2.17+)

  @override
  void withdraw(double amount) {
    if (amount > _balance) throw InsufficientFundsException(amount, _balance);
    _balance -= amount;
  }

  void applyInterest() => _balance += _balance * rate;
}

class CheckingAccount extends Account {
  final double overdraftLimit;
  CheckingAccount(super.id, super.initial, this.overdraftLimit);

  @override
  void withdraw(double amount) {
    if (amount > _balance + overdraftLimit) {
      throw InsufficientFundsException(amount, _balance + overdraftLimit);
    }
    _balance -= amount;
  }
}

void main() {
  final savings = SavingsAccount('SAV-1', 1000, 0.05);
  final checking = CheckingAccount('CHK-1', 200, 500);
  final List<Account> accounts = [savings, checking]; // polymorphic

  savings.applyInterest(); // 1050
  savings.transferTo(checking, 300); // savings 750, checking 500
  checking.withdraw(900); // -400 within limit

  accounts.forEach(print);

  try {
    savings.withdraw(99999);
  } on InsufficientFundsException catch (e) {
    print('Denied. Short by ${e.shortfall}');
  }
}

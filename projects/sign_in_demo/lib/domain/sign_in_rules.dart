class SignInRules {
  static const allowedPrefix = '+216';
  static const phoneLength = 8;
  static bool isAllowedPhone(String phone) {
    if (!phone.startsWith(allowedPrefix)) return false;
    if (phone.length != phoneLength) return false;
    final digits = phone.substring(1);
    return int.tryParse(digits) != null;
  }

  /// Rule 2: the PIN is 4 digits and not too easy to guess.
  static bool isWeakPin(String pin) {
    if (pin.length != 4 || int.tryParse(pin) == null) return true;

    // "1111", "7777" ... all the same digit
    final allSame = pin.split('').every((d) => d == pin[0]);

    // "1234", "4567" ... a straight run
    final isSequence = '0123456789'.contains(pin);

    return allSame || isSequence;
  }
}

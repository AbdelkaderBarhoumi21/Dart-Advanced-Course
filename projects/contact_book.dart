class Contact {
  Contact(this.name, this.phone, [this.email]); // [] = optional positional
  final String name;
  final String phone;
  final String? email; // nullable, like Kotlin

  // Dart has no data class — override these by hand (or use the `equatable` package)
  @override
  String toString() => 'Contact($name, $phone, ${email ?? "no email"})';
}

class ContactBook {
  final Map<String, Contact> _byPhone = {}; // _ = library-private

  void add(Contact c) {
    if (_byPhone.containsKey(c.phone)) {
      throw ArgumentError('Phone already exists: ${c.phone}');
    }
    _byPhone[c.phone] = c;
  }

  Contact? findByPhone(String phone) => _byPhone[phone];

  List<Contact> search(String query) {
    final q = query.toLowerCase();
    final results =
        _byPhone.values.where((c) => c.name.toLowerCase().contains(q)).toList()
          ..sort(
            (a, b) => a.name.compareTo(b.name),
          ); // cascade `..` mutates in place
    return results;
  }

  bool delete(String phone) => _byPhone.remove(phone) != null;
  // List.unmodifiable creates a read-only view of an existing collection — the returned list cannot be modified, but the original list remains editable.
  List<Contact> getAll() => List.unmodifiable(_byPhone.values);
}

void main() {
  final book = ContactBook();
  book.add(Contact('Alice', '111', 'alice@mail.com'));
  book.add(Contact('Bob', '222')); // no email

  book.search('al').forEach(print);

  // ?. and ?? mirror Kotlin exactly
  final email = book.findByPhone('222')?.email ?? '(no email)';
  print("Bob's email: $email"); // (no email)

  book.delete('111');
  print('Total: ${book.getAll().length}'); // 1
}

enum TokenType { number, ident, plus, minus }

(String, TokenType) classify(String lexeme) => switch (lexeme) {
      '+' => (lexeme, TokenType.plus),
      '-' => (lexeme, TokenType.minus),
      _ when double.tryParse(lexeme) != null => (lexeme, TokenType.number),
      _ => (lexeme, TokenType.ident),
    };

void main() {
  for (final lexeme in ['+', '-', '42', 'name']) {
    final (value, type) = classify(lexeme);
    print('$value -> $type');
  }
}

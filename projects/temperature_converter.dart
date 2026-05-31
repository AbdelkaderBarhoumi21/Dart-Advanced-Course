import 'dart:io';

enum Scale { celsius, fahrenheit, kelvin }

// Dart switch expressions (Dart 3+) read like Kotlin's `when`
double toCelsius(double value, Scale from) => switch (from) {
  Scale.celsius => value,
  Scale.fahrenheit => (value - 32) * 5 / 9,
  Scale.kelvin => value - 273.15,
};

double fromCelsius(double celsius, Scale to) => switch (to) {
  Scale.celsius => celsius,
  Scale.fahrenheit => celsius * 9 / 5 + 32,
  Scale.kelvin => celsius + 273.15,
};

double convert(double value, Scale from, Scale to) =>
    fromCelsius(toCelsius(value, from), to);

Scale parseScale(String s) => switch (s.toUpperCase()) {
  'C' => Scale.celsius,
  'F' => Scale.fahrenheit,
  'K' => Scale.kelvin,
  _ => throw ArgumentError('Unknown scale: $s'),
};
// stdin = standard input = the stream that represents what the user types on the keyboard
// readLineSync() = reads an entire line up to the Enter key → returns a String (nullable)
// stdout.write("Value: "): Dart /// print("Value: ") (without ln): kotlin
void main(List<String> args) {
  stdout.write("Value: ");
  final value = double.parse(stdin.readLineSync()!); // ! asserts non-null
  stdout.write("From (C, F, K): ");
  final from = parseScale(stdin.readLineSync()!);
  stdout.write("To (C, F, K): ");
  final to = parseScale(stdin.readLineSync()!);
  final result = convert(value, from, to);
  print(
    '${value.toStringAsFixed(2)} $from = '
    '${result.toStringAsFixed(2)} $to',
  );
}

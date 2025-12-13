late String apiKey;

void initialize() {
  apiKey = 'abc123';
}

//Promotion
String? checkValue(String? input) {
  if (input == null) {
    return 'No value';
  }
  return input.toLowerCase();
}

void main() {
  print(checkValue(''));
}

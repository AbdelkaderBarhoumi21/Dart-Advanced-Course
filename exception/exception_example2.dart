void deepFunction() {
  throw Exception('Something went wrong'); // line 2
}

void middleFunction() {
  try {
    deepFunction();
  } catch (e) {
    rethrow; // You can see the error started at deepFunction line 2, the actual source!
  }
}

void main() {
  try {
    middleFunction();
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace); 
  }
}

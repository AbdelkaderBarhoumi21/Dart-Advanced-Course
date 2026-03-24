void deepFunction() {
  throw Exception('Something went wrong'); // line 2
}

void middleFunction() {
  try {
    deepFunction();
  } catch (e) {
    throw e; // Problem: You lost the information that the error originally came from deepFunction at line 2!
  }
}



void main() {
  try {
    middleFunction();
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace); // Where does the error point to?
  }
}

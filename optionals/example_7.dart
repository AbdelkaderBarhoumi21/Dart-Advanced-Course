void main(List<String> arg) {
  final String? name = null;
  try {
    print(name!); // this guarantee that this value is NOT null
  } catch (e) {
    print(e);
  }
}

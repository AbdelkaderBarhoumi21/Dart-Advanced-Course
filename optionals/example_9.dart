void main(List<String> args) {
  String? lastName;
  void changeLastName() {
    lastName = 'james';
  }

  changeLastName();
  if (lastName?.contains('james') ?? false) {
    print('Last name contains james-1');
  }

  if (lastName?.contains('james') == true) {
    print('Last name contains james-2');
  }
}

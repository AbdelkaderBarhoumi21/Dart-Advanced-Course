import 'dart:isolate';

Future<void> main() async {
  final numbers = List.generate(10000000, (i) => i);

  final sum = await Isolate.run(() {
    return numbers.reduce((a, b) => a + b);
  });

  print('Sum =$sum');
}

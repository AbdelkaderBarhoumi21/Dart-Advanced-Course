typedef Transformer<T> = T Function(T);

class Pipeline<T> {
  final List<Transformer<T>> _transformers = [];
  
  Pipeline<T> add(Transformer<T> transformer) {
    _transformers.add(transformer);
    return this;
  }
  
  T execute(T input) {
    var result = input;
    for (var transformer in _transformers) {
      result = transformer(result);
    }
    return result;
  }
  
  Pipeline<T> clone() {
    final newPipeline = Pipeline<T>();
    newPipeline._transformers.addAll(_transformers);
    return newPipeline;
  }
}

// Advanced: Composable validators
class DataProcessor {
  static String Function(String) trim() => (input) => input.trim();
  
  static String Function(String) lowercase() => (input) => input.toLowerCase();
  
  static String Function(String) removeSpecialChars() {
    return (input) => input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }
  
  static String Function(String) capitalize() {
    return (input) => input.isEmpty 
      ? input 
      : input[0].toUpperCase() + input.substring(1);
  }
  
  static String Function(String) truncate(int maxLength) {
    return (input) => input.length > maxLength 
      ? '${input.substring(0, maxLength)}...' 
      : input;
  }
}

// Usage
void main() {
  final processor = Pipeline<String>()
    ..add(DataProcessor.trim())
    ..add(DataProcessor.lowercase())
    ..add(DataProcessor.removeSpecialChars())
    ..add(DataProcessor.capitalize())
    ..add(DataProcessor.truncate(20));
  
  final result = processor.execute('  Hello, World! @#\$  ');
  print(result); // "Hello world"
  
  // Number pipeline
  final mathPipeline = Pipeline<int>()
    ..add((x) => x * 2)
    ..add((x) => x + 10)
    ..add((x) => x ~/ 3);
  
  print(mathPipeline.execute(5)); // (5*2+10)/3 = 6
}

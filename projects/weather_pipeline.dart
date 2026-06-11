import 'dart:async';
import 'dart:convert'; 
import 'dart:io';

class Weather {
  final String city;
  final double tempC;
  final String condition;
  Weather(this.city, this.tempC, this.condition);

  Map<String, dynamic> toJson() => {
    'city': city,
    'tempC': tempC,
    'condition': condition,
  };
}


sealed class Result<T> {}

class Ok<T> extends Result<T> {
  final T value;
  Ok(this.value);
}

class Err<T> extends Result<T> {
  final String message;
  Err(this.message);
}

// Strategy / Dependency Inversion
abstract class WeatherSource {
  Future<Weather> fetch(String city);
}

class FakeApiSource implements WeatherSource {
  @override
  Future<Weather> fetch(String city) async {
    await Future.delayed(Duration(milliseconds: 300)); // simulate latency
    if (city == 'Atlantis') throw StateError('City not found');
    return Weather(city, 15.0 + city.length, 'Sunny');
  }
}

class WeatherService {
  final WeatherSource source;
  WeatherService(this.source); // injection (DIP)

  // Fan out: Future.wait runs all fetches concurrently; each wrapped in a Result
  Future<List<Result<Weather>>> fetchAll(List<String> cities) {
    final futures = cities.map((city) async {
      try {
        return Ok<Weather>(await source.fetch(city));
      } catch (e) {
        return Err<Weather>(e.toString());
      }
    });
    return Future.wait(futures);
  }

  Future<void> cache(List<Result<Weather>> results, String path) async {
    final ok = results
        .whereType<Ok<Weather>>()
        .map((r) => r.value.toJson())
        .toList();
    final json = JsonEncoder.withIndent('  ').convert(ok);
    await File(path).writeAsString(json);
  }
}

Future<void> main() async {
  final service = WeatherService(FakeApiSource());
  final cities = ['Paris', 'Tokyo', 'Atlantis', 'Cairo'];

  final results = await service.fetchAll(cities);

  for (final r in results) {
    switch (r) {
      // exhaustive switch on sealed
      case Ok(value: final w):
        print('OK  ${w.city}: ${w.tempC.toStringAsFixed(1)}°C ${w.condition}');
      case Err(message: final m):
        print('ERR $m');
    }
  }

  await service.cache(results, 'weather_cache.json');
  final saved = results.whereType<Ok<Weather>>().length;
  print('Cached $saved cities to weather_cache.json');
}

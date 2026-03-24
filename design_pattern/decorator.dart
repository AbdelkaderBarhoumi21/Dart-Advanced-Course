import 'dart:io';
import 'dart:convert';

abstract class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint);
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body);
}

class HttpApiClient implements ApiClient {
  final String baseUrl;
  HttpApiClient(this.baseUrl);

  final HttpClient _client = HttpClient();

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = await _client.getUrl(uri);
      final response = await request.close();

      final responseBody = await response.transform(utf8.decoder).join();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = await _client.postUrl(uri);

      request.headers.set('Content-Type', 'application/json');
      request.write(jsonEncode(body));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  void close() {
    _client.close();
  }
}

// Decorator 1 - add logs

class LoggingApiClient implements ApiClient {
  final ApiClient _apiClient;

  LoggingApiClient(this._apiClient);

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    print('-> Get$endpoint');
    final result = await _apiClient.get(endpoint);
    print('<- Get$endpoint OK');
    return result;
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    print('→ POST $endpoint body=$body');
    final result = await _apiClient.post(endpoint, body);
    print('← POST $endpoint OK');
    return result;
  }
}

class CachingApiClient implements ApiClient {
  final ApiClient _client;
  final Map<String, Map<String, dynamic>> _cache = {};

  CachingApiClient(this._client);

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    if (_cache.containsKey(endpoint)) {
      print('Cache HIT: $endpoint');
      return _cache[endpoint]!;
    }
    final result = await _client.get(endpoint);
    _cache[endpoint] = result;
    return result;
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) {
    _cache.remove(endpoint);
    return _client.post(endpoint, body);
  }
}

class RetryApiClient implements ApiClient {
  final ApiClient _apiClient;
  final int maxRetries;
  RetryApiClient(this._apiClient, {this.maxRetries = 3});

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        return await _apiClient.get(endpoint);
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: i + 1));
        print('Retry ${i + 1}/$maxRetries pour $endpoint');
      }
    }
    throw Exception('Maximum retries reached');
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) {
    return _apiClient.post(endpoint, body); // no retying for POST
  }
}

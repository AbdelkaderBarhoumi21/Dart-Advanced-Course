class ParseException implements Exception {
  final String message;
  final String? path;
  
  ParseException(this.message, [this.path]);
  
  @override
  String toString() {
    final pathInfo = path != null ? ' at $path' : '';
    return 'ParseException: $message$pathInfo';
  }
}

class SafeParser {
  final Map<String, dynamic> _data;
  final String _path;
  
  SafeParser(this._data, [this._path = 'root']);
  
  T _getValue<T>(String key) {
    if (!_data.containsKey(key)) {
      throw ParseException(
        'Key "$key" not found',
        '$_path.$key',
      );
    }
    
    final value = _data[key];
    if (value is! T) {
      throw ParseException(
        'Expected type $T but got ${value.runtimeType}',
        '$_path.$key',
      );
    }
    
    return value;
  }
  
  String getString(String key) => _getValue<String>(key);
  
  int getInt(String key) {
    final value = _data[key];
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw ParseException(
      'Cannot convert to int',
      '$_path.$key',
    );
  }
  
  double getDouble(String key) {
    final value = _data[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw ParseException(
      'Cannot convert to double',
      '$_path.$key',
    );
  }
  
  bool getBool(String key) => _getValue<bool>(key);
  
  List<T> getList<T>(String key) {
    final value = _getValue<List>(key);
    return value.cast<T>();
  }
  
  SafeParser getObject(String key) {
    final value = _getValue<Map<String, dynamic>>(key);
    return SafeParser(value, '$_path.$key');
  }
  
  // Nullable versions
  String? getStringOrNull(String key) {
    try {
      return getString(key);
    } catch (_) {
      return null;
    }
  }
  
  int? getIntOrNull(String key) {
    try {
      return getInt(key);
    } catch (_) {
      return null;
    }
  }
  
  double? getDoubleOrNull(String key) {
    try {
      return getDouble(key);
    } catch (_) {
      return null;
    }
  }
  
  bool? getBoolOrNull(String key) {
    try {
      return getBool(key);
    } catch (_) {
      return null;
    }
  }
  
  List<T>? getListOrNull<T>(String key) {
    try {
      return getList<T>(key);
    } catch (_) {
      return null;
    }
  }
  
  SafeParser? getObjectOrNull(String key) {
    try {
      return getObject(key);
    } catch (_) {
      return null;
    }
  }
  
  // With defaults
  String getStringOr(String key, String defaultValue) {
    return getStringOrNull(key) ?? defaultValue;
  }
  
  int getIntOr(String key, int defaultValue) {
    return getIntOrNull(key) ?? defaultValue;
  }
  
  bool has(String key) => _data.containsKey(key);
}

// Example model using SafeParser
class UserProfile {
  final String id;
  final String name;
  final String email;
  final int age;
  final String? bio;
  final List<String> interests;
  final Address? address;
  
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.bio,
    required this.interests,
    this.address,
  });
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final parser = SafeParser(json);
    
    return UserProfile(
      id: parser.getString('id'),
      name: parser.getString('name'),
      email: parser.getString('email'),
      age: parser.getInt('age'),
      bio: parser.getStringOrNull('bio'),
      interests: parser.getList<String>('interests'),
      address: parser.has('address')
          ? Address.fromParser(parser.getObject('address'))
          : null,
    );
  }
}

class Address {
  final String street;
  final String city;
  final String country;
  final String? zipCode;
  
  Address({
    required this.street,
    required this.city,
    required this.country,
    this.zipCode,
  });
  
  factory Address.fromParser(SafeParser parser) {
    return Address(
      street: parser.getString('street'),
      city: parser.getString('city'),
      country: parser.getString('country'),
      zipCode: parser.getStringOrNull('zipCode'),
    );
  }
}

// Usage
void main() {
  final json = {
    'id': '123',
    'name': 'John Doe',
    'email': 'john@example.com',
    'age': '30', // String but will convert
    'interests': ['coding', 'reading'],
    'address': {
      'street': '123 Main St',
      'city': 'Paris',
      'country': 'France',
    }
  };
  
  try {
    final user = UserProfile.fromJson(json);
    print('User: ${user.name}, Age: ${user.age}');
    print('Interests: ${user.interests.join(", ")}');
  } on ParseException catch (e) {
    print('Parsing error: $e');
  }
}

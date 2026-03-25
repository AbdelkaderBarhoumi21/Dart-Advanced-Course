class User {
  User({required this.id, required this.name});
  final String id;
  final String name;
}

abstract class UserServices {
  Future<User> getUser(String id);
  Future<List<User>> getAllUsers();
}

class UserServicesImpl implements UserServices {
  @override
  Future<User> getUser(String id) async {
    print('HTTP GET /users/$id');
    await Future.delayed(const Duration(seconds: 1));
    return User(id: id, name: 'Abdelkader');
  }

  @override
  Future<List<User>> getAllUsers() async {
    print('HTTP GET /users');
    await Future.delayed(const Duration(seconds: 2));
    return [User(id: '1', name: 'Abdelkader'), User(id: '2', name: 'Ahmed')];
  }
}

class ProtectionProxy implements UserServices {
  ProtectionProxy(this._userServices, this._userRole);
  final UserServices _userServices;
  final String _userRole;

  @override
  Future<User> getUser(String id) async => await _userServices.getUser(id);

  @override
  Future<List<User>> getAllUsers() async {
    if (_userRole != 'admin') {
      throw Exception('Access denied');
    }

    return await _userServices.getAllUsers();
  }
}

class CacheProxy implements UserServices {
  CacheProxy(this._userServices);
  final UserServices _userServices;
  final Map<String, User> _cache = {};
  List<User>? _cachedAllUsers;

  @override
  Future<User> getUser(String id) async {
    if (_cache.containsKey(id)) {
      print('Cache HIT for user $id');
      return _cache[id]!;
    }
    print('MISS cache for user $id — HTTP call....');
    final user = await _userServices.getUser(id);
    _cache[id] = user;
    return user;
  }

  @override
  Future<List<User>> getAllUsers() async {
    if (_cachedAllUsers != null) {
      print('Cache HIT for getAllUsers');

      return _cachedAllUsers!;
    }
    final users = await _userServices.getAllUsers();
    _cachedAllUsers = users;
    return users;
  }

  void invalidate() => _cache.clear(); // clear cache
}

class LazyProxy implements UserServices {
  // service is not created at the start
  UserServices? _userServices;

  UserServices get _instance {
    _userServices ??= UserServicesImpl();
    print('user service has been created lazily');
    return _userServices!;
  }

  @override
  Future<User> getUser(String id) async => _instance.getUser(id);

  @override
  Future<List<User>> getAllUsers() async => _instance.getAllUsers();
}

void main() async {
  // Protection Proxy example
  final guestUser = ProtectionProxy(UserServicesImpl(), 'guest');
  final adminUser = ProtectionProxy(UserServicesImpl(), 'admin');
  await guestUser.getUser('1'); // Done
  try {
    await guestUser.getAllUsers(); // Exception
  } catch (e) {
    print('Error: $e');
  }
  await adminUser.getAllUsers(); // Done

  // Cache Proxy example
  final cacheProxy = CacheProxy(UserServicesImpl());
  await cacheProxy.getUser('1'); // MISS
  await cacheProxy.getUser('1'); // HIT
  await cacheProxy.getAllUsers(); // MISS
  await cacheProxy.getAllUsers(); // HIT

  // Lazy Proxy example
  final lazyProxy = LazyProxy();
  await lazyProxy.getUser('2'); // Creates service lazily
  await lazyProxy.getAllUsers(); // Uses already created service
}

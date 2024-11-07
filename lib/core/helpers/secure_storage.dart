import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SimpleChatSecureStorageKeys {
  static String tokenKey = 'secure_token';
}

class SimpleChatSecureStorage {
  late FlutterSecureStorage _storage;
  SimpleChatSecureStorage() {
    _storage = const FlutterSecureStorage();
  }

  Future<void> saveAuthorizationToken(String? token) async {
    if (token == null) return;
    await _storage.write(key: SimpleChatSecureStorageKeys.tokenKey, value: token);
  }

  Future<String?> readAuthorizationToken() async {
    return _storage.read(key: SimpleChatSecureStorageKeys.tokenKey);
  }

  Future<void> clearAuthorizationToken() async {
    await _storage.delete(key: SimpleChatSecureStorageKeys.tokenKey);
  }
}

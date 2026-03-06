import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static Future<void> remove(String key) {
    return _storage.remove(key);
  }

  static Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  static dynamic read(String key) {
    return _storage.read(key);
  }
}

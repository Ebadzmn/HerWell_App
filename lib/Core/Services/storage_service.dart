import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _box.write(AppConstants.tokenKey, token);
  }

  /// Get authentication token
  String? getToken() {
    return _box.read<String>(AppConstants.tokenKey);
  }

  /// Clear authentication token
  Future<void> clearToken() async {
    await _box.remove(AppConstants.tokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _box.write(AppConstants.refreshTokenKey, token);
  }

  /// Get refresh token
  String? getRefreshToken() {
    return _box.read<String>(AppConstants.refreshTokenKey);
  }

  /// Clear refresh token
  Future<void> clearRefreshToken() async {
    await _box.remove(AppConstants.refreshTokenKey);
  }

  /// Generic save method
  Future<void> writeData(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Generic read method
  T? readData<T>(String key) {
    return _box.read<T>(key);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _box.erase();
  }
}
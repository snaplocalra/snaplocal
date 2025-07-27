import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snap_local/utility/local_storage/model/local_storage.dart';
import 'package:snap_local/utility/local_storage/model/storage_keys_enum.dart';

class FlutterSecureStorageImpl implements LocalStorage {
  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  late FlutterSecureStorage storage =
      FlutterSecureStorage(aOptions: _getAndroidOptions());

  @override
  Future<bool> deleteKey(StorageKey key) async {
    try {
      await storage.delete(key: key.value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getKey(StorageKey key) async {
    try {
      return await storage.read(key: key.value);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveKey(StorageKey key, String value) async {
    try {
      await storage.write(key: key.value, value: value);
      return true;
    } catch (e) {
      return false;
    }
  }
}

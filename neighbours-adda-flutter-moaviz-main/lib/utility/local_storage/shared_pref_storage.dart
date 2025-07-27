import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_local/utility/local_storage/model/local_storage.dart';
import 'package:snap_local/utility/local_storage/model/storage_keys_enum.dart';

/// This class is responsible for storing the key-value pair in the shared preferences.
class SharedPrefKeyStorage implements LocalStorage {
  @override
  Future<bool> deleteKey(StorageKey key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(key.value);
  }

  @override
  Future<String?> getKey(StorageKey key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key.value);
  }

  @override
  Future<bool> saveKey(StorageKey key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(key.value, value);
  }
}

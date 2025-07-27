import 'package:snap_local/utility/local_storage/model/storage_keys_enum.dart';

/// This class is the implementation of the KeyStorage class.
abstract class LocalStorage {
  /// This method is responsible for saving the key and value.
  Future<void> saveKey(StorageKey key, String value);

  /// This method is responsible for getting the key.
  Future<String?> getKey(StorageKey key);

  /// This method is responsible for deleting the key.
  Future<void> deleteKey(StorageKey key);
}

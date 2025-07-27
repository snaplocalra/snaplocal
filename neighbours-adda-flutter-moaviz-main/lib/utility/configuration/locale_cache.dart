import 'package:snap_local/utility/local_storage/model/local_storage.dart';
import 'package:synchronized/synchronized.dart';

/// This class is responsible for caching the locale.
/// This class creates a singleton instance of the KeyStorage class.
/// This class represents a cache for storing the locale.
class LocaleCache {
  LocaleCache._(); // Private constructor to prevent direct instantiation.

  static LocalStorage? _instance; // Singleton instance of KeyStorage.
  static final _lock = Lock(); // Lock for thread safety.

  /// Initializes the LocaleCache with the provided KeyStorage instance.
  static Future<void> initialize(LocalStorage keyStorage) async {
    if (_instance == null) {
      await _lock.synchronized(() {
        _instance ??=
            keyStorage; // Assigns the keyStorage instance to _instance if it is null.
      });
    }
  }

  /// Returns the singleton instance of KeyStorage.
  static LocalStorage get instance {
    if (_instance == null) {
      throw Exception("LocaleCache is not initialized. Call initialize first.");
    }
    return _instance!;
  }
}

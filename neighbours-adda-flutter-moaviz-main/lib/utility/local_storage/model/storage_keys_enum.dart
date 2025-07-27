///This enum is used to define the storage keys.
enum StorageKey {
  /// The user id key.
  userId("user_id"),

  /// The email key.
  accessToken("access_token"),

  /// The theme key.
  theme("theme"),

  /// The user name key.
  userName("user_name"),

  /// The password key.
  password("password");

  /// The value of the storage key.
  final String value;
  const StorageKey(this.value);
}

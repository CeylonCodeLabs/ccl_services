part of 'secure_storage_service.dart';

/// A service that provides access to secure storage.
abstract class ISecureStorageService implements InitializableDependency {
  /// Returns the underlying [FlutterSecureStorage] instance.
  FlutterSecureStorage get instance;

  /// Initializes the service by creating accessors for device ID and locale.
  @override
  Future<void> init();

  /// Logs the user out by clearing all data from secure storage except the device ID.
  /// List keys to retain in secure storage.
  Future<void> logout([List<String>? keys]);

  /// Clears all data from secure storage.
  Future<void> clearAll();
}

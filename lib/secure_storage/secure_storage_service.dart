part of '../ccl_services.dart';

/// A service that provides access to secure storage.
class SecureStorageService extends SecureStorageInstance
    implements InitializableDependency {
  /// Logging tag for this service.
  // ignore: constant_identifier_names
  static const TAG = 'SecureStorageService';

  /// Accessor for device ID in secure storage.
  late final SSDeviceId deviceId;

  /// Accessor for locale in secure storage.
  late final SSLocale locale;

  /// Returns the underlying [FlutterSecureStorage] instance.
  @override
  FlutterSecureStorage get instance => defaultInstance;

  /// Initializes the service by creating accessors for device ID and locale.
  @override
  Future<void> init() async {
    deviceId = SSDeviceId(instance);
    locale = SSLocale(instance);
  }

  /// Logs the user out by clearing all data from secure storage except the device ID.
  Future<void> logout() async {
    final deviceId = await this.deviceId.read();
    await clearAll();
    await this.deviceId.set(deviceId);
  }

  /// Clears all data from secure storage.
  Future<void> clearAll() => instance.deleteAll();
}
part of '../services.dart';

/// A service that provides access to secure storage.
class SecureStorageService extends SecureStorageInstance
    implements ISecureStorageService {
  /// Logging tag for this service.
  // ignore: constant_identifier_names
  static const TAG = 'SecureStorageService';

  /// Accessor for device ID in secure storage.
  late final SSObject<String> deviceId;

  /// Returns the underlying [FlutterSecureStorage] instance.
  @override
  FlutterSecureStorage get instance => defaultInstance;

  /// Initializes the service by creating accessors for device ID and locale.
  @override
  Future<void> init() async {
    deviceId = SSObject('device_id', instance);
  }

  /// Logs the user out by clearing all data from secure storage except the device ID.
  @override
  Future<void> logout() async {
    final deviceId = await this.deviceId.read();
    await clearAll();
    await this.deviceId.set(deviceId);
  }

  /// Clears all data from secure storage.
  @override
  Future<void> clearAll() => instance.deleteAll();
}
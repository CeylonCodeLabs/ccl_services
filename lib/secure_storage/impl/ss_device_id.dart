part of '../../ccl_services.dart';

/// A helper class for accessing the device ID in secure storage.
class SSDeviceId extends SecureStorageHelper<String> {
  /// Creates a new [SSDeviceId] instance.
  SSDeviceId(super.instance);

  /// The key used to store the device ID in secure storage.
  @override
  String get key => 'device_id';

  /// Converts a string value from storage to a device ID.
  @override
  String stringToValue(String value) => value;

  /// Converts a device ID to a string for storage.
  @override
  String valueToString(String value) => value;
}
part of '../../ccl_services.dart';

/// A helper class for accessing the locale in secure storage.
class SSLocale extends SecureStorageHelper<String> {
  /// Creates a new [SSLocale] instance.
  SSLocale(super.instance);

  /// The key used to store the locale in secure storage.
  @override
  String get key => 'locale';

  /// Converts a string value from storage to a locale string.
  @override
  String stringToValue(String value) => value;

  /// Converts a locale string to a string for storage.
  @override
  String valueToString(String value) => value;
}

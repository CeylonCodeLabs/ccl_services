part of '../../ccl_services.dart';

/// A helper class for accessing typed values in secure storage.
abstract class SecureStorageHelper<T> implements ISecureStorage<T> {
  /// Logging tag for this helper.
  // ignore: constant_identifier_names
  static const String TAG = 'SecureStorageHelper';

  /// The underlying [FlutterSecureStorage] instance.
  final FlutterSecureStorage _instance;

  /// Creates a new [SecureStorageHelper] instance.
  SecureStorageHelper(this._instance);

  /// Sets the value in secure storage.
  ///
  /// If [value] is null, the value is removed from storage.
  Future<T?> set(T? value) async {
    if (value == null) {
      await remove();
    } else {
      await _instance.write(key: key, value: valueToString(value));
    }
    return value;
  }

  /// Removes the value from secure storage.
  Future<void> remove() => _instance.delete(key: key);

  /// Reads the value from secure storage.
  ///
  /// Returns null if the value is not found or cannot be converted.
  Future<T?> read() async {
    final args = await _instance.read(key: key);
    if (args.isNotNullOrEmpty) {
      return stringToValue(args!);
    }
    return null;
  }
}
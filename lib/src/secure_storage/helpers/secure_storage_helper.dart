part of '../secure_storage_service.dart';

/// A helper class for accessing typed values in secure storage.
abstract class SecureStorageHelper<T> implements ISecureStorage<T> {
  /// Logging tag for this helper.
  // ignore: constant_identifier_names
  static const String TAG = 'SecureStorageHelper';

  /// The underlying [FlutterSecureStorage] instance.
  final FlutterSecureStorage _instance;

  /// A [BehaviorSubject] to stream the current value of the stored data.
  final BehaviorSubject<T?> _valueSubject;

  /// Creates a new [SecureStorageHelper] instance.
  ///
  /// Initializes the [_valueSubject] with the initial value from storage.
  SecureStorageHelper(this._instance) : _valueSubject = BehaviorSubject<T?>() {
    _initialize();
  }

  /// Initializes the [_valueSubject] with the initial value from storage.
  Future<void> _initialize() async {
    final initialValue = await read();
    _valueSubject.add(initialValue);
  }

  /// Sets the value in secure storage.
  ///
  /// If [value] is null, the value is removed from storage.
  Future<T?> set(T? value) async {
    if (value == null) {
      await remove();
    } else {
      await _instance.write(key: key, value: valueToString(value));
      _valueSubject.add(value);
    }
    return value;
  }

  /// Removes the value from secure storage.
  Future<void> remove() async {
    await _instance.delete(key: key);
    _valueSubject.add(null);
  }

  /// Reads the value from secure storage.
  ///
  /// Returns null if the value is not found or cannot be converted.
  Future<T?> read() async {
    final args = await _instance.read(key: key);
    if (args.isNotNullAndNotEmpty) {
      final value = stringToValue(args!);
      _valueSubject.add(value);
      return value;
    }
    return null;
  }

  /// Returns a [Stream] that emits the current value of the stored data.
  /// Make sure to call [StreamSubscription.cancel] when you are done with the stream.
  StreamSubscription<T?> listen(ValueChanged<T?> listener) =>
      _valueSubject.listen(listener);
}

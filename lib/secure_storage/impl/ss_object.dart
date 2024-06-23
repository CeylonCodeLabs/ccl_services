part of '../../ccl_services.dart';

/// A class that extends `SecureStorageHelper` and provides functionality for storing and retrieving objects of a generic type `T` in secure storage.

class SSObject<T> extends SecureStorageHelper<T> {
  /// The key used to store and retrieve the object in secure storage.
  final String _key;

  /// Creates an instance of `SSObject` with a specified key and the instance from the superclass.
  SSObject(this._key, super.instance);

  /// Gets the key used for storing and retrieving the object.
  @override
  String get key => _key;

  /// Converts a String value from secure storage to the generic type `T`.
  ///
  /// This method supports basic type conversions for `String`, `int`, `double`, `num`, `bool`, `List`, and `Map`.
  /// If the type `T` is not one of these types, an `UnimplementedError` is thrown. You can override this method to handle custom types.
  @override
  T stringToValue(String value) {
    if (T is String) {
      return value as T;
    } else if (T is int) {
      return int.parse(value) as T;
    } else if (T is double) {
      return double.parse(value) as T;
    } else if (T is num) {
      return num.parse(value) as T;
    } else if (T is bool) {
      return bool.parse(value) as T;
    } else if (T is List) {
      return jsonDecode(value) as T;
    } else if (T is Map) {
      return jsonDecode(value) as T;
    } else {
      throw UnimplementedError(
          '${value.runtimeType} cannot be handled. Please override stringToValue method.');
    }
  }

  /// Converts a value of type `T` to a String for storing in secure storage.
  ///
  /// This method supports basic type conversions for `String`, `int`, `double`, `num`, `bool`, `List`, and `Map`.
  /// If the type `T` is not one of these types, an `UnimplementedError` is thrown. You can override this method to handle custom types.
  @override
  String valueToString(T value) {
    if (T is String) {
      return value as String;
    } else if (T is int) {
      return (value as int).toString();
    } else if (T is double) {
      return (value as double).toString();
    } else if (T is num) {
      return (value as num).toString();
    } else if (T is bool) {
      return (value as bool).toString();
    } else if (T is List) {
      return jsonEncode(value);
    } else if (T is Map) {
      return jsonEncode(value);
    } else {
      throw UnimplementedError(
          '${value.runtimeType} cannot be handled. Please override valueToString method.');
    }
  }
}


part of '../../services.dart';

/// A class that extends `SecureStorageHelper` and provides functionality for storing and retrieving objects of a generic type `T` in secure storage.
///
/// This class supports basic type conversions for `String`, `int`, `double`, `num`, `bool`, `List`, and `Map`.
/// If you need to store custom types, you might need to override the `stringToValue` and `valueToString` methods.
class SSObject<T> extends SecureStorageHelper<T> {
  /// The key used to store and retrieve the object in secure storage.
  final String _key;

  /// Creates an instance of `SSObject` with a specified key and the instance from the superclass.
  SSObject(this._key, super.instance);

  @override
  String get key => _key;

  /// Converts a String value from secure storage to the generic type `T`.
  ///
  /// This method supports basic type conversions for `String`, `int`, `double`, `num`, `bool`, `List`, and `Map`.
  /// If the type `T` is not one of these types, an `UnimplementedError` is thrown.
  @override
  T stringToValue(String value) {
    final type = _typeOf<T>();
    if (type == String) {
      return value as T;
    } else if (type == int) {
      return int.parse(value) as T;
    } else if (type == double) {
      return double.parse(value) as T;
    } else if (type == num) {
      return num.parse(value) as T;
    } else if (type == bool) {
      return bool.parse(value) as T;
    } else if (type == List) {
      return jsonDecode(value) as T;
    } else if (type == Map) {
      return jsonDecode(value) as T;
    } else {
      throw UnimplementedError(
          '${type.runtimeType} cannot be handled. Please override stringToValue method.');
    }
  }

  /// Converts a value of type `T` to a String for storing in secure storage.
  ///
  /// This method supports basic type conversions for `String`, `int`, `double`, `num`, `bool`, `List`, and `Map`.
  /// If the type `T` is not one of these types, an `UnimplementedError` is thrown.
  @override
  String valueToString(T value) {
    final type = _typeOf<T>();
    if (type == String) {
      return value as String;
    } else if (type == int) {
      return (value as int).toString();
    } else if (type == double) {
      return (value as double).toString();
    } else if (type == num) {
      return (value as num).toString();
    } else if (type == bool) {
      return (value as bool).toString();
    } else if (type == List) {
      return jsonEncode(value);
    } else if (type == Map) {
      return jsonEncode(value);
    } else {
      throw UnimplementedError(
          '${type.runtimeType} cannot be handled. Please override valueToString method.');
    }
  }

  Type _typeOf<X>() => X;
}

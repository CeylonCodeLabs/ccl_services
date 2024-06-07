part of '../../ccl_services.dart';

/// An interface for accessing typed values in secure storage.
abstract class ISecureStorage<T> {
  /// The key used to store the value in secure storage.
  String get key => throw UnimplementedError();

  /// Converts a value of type [T] to a string for storage.
  @protected
  String valueToString(T value) => throw UnimplementedError();

  /// Converts a string value from storage to a value of type [T].
  @protected
  T stringToValue(String value) => throw UnimplementedError();
}
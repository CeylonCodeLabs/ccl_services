part of '../../ccl_services.dart';

/// An abstract class that provides a base for secure storage implementations.
abstract class SecureStorageInstance {
  /// The default [FlutterSecureStorage] instance with encryption enabled.
  @protected
  final FlutterSecureStorage defaultInstance = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm:
      KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
  );

  /// The [FlutterSecureStorage] instance to use for storage operations.
  @protected
  FlutterSecureStorage get instance;
}
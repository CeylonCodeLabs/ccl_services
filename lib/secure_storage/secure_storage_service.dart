import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_support_pack/flutter_support_pack.dart';
import 'package:stacked/stacked_annotations.dart';

part 'i_secure_storage_service.dart';
part 'impl/ss_object.dart';
part 'helpers/i_secure_storage.dart';
part 'helpers/secure_storage_instance.dart';
part 'helpers/secure_storage_helper.dart';

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

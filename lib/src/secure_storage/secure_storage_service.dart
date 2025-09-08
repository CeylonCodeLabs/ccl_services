import 'dart:async';
import 'dart:convert';

import 'package:ccl_core/ccl_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked_annotations.dart';

part 'helpers/i_secure_storage.dart';
part 'helpers/secure_storage_helper.dart';
part 'helpers/secure_storage_instance.dart';
part 'i_secure_storage_service.dart';
part 'impl/ss_object.dart';

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

  /// Logs the user out by clearing all data from secure storage except the [keys] provided.
  /// [keys] are the keys to retain in secure storage. If not provided, the device ID is retained.
  @override
  Future<void> logout([List<String>? keys]) async {
    final keysToRetain = keys ?? [deviceId.key];

    final allKeys = await instance.readAll();

    for (final key in allKeys.keys) {
      if (!keysToRetain.contains(key)) {
        await instance.delete(key: key);
      }
    }
  }

  /// Clears all data from secure storage.
  @override
  Future<void> clearAll() => instance.deleteAll();
}

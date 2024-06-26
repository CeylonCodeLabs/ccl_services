library ccl_services;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_support_pack/flutter_support_pack.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

part 'secure_storage/helpers/secure_storage_helper.dart';

part 'secure_storage/helpers/i_secure_storage.dart';

part 'secure_storage/helpers/secure_storage_instance.dart';

part 'secure_storage/secure_storage_service.dart';

part 'secure_storage/i_secure_storage_service.dart';

part 'secure_storage/impl/ss_object.dart';

part 'localization/localization_service.dart';

part 'localization/i_localization_service.dart';

typedef OnLocaleChanged = Future<void> Function(Locale locale);

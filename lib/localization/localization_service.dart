part of '../ccl_services.dart';

/// A service that manages the application's locale.
class LocalizationService
    with ListenableServiceMixin
    implements ILocalizationService {
  /// Logging tag for this service.
  // ignore: constant_identifier_names
  static const String TAG = 'LocalizationService';

  final String _prefKey = 'ccl_locale';

  /// The secure storage service used to persist the locale.
  late final SharedPreferences _pref;

  /// The current locale.
  late final ReactiveValue<Locale> _locale;

  /// The fallback locale to use if no locale is saved in secure storage.
  Locale? _fallbackLocale;

  /// The list of supported locales.
  List<Locale>? _supportedLocales;

  /// Initializes the service by loading the locale from secure storage.
  @override
  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    final locale = await _getLocale();
    _locale = ReactiveValue(locale);
  }

  @override
  void config({Locale? fallbackLocale, List<Locale>? supportedLocales}) {
    _fallbackLocale = fallbackLocale;
    _supportedLocales = supportedLocales;
  }

  /// The current locale.
  @override
  Locale get locale => _locale.value;

  /// A stream of locale changes.
  @override
  Stream<Locale> get localeChanges => _locale.values;

  /// Updates the current locale and persists it to secure storage.
  @override
  Future<void> setLocale(Locale locale) async {
    await _pref.setString(_prefKey, locale.languageCode);
    _locale.value = locale;
    notifyListeners();
  }

  /// Gets the locale from secure storage or returns a fallback locale.
  Future<Locale> _getLocale() async {
    final savedLocale = _pref.getString(_prefKey);

    if (savedLocale.isNotNullOrEmpty) {
      return Locale(savedLocale!);
    }

    if (_fallbackLocale != null) {
      return _fallbackLocale!;
    }

    if (_supportedLocales.isListNotEmptyOrNull) {
      return _supportedLocales!.first;
    }

    return Locale(Intl.getCurrentLocale());
  }
}

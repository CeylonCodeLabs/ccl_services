part of '../ccl_services.dart';

/// A service that manages the application's locale.
class LocalizationService
    with ListenableServiceMixin
    implements InitializableDependency {
  /// Logging tag for this service.
  // ignore: constant_identifier_names
  static const String TAG = 'LocalizationService';

  /// The secure storage service used to persist the locale.
  final SecureStorageService _secureStorageService =
      StackedLocator.instance.get();

  /// The fallback locale to use if no locale is saved in secure storage.
  final Locale? _fallbackLocale;

  /// The list of supported locales.
  final List<Locale>? _supportedLocales;

  /// The current locale.
  late final ReactiveValue<Locale> _locale;

  /// Creates a new `LocalizationService`.
  ///
  /// The [fallbackLocale] is used if no locale is saved in secure storage.
  /// The [supportedLocales] is a list of locales that the app supports.
  LocalizationService({
    @factoryParam Locale? fallbackLocale,
    @factoryParam List<Locale>? supportedLocales,
  })  : _fallbackLocale = fallbackLocale,
        _supportedLocales = supportedLocales;

  /// Initializes the service by loading the locale from secure storage.
  @override
  Future<void> init() async {
    final locale = await _getLocale();
    _locale = ReactiveValue(locale);
  }

  /// The current locale.
  Locale get locale => _locale.value;

  /// A stream of locale changes.
  Stream<Locale> get localeChanges => _locale.values;

  /// Updates the current locale and persists it to secure storage.
  Future<void> setLocale(Locale locale) async {
    await _secureStorageService.locale.set(locale.languageCode);
    _locale.value = locale;
    notifyListeners();
  }

  /// Gets the locale from secure storage or returns a fallback locale.
  Future<Locale> _getLocale() async {
    final savedLocale = await _secureStorageService.locale.read();

    if (savedLocale.isNotNullOrEmpty) {
      return Locale(savedLocale!);
    }

    if (_fallbackLocale != null) {
      return _fallbackLocale;
    }

    if (_supportedLocales.isListNotEmptyOrNull) {
      return _supportedLocales!.first;
    }

    return Locale(Intl.getCurrentLocale());
  }
}

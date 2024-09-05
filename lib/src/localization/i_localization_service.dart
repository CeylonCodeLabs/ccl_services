part of 'localization_service.dart';

/// A service that manages the application's locale.
abstract class ILocalizationService implements InitializableDependency {
  /// Initializes the service by loading the locale from secure storage.
  @override
  Future<void> init();

  /// The current locale.
  Locale get locale;

  /// A stream of locale changes.
  Stream<Locale> get localeChanges;

  void config({Locale? fallbackLocale, List<Locale>? supportedLocales});

  /// Updates the current locale and persists it to secure storage.
  Future<void> setLocale(Locale locale);

  bool get isSaved;
}

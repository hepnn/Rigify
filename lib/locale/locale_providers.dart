import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_state.dart';
import 'platform_locale/platform_locale_interface.dart';

/// Platform Locale Provider
/// Returns the locale of the Platform.localeName
final platformLocaleProvider = Provider<Locale>((_) {
  // Get the platform language using platform specific implementations
  Locale platformLocale = PlatformLocale().getPlatformLocale();

  print("Retrieved platform locale: $platformLocale");

  return platformLocale;
});

/// Supported Locales Provider
/// Update this list to expand the number of supported locales in the app
final supportedLocalesProvider = Provider<List<Locale>>((_) {
  return const [
    Locale('en', 'US'),
    Locale('lv', 'LV'),
  ];
});

/// Locale Provider
/// Provides the current locale, and automatically updates when the locale changes.
final localeProvider = Provider<Locale>((ref) {
  return ref.watch(localeStateProvider).locale;
});

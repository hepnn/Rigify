import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';
import 'package:rigify/ads/ads_controller.dart';
import 'package:rigify/app/bus_data/data_api.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app_entry.dart';
import 'package:rigify/in_app_purchases/ad_removal_state.gen.dart';
import 'package:rigify/in_app_purchases/in_app_purchase.dart';
import 'package:rigify/locale/locale_providers.dart';
import 'package:rigify/theme/config/theme.dart';
import 'package:rigify/theme/theme_mode_state.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught errors from the Flutter framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  guardedMain();
}

void guardedMain() async {
  if (kReleaseMode) {
    // Don't log anything below warnings in production.
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: '
        '${record.loggerName}: '
        '${record.message}');
  });

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  Hive.registerAdapter(RouteTypeAdapter());
  await Hive.openBox<RouteType>('favorites');
  await Hive.openBox<RouteType>('recentRoutes');
  await Hive.openBox('prefs');

  await fetchData(); // TODO: Refactor

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

final Box<RouteType> favoritesBox = Hive.box<RouteType>('favorites');

Logger _log = Logger('main.dart');

final adsControllerProvider =
    (!kIsWeb && (Platform.isIOS || Platform.isAndroid))
        ? Provider<AdsController>(
            (ref) => AdsController(MobileAds.instance)..initialize())
        : null;

final inAppPurchaseControllerProvider = (!kIsWeb &&
        (Platform.isIOS || Platform.isAndroid))
    ? StateNotifierProvider<InAppPurchaseController, AdRemovalPurchaseState>(
        (ref) => InAppPurchaseController(InAppPurchase.instance)
          ..subscribe()
          ..restorePurchases(),
      )
    : null;

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Locale> _supportedLocales = ref.read(supportedLocalesProvider);

    // Watch the current locale and rebuild on change
    Locale _locale = ref.watch(localeProvider);
    _log.info("Rebuilding with watched locale: $_locale");

    FlutterNativeSplash.remove();

    final ThemeModeState currentTheme = ref.watch(themeProvider);

    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: _supportedLocales,
      themeMode: currentTheme.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: _locale,
      useInheritedMediaQuery: true,
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode ||
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: const AppEntry(),
    );
  }
}

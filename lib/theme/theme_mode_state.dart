import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final AutoDisposeChangeNotifierProvider<ThemeModeState> themeProvider =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<ThemeModeState> ref) {
  return ThemeModeState();
});

class ThemeModeState extends ChangeNotifier {
  ThemeModeState() {
    final String mode = Hive.box('prefs')
        .get('themeMode', defaultValue: ThemeMode.system.toString()) as String;
    switch (mode) {
      case 'ThemeMode.dark':
        themeMode = ThemeMode.dark;
        break;
      case 'ThemeMode.light':
        themeMode = ThemeMode.light;
        break;
      case 'ThemeMode.system':
        themeMode = ThemeMode.system;
        break;
    }
  }

  ThemeMode? themeMode;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      var brightness = MediaQueryData.fromView(WidgetsBinding.instance.window)
          .platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    Hive.box('prefs').put('themeMode', themeMode.toString());
    notifyListeners();
  }
}

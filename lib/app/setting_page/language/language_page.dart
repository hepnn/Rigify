import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/locale/locale_providers.dart';
import 'package:rigify/locale/locale_state.dart';
import 'package:rigify/locale/locale_translate_name.dart';
import 'package:rigify/theme/theme_mode_state.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Locale> supportedLocales = ref.read(supportedLocalesProvider);

    return Material(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: supportedLocales.length,
          itemBuilder: (context, i) {
            return _SwitchListTileMenuItem(
              title: translateLocaleName(locale: supportedLocales[i]),
              subtitle: translateLocaleName(locale: supportedLocales[i]),
              locale: supportedLocales[i],
              onTap: () {
                ref
                    .read(localeStateProvider.notifier)
                    .setLocale(supportedLocales[i]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _SwitchListTileMenuItem extends ConsumerWidget {
  const _SwitchListTileMenuItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Locale locale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale _currentLocale = ref.watch(localeProvider);
    bool isSelected(BuildContext context) => locale == _currentLocale;
    final ThemeModeState currentTheme = ref.watch(themeProvider);

    Brightness brightness;

    if (currentTheme.themeMode == ThemeMode.system) {
      brightness = MediaQuery.of(context).platformBrightness;
    } else {
      brightness = currentTheme.themeMode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light;
    }

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
        border: isSelected(context)
            ? Border.all(
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black)
            : null,
      ),
      child: ListTile(
        dense: true,
        title: Text(
          title,
        ),
        subtitle: Text(
          subtitle,
        ),
        onTap: onTap,
      ),
    );
  }
}

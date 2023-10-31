import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/locale/locale_providers.dart';
import 'package:rigify/locale/locale_state.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Locale> supportedLocales = ref.read(supportedLocalesProvider);
    Locale currentLocale = ref.watch(localeProvider);

    return Card(
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(12),
        onPressed: (int index) {
          ref
              .read(localeStateProvider.notifier)
              .setLocale(supportedLocales[index]);
        },
        isSelected: [
          currentLocale == supportedLocales[0],
          currentLocale == supportedLocales[1],
        ],
        children: const [
          Tooltip(
            message: 'EN',
            child: Text('EN'),
          ),
          Tooltip(
            message: 'LV',
            child: Text('LV'),
          ),
        ],
      ),
    );
  }
}

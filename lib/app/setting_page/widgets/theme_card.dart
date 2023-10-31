import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/theme/theme_mode_state.dart';

class ThemeCard extends ConsumerWidget {
  const ThemeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState state = ref.watch(themeProvider);

    return Card(
      child: LayoutBuilder(builder: (context, constraints) {
        // 3 is number of toggle children
        final toggleWidth = (constraints.maxWidth - (3 + 1)) / 3;

        return ToggleButtons(
          constraints: BoxConstraints.expand(
            width: toggleWidth,
          ),
          borderRadius: BorderRadius.circular(12),
          onPressed: (int index) {
            ref
                .read(themeProvider.notifier)
                .setThemeMode(ThemeMode.values[index]);
          },
          isSelected: [
            state.themeMode == ThemeMode.system,
            state.themeMode == ThemeMode.light,
            state.themeMode == ThemeMode.dark,
          ],
          children: const [
            Tooltip(
              message: 'System',
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.contrast,
                  size: 32,
                ),
              ),
            ),
            Tooltip(
              message: 'Light',
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.sunny,
                  size: 32,
                ),
              ),
            ),
            Tooltip(
              message: 'Dark',
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.nightlight_round,
                  size: 32,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/theme/theme_mode_state.dart';

// home screen transport selection card

class GridItem extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final String? title;
  final Color? iconColor;
  final VoidCallback? onTap;

  const GridItem({
    super.key,
    this.color,
    this.icon,
    this.onTap,
    this.title,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color ?? Theme.of(context).cardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(
                icon,
                color: iconColor,
                size: 60,
              ),
            ),
            Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class MapGridItem extends ConsumerWidget {
  final VoidCallback onTap;

  const MapGridItem({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeProvider);
    final isDark = theme.isDarkMode;
    final mapAsset = isDark ? 'map.png' : 'map_light.png';
    final mapOpacity = isDark ? 0.3 : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(mapOpacity),
            image: DecorationImage(
              fit: BoxFit.fill,
              opacity: 0.3,
              image: AssetImage(
                'assets/app_assets/$mapAsset',
              ),
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  Icons.map,
                  color: Colors.grey,
                  size: 60,
                ),
              ),
              Text(
                'Realtime Map',
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}

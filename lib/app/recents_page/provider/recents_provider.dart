import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rigify/app/bus_data/route.dart';

final recentRoutesProvider =
    StateNotifierProvider<RecentRoutesNotifier, List<RouteType>>(
        (ref) => RecentRoutesNotifier());

class RecentRoutesNotifier extends StateNotifier<List<RouteType>> {
  RecentRoutesNotifier() : super([]);

  void addRoute(RouteType route) {
    if (!state.contains(route)) {
      state = [...state, route];

      if (state.length > 5) {
        state.removeAt(0);
      }

      saveRoutesToHive(state);
    }
  }

  void saveRoutesToHive(List<RouteType> routes) async {
    final box = await Hive.openBox<RouteType>('recentRoutes');

    box.clear();
    box.addAll(routes);
  }

  void loadRoutesFromHive() async {
    final box = await Hive.openBox<RouteType>('recentRoutes');
    state = box.values.toList();
  }
}

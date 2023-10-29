import 'package:flutter/material.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/utils/parse_routes_data.dart';
import 'package:rigify/app/components/route_tile.dart';

class NumList extends StatelessWidget {
  const NumList(this._transport, {Key? key}) : super(key: key);
  final String? _transport;

  @override
  Widget build(BuildContext context) {
    final List<RouteType> routes = filterRoutes(_transport);
    return ListView.separated(
      padding:
          const EdgeInsets.only(top: 13.0, left: 13.0, right: 13.0, bottom: 24),
      itemCount: routes.length,
      itemBuilder: (context, i) {
        final RouteType route = routes[i];
        return RouteTile(route);
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 5,
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/stop.dart';
import 'package:rigify/app/bus_data/utils/parse_routes_data.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';
import 'package:rigify/app/time_page/time_page.dart';

class TripPage extends StatelessWidget {
  const TripPage(this._route, this._stop, this._weekdays, this._index,
      {super.key});
  final RouteType? _route;
  final String? _weekdays;
  final Stop? _stop;
  final int _index;

  @override
  Widget build(BuildContext context) {
    final Map<String?, String> times = getTrip(_route!, _weekdays, _index);
    return Scaffold(
      appBar: AppBar(
        elevation: Platform.isIOS ? 0 : 4,
        backgroundColor: colors[_route.transport!],
        title: Text(
          _route.name!,
        ),
      ),
      body: ListView.builder(
        itemCount: _route.stops.length,
        itemBuilder: (_, i) {
          final Stop stop = _route.stops[i];
          return GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => TimePage(_route, stop))),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 70,
                    child: Text(
                      times[stop.id]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      stop.name!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: stop.id == _stop!.id
                            ? FontWeight.w900
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/stop.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';
import 'package:rigify/app/time_page/time_page.dart';
import 'package:rigify/main.dart';
import 'package:timelines/timelines.dart';

class _StopsPageState extends State<StopsPage> {
  _StopsPageState(this._route);
  RouteType? _route;

  // Box? box = Hive.box('favorites');

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    setState(() => _route);
    _route = routes[_route!.getKeyForType(_route!.type)];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, RouteType> similarRoutes = Map.from(routes)
      ..removeWhere((k, _) {
        return !k.contains(RegExp('^${_route!.number};${_route!.transport}'));
      });

    final String oppositeRoute =
        _route!.getKeyForType(_route!.type!.split('-').reversed.join('-'));
    final List<Stop> stops = _route!.stops;
    final bool openModel =
        similarRoutes.length > (routes.containsKey(oppositeRoute) ? 2 : 1);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: Platform.isIOS ? 0 : 4,
        backgroundColor: colors[_route!.transport!],
        title: openModel
            ? InkWell(
                child: Text(
                  _route!.name!,
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (c) => ListView(
                          children: similarRoutes.values
                              .map((route) => ListTile(
                                    title: Text(route.name!),
                                    onTap: () {
                                      setState(() => _route = routes[
                                          _route!.getKeyForType(route.type)]);
                                      Navigator.pop(c);
                                    },
                                  ))
                              .toList()));
                },
              )
            : Text(
                _route!.name!,
              ),
        actions: routes.containsKey(oppositeRoute)
            ? [
                IconButton(
                  icon: Icon(
                      favoritesBox.containsKey(_route!.name)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: Colors.white),
                  onPressed: () async {
                    setState(() {
                      _isFavorite = !_isFavorite;
                      if (_isFavorite) {
                        favoritesBox.put(_route!.name, _route!);
                      } else {
                        favoritesBox.delete(_route!.name);
                      }
                    });
                  },
                ),
                AnimatedSwapVert(
                  onPressed: () {
                    setState(() {
                      _route = routes[oppositeRoute];
                    });
                  },
                )
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
        child: Timeline.tileBuilder(
          theme: TimelineThemeData(
              color: colors[_route!.transport!],
              nodePosition: 0,
              connectorTheme:
                  const ConnectorThemeData(space: 30.0, thickness: 2)),
          builder: TimelineTileBuilder.connectedFromStyle(
            connectionDirection: ConnectionDirection.after,
            connectorStyleBuilder: (context, index) {
              return ConnectorStyle.solidLine;
            },
            indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
            itemExtent: 60,
            itemCount: stops.length,
            contentsBuilder: (context, i) {
              final Stop stop = stops[i];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity / 2,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TimePage(_route, stop),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        stop.name!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class StopsPage extends StatefulWidget {
  const StopsPage(this._route, {Key? key}) : super(key: key);
  final RouteType _route;

  @override
  _StopsPageState createState() => _StopsPageState(_route);
}

class AnimatedSwapVert extends StatefulWidget {
  final VoidCallback onPressed;
  const AnimatedSwapVert({super.key, required this.onPressed});

  @override
  State<AnimatedSwapVert> createState() => _AnimatedSwapVertState();
}

class _AnimatedSwapVertState extends State<AnimatedSwapVert>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(pi * _animationController.value),
            child: const Icon(Icons.swap_vert),
          );
        },
      ),
      onPressed: () {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {});
        });
        widget.onPressed();
      },
    );
  }
}

class AnimatedRefreshIcon extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedRefreshIcon({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AnimatedRefreshIconState createState() => _AnimatedRefreshIconState();
}

class _AnimatedRefreshIconState extends State<AnimatedRefreshIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Transform.rotate(
            angle: _animationController.value * 4 * 3.14159265359,
            child: const Icon(Icons.refresh),
          );
        },
      ),
      onPressed: () {
        _animationController.forward();
        widget.onPressed();
      },
    );
  }
}

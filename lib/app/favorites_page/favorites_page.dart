import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/stop.dart';
import 'package:rigify/app/bus_data/utils/parse_routes_data.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';
import 'package:rigify/app/favorites_page/widgets/route_tile.dart';
import 'package:rigify/app/favorites_page/widgets/skeleton_tile.dart';
import 'package:rigify/app/stop_page/stop_page.dart';
import 'package:rigify/app/time_page/time_page.dart';
import 'package:rigify/main.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  static final _log = Logger('FavoritePage');

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _reorderableListKey = GlobalKey();
  late Timer _timer;

  bool _reorderEnabled = false;
  int draggedItemIndex = -1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(lang.favRoutesTitle), actions: [
        IconButton(
          icon: FaIcon(
            _reorderEnabled
                ? FontAwesomeIcons.barsStaggered
                : FontAwesomeIcons.bars,
          ),
          onPressed: () {
            setState(() {
              _reorderEnabled = !_reorderEnabled;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _dialog();
          },
        )
      ]),
      // body: favoritesBox.isEmpty
      //     ? const _FavoritesEmpty()
      //     :
      // : ValueListenableBuilder(
      //     valueListenable: favoritesBox.listenable(),
      //     builder: (context, dynamic box, child) {
      //       final List<RouteType> favoriteRouted = getFavoriteRoutes();
      //
      //       _log.info('favoriteRouted: $favoriteRouted');
      //       return Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: RefreshIndicator(
      //           onRefresh: () async {
      //             await Future.delayed(const Duration(milliseconds: 500));
      //             setState(() {});
      //           },
      //           child: CustomReorderableListView.separated(
      //             key: _reorderableListKey,
      //             buildDefaultDragHandles: _reorderEnabled,
      //             physics: const BouncingScrollPhysics(),
      //             itemCount: favoritesBox.length,
      //             separatorBuilder: (_, __) => const SizedBox(height: 2),
      //             itemBuilder: (context, i) {
      //               final RouteType route = favoriteRouted[i];
      //               final List<RouteType> filterRouted =
      //                   filterFavoriteRoutes(route.transport);
      //               if (filterRouted.isEmpty) {
      //                 return NumTileSkeleton(
      //                   key: ValueKey('abc- $i'),
      //                 );
      //               } else {
      //                 return Stack(
      //                   key: ValueKey('abcd - $i'),
      //                   children: [
      //                     Consumer(builder: (context, ref, child) {
      //                       return Listener(
      //                         onPointerUp: (event) {
      //                           if (_timer.isActive) {
      //                             _timer.cancel();
      //                             _reorderEnabled
      //                                 ? null
      //                                 : Navigator.push(
      //                                     context,
      //                                     MaterialPageRoute(
      //                                       builder: (_) =>
      //                                           StopsPage(route),
      //                                     ),
      //                                   );
      //                           }
      //                         },
      //                         onPointerDown: (event) {
      //                           _timer = Timer(
      //                               const Duration(milliseconds: 500), () {
      //                             _reorderEnabled
      //                                 ? null
      //                                 : _addFavDialog(context, route);
      //                           });
      //                         },
      //                         child: FavoriteTile(
      //                           route,
      //                           reorderEnabled: _reorderEnabled,
      //                         ),
      //                       );
      //                     }),
      //                   ],
      //                 );
      //               }
      //             },
      //             shrinkWrap: true,
      //             onReorder: _reorderEnabled
      //                 ? (int oldIndex, int newIndex) {
      //                     if (newIndex > oldIndex) {
      //                       newIndex -= 1;
      //                     }
      //                     setState(() {
      //                       final oldItem = favoritesBox.getAt(oldIndex);
      //                       final newItem = favoritesBox.getAt(newIndex);
      //
      //                       draggedItemIndex = oldIndex;
      //
      //                       favoritesBox.putAt(oldIndex, newItem!);
      //                       favoritesBox.putAt(newIndex, oldItem!);
      //                     });
      //                   }
      //                 : (int oldIndex, int newIndex) {},
      //             scrollController: _scrollController,
      //             proxyDecorator: (Widget child, int index,
      //                 Animation<double> animation) {
      //               return DragTarget<int>(
      //                 onWillAccept: (int? data) {
      //                   return index == draggedItemIndex;
      //                 },
      //                 builder: (BuildContext context,
      //                     List<dynamic> accepted, List<dynamic> rejected) {
      //                   // Use the animation value to apply any visual effects to the dragged item.
      //                   final animValue =
      //                       Curves.easeInOut.transform(animation.value);
      //                   final scale = lerpDouble(1, 1.05, animValue)!;
      //                   final elevation = lerpDouble(0, 6, animValue)!;
      //                   // Wrap the child widget with a container to apply the highlight effect.
      //                   return Transform.scale(
      //                     scale: scale,
      //                     child: Container(
      //                       decoration: BoxDecoration(
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color: Colors.white.withOpacity(0.1),
      //                             blurRadius: 10,
      //                             spreadRadius: 1,
      //                             offset: const Offset(0, 1),
      //                           ),
      //                         ],
      //                         borderRadius: BorderRadius.circular(16),
      //                       ),
      //                       child: Material(
      //                         elevation: elevation,
      //                         borderRadius: BorderRadius.circular(16),
      //                         color: Colors.transparent,
      //                         child: child,
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               );
      //             },
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      body: FavoritesList(),
    );
  }

  _dialog() async {
    await showDialog(
      builder: (context) {
        final lang = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(lang.deleteTitle),
          content: Text(lang.deleteMsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(lang.no),
            ),
            TextButton(
              onPressed: () {
                favoritesBox.deleteAll(favoritesBox.keys);
                favoriteStopsBox.deleteAll(favoriteStopsBox.keys);

                Navigator.of(context, rootNavigator: true).pop();
                setState(() {});
              },
              child: Text(lang.yes),
            ),
          ],
        );
      },
      context: context,
    );
  }

  _addFavDialog(context, RouteType route) async {
    final lang = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 10,
          children: [
            SimpleDialogOption(
              onPressed: () async {
                favoritesBox.containsKey(route.name)
                    ? favoritesBox.delete(route.name)
                    : favoritesBox.put(route.name, route);
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                favoritesBox.containsKey(route.name)
                    ? lang.favoriteDialogRemove
                    : lang.favoriteDialogAdd,
              ),
            ),
          ],
          //backgroundColor: Colors.green,
        );
      },
    );
  }
}

class _FavoritesEmpty extends StatelessWidget {
  const _FavoritesEmpty();

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const FaIcon(FontAwesomeIcons.heart, size: 35),
            const SizedBox(height: 20),
            Text(
              lang.favRoutesEmpty,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              lang.favRoutesInfo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesList extends StatefulWidget {
  const FavoritesList({super.key});

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  @override
  Widget build(BuildContext context) {
    final isEmpty = favoritesBox.isEmpty && favoriteStopsBox.isEmpty;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {});
        },
        child: isEmpty
            ? const _FavoritesEmpty()
            : ListView(
                children: [
                  if (favoriteStopsBox.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 12, bottom: 8),
                        child: SvgPicture.asset(
                          'assets/app_assets/bus-stop.svg',
                          height: 25,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: favoriteStopsBox.listenable(),
                      builder: (context, dynamic box, child) {
                        final List<StopType> favoriteStops = getFavoriteStops();

                        return ListView.builder(
                          itemCount: favoriteStopsBox.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            final stop = favoriteStops[i];

                            final filterStops =
                                filterFavoriteStops(stop.stopName);

                            final stopConverted = Stop(
                              id: stop.id,
                              name: stop.stopName,
                              latitude: stop.latitude,
                              longitude: stop.longitude,
                              asciiName: stop.asciiName,
                            );

                            if (filterStops.isEmpty) {
                              return NumTileSkeleton(
                                key: ValueKey('abc- $i'),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TimePage(stop.route, stopConverted),
                                    ),
                                  );
                                },
                                child: FavoriteStopTile(stop),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                  if (favoritesBox.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 12, bottom: 8),
                        child: SvgPicture.asset(
                          'assets/app_assets/route_2.svg',
                          height: 25,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: favoritesBox.listenable(),
                      builder: (context, dynamic box, child) {
                        final List<RouteType> favoriteRoutes =
                            getFavoriteRoutes();

                        return ListView.builder(
                          itemCount: favoritesBox.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            final route = favoriteRoutes[i];

                            final List<RouteType> filterRouted =
                                filterFavoriteRoutes(route.transport);

                            if (filterRouted.isEmpty) {
                              return NumTileSkeleton(
                                key: ValueKey('abc- $i'),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StopsPage(route),
                                    ),
                                  );
                                },
                                child: FavoriteTile(route),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class FavoriteStopTile extends StatelessWidget {
  final StopType stop;

  const FavoriteStopTile(this.stop, {super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    List<String> separated = stop.route!.number!.split(' ');
    String number;
    String date;

    if (separated.length <= 1) {
      // No space found, treat the original string as the number
      number = stop.route!.number!;
      date = ''; // Empty string for date
    } else {
      number = separated[0];
      date = separated[1];
    }

    return Consumer(builder: (context, ref, child) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: colors[stop.route!.transport],
                  elevation: 2,
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.route!.name ?? '',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                  Text(stop.stopName ?? '',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

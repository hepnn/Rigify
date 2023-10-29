import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/utils/parse_routes_data.dart';
import 'package:rigify/app/components/reorderable_listview.dart';
import 'package:rigify/app/favorites_page/widgets/route_tile.dart';
import 'package:rigify/app/favorites_page/widgets/skeleton_tile.dart';
import 'package:rigify/app/stop_page/stop_page.dart';
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
      body: favoritesBox.isEmpty
          ? Center(
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
                      const Icon(Icons.info, size: 50),
                      const SizedBox(height: 20),
                      Text(lang.favRoutesEmpty,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 20),
                      Text(lang.favRoutesInfo,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ]),
              ),
            )
          : ValueListenableBuilder(
              valueListenable: favoritesBox.listenable(),
              builder: (context, dynamic box, child) {
                final List<RouteType> favoriteRouted = getFavoriteRoutes();

                _log.info('favoriteRouted: $favoriteRouted');
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      setState(() {});
                    },
                    child: CustomReorderableListView.separated(
                      key: _reorderableListKey,
                      buildDefaultDragHandles: _reorderEnabled,
                      physics: const BouncingScrollPhysics(),
                      itemCount: favoritesBox.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 2),
                      itemBuilder: (context, i) {
                        final RouteType route = favoriteRouted[i];
                        final List<RouteType> filterRouted =
                            filterFavoriteRoutes(route.transport);
                        if (filterRouted.isEmpty) {
                          return NumTileSkeleton(
                            key: ValueKey('abc- $i'),
                          );
                        } else {
                          return Stack(
                            key: ValueKey('abcd - $i'),
                            children: [
                              Consumer(builder: (context, ref, child) {
                                return Listener(
                                  onPointerUp: (event) {
                                    if (_timer.isActive) {
                                      _timer.cancel();
                                      _reorderEnabled
                                          ? null
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    StopsPage(route),
                                              ),
                                            );
                                    }
                                  },
                                  onPointerDown: (event) {
                                    _timer = Timer(
                                        const Duration(milliseconds: 500), () {
                                      _reorderEnabled
                                          ? null
                                          : _addFavDialog(context, route);
                                    });
                                  },
                                  child: FavoriteTile(
                                    route,
                                    reorderEnabled: _reorderEnabled,
                                  ),
                                );
                              }),
                            ],
                          );
                        }
                      },
                      shrinkWrap: true,
                      onReorder: _reorderEnabled
                          ? (int oldIndex, int newIndex) {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              setState(() {
                                final oldItem = favoritesBox.getAt(oldIndex);
                                final newItem = favoritesBox.getAt(newIndex);

                                draggedItemIndex = oldIndex;

                                favoritesBox.putAt(oldIndex, newItem!);
                                favoritesBox.putAt(newIndex, oldItem!);
                              });
                            }
                          : (int oldIndex, int newIndex) {},
                      scrollController: _scrollController,
                      proxyDecorator: (Widget child, int index,
                          Animation<double> animation) {
                        return DragTarget<int>(
                          onWillAccept: (int? data) {
                            return index == draggedItemIndex;
                          },
                          builder: (BuildContext context,
                              List<dynamic> accepted, List<dynamic> rejected) {
                            // Use the animation value to apply any visual effects to the dragged item.
                            final animValue =
                                Curves.easeInOut.transform(animation.value);
                            final scale = lerpDouble(1, 1.05, animValue)!;
                            final elevation = lerpDouble(0, 6, animValue)!;
                            // Wrap the child widget with a container to apply the highlight effect.
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Material(
                                  elevation: elevation,
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.transparent,
                                  child: child,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
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

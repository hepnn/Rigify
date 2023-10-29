import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/stop.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';
import 'package:rigify/app/search_time_page/search_time_page.dart';

final overlayOpenProvider = StateProvider<bool>((ref) => false);

class OverlayTextField extends ConsumerStatefulWidget {
  const OverlayTextField({super.key});

  @override
  ConsumerState<OverlayTextField> createState() => _OverlayTextFieldState();
}

class _OverlayTextFieldState extends ConsumerState<OverlayTextField> {
  late TextEditingController controller;
  final focusNode = FocusNode();
  OverlayEntry? entry;
  final layerLink = LayerLink();
  List<Stop> searchResults = [];
  final double maxOverlayHeight = 500.0;

  Map<String, List<Stop>> cache = {};

  @override
  void initState() {
    controller = TextEditingController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlayHeight = searchResults.length * 56.0 > maxOverlayHeight
        ? maxOverlayHeight
        : searchResults.length * 56.0;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width + 88,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(-2.0, size.height + 16.0),
          child: buildOverlay(overlayHeight),
        ),
      ),
    );
    if (overlayHeight > 0) {
      ref.read(overlayOpenProvider.notifier).state = true;
    }

    overlay.insert(entry!);
  }

  void hideOverlay() {
    focusNode.unfocus();
    controller.clear();
    Future.delayed(const Duration(milliseconds: 50), () {
      /// Timer, so that navigation to [SearchStopPage] works properly
      entry?.remove();
      searchResults.clear();
      entry = null;
    });
    ref.read(overlayOpenProvider.notifier).state = false;
  }

  void updateOverlay() {
    entry?.remove();
    showOverlay();
  }

  List<RouteType?> getStopRoutes(Stop stop) {
    final List<String> ids = stop.id!.split(',');
    final Map<String, RouteType?> rs = {};

    for (String id in ids) {
      for (var r in stops[id]!.routes) {
        rs[r] = routes[r];
      }
    }

    return rs.values.toList()..sort(sortRoutes);
  }

  Widget getStopSubtitle(List<RouteType?> routes) {
    final Map<String?, RouteType?> rs = {};

    for (var route in routes) {
      if (rs[route!.number] == null) rs[route.number] = route;
    }

    return GridView.extent(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 5),
      maxCrossAxisExtent: 35.0,
      childAspectRatio: 1.5,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      children: rs.values
          .map((m) => Material(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: colors[m!.transport!],
                  ),
                  child: Center(
                    child: Text(
                      m.number!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 245, 245, 245),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget buildOverlay(double overlayHeight) => Material(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Theme.of(context).canvasColor,
        child: SizedBox(
          height: overlayHeight,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: searchResults.length,
            itemBuilder: (context, i) {
              final Stop stop = searchResults[i];
              final List<RouteType?> routes = getStopRoutes(stop);
              return ListTile(
                dense: true,
                title: Text(stop.name!, style: const TextStyle(fontSize: 20)),
                subtitle: getStopSubtitle(routes),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchTimePage(routes, stop),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              endIndent: 15,
              indent: 15,
              color: Color.fromARGB(255, 110, 105, 105),
            ),
          ),
        ),
      );

  void searchStops(String text) {
    if (cache.containsKey(text)) {
      setState(() {
        searchResults = cache[text]!;
      });
    } else {
      setState(() {
        searchResults = stops.values
            .where(
                (stop) => stop.name!.toLowerCase().contains(text.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: ClipRRect(
        child: CupertinoSearchTextField(
          style: const TextStyle(
            color: Colors.white,
          ),
          focusNode: focusNode,
          controller: controller,
          onSuffixTap: () {
            hideOverlay();
            focusNode.unfocus();
            controller.clear();
          },
          onChanged: (text) {
            setState(() {
              searchResults = stops.values
                  .where((stop) =>
                      stop.name!.toLowerCase().contains(text.toLowerCase()))
                  .toList();
            });
            updateOverlay();
          },
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/stop.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';
import 'package:rigify/app/home_page/widgets/search_overlay.dart';
import 'package:rigify/app/home_page/widgets/transport_card.dart';
import 'package:rigify/app/recents_page/recents_page.dart';
import 'package:rigify/app/route_page/route_page.dart';
import 'package:rigify/app/search_time_page/search_time_page.dart';
import 'package:rigify/app/setting_page/settings_page.dart';
import 'package:rigify/locale/locale_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

_HomePageState? homepageState;

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) async {
      // Locale Startup Actions
      ref.read(localeStateProvider.notifier).initLocale();
    });
  }

  bool update = false;
  bool searching = false;

  final TextEditingController searchController = TextEditingController();
  List<Stop> searchResults = [];

  void rebuild() {
    setState(() => update = !update);
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
      maxCrossAxisExtent: 25.0,
      childAspectRatio: 1.5,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      children: rs.values
          .map(
            (m) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: colors[m!.transport!],
              ),
              child: Center(
                child: Text(
                  m.number!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).canvasColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
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

  Widget showResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, i) {
        final Stop stop = searchResults[i];
        final List<RouteType?> routes = getStopRoutes(stop);
        return ListTile(
          dense: true,
          title: Text(stop.name!, style: const TextStyle(fontSize: 18)),
          subtitle: getStopSubtitle(routes),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => SearchTimePage(routes, stop))),
        );
      },
    );
  }

  void openSearch() {
    /*
      FIXME: Hide and show keyboard to get rid of "[...] on inactive InputConnection" errors
            https://github.com/flutter/flutter/issues/23749
    */
    setState(() => searching = true);
  }

  Future<bool> closeSearch() async {
    searchController.clear();
    searchResults = [];
    setState(() => searching = false);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    bool isOverlay = ref.watch(overlayOpenProvider);

    return WillPopScope(
      onWillPop: searching ? closeSearch : () => Future.value(true),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: searching
              ? TextField(
                  autofocus: true,
                  controller: searchController,
                  onChanged: (text) {
                    setState(() {
                      searchResults = stops.values
                          .where((stop) => stop.name!
                              .toLowerCase()
                              .contains(text.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Search...', border: InputBorder.none),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Row(
                    children: [
                      const Flexible(
                        child: OverlayTextField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.clockRotateLeft),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RecentRoutesScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.gear),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(26, 26, 26, 26),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: transportNames.length,
                    itemBuilder: (context, i) {
                      final String transport = transportNames.keys.toList()[i];
                      // final String name = transportNames[transport]!;
                      final String transportName = lang.transports;
                      List transports = transportName.split(':');
                      return GridItem(
                        // color: const Color.fromARGB(255, 64, 63, 63),
                        title: transports[i],
                        iconColor: colors[transport],
                        icon: Icons.directions_bus,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomePageTwo(
                                transport,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            if (isOverlay)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ), // Adjust the sigma values for different blur intensity
                  child: Container(
                    color: Colors.black.withOpacity(
                      0.0,
                    ), // Adjust the opacity for different blur intensity
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/stop.dart';
import 'package:rigify/app/bus_data/utils/parse_routes_data.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';
import 'package:rigify/app/trip_page/trip_page.dart';
import 'package:rigify/main.dart';

class _TimePageState extends State<TimePage>
    with SingleTickerProviderStateMixin {
  _TimePageState(this._route, this._stop);
  final RouteType? _route;
  final Stop? _stop;

  final Map<String, GlobalKey> _keys = {};
  final Map<String, ScrollController> _scrollControllers = {};
  TabController? _tabController;

  Map<String?, Map<int, List<int>>> _times = {};
  final Map<String, int> _currentHour = {};
  List<String?> _weekdays = [];

  bool found = false;
  bool _isFavorite = false;

  @override
  void initState() {
    // FIXME: Adding @override causes an  final RenderBox renderBox = key!.currentContext!.findRenderObject() crash
    _times = getTime(_route!, _stop);
    _weekdays = _times.keys.toList();
    _weekdays.sort();

    final DateTime now = DateTime.now();
    final int hour = now.hour;
    final String day = now.weekday.toString();

    int selected = 0;
    for (int i = 0; i < _weekdays.length; i++) {
      final String weekday = _weekdays[i]!;
      if (weekday.contains(day)) selected = i;

      final Iterable<int> hours = _times[weekday]!.keys;
      if (hour <= hours.first || hour > hours.last) continue;

      final int idx = hours.where((h) => h >= hour).first;
      _currentHour[weekday] = idx;

      _keys[weekday] = GlobalKey();
      _keys['${weekday}_0'] = GlobalKey();
      _scrollControllers[weekday] = ScrollController();
    }

    _tabController = TabController(
        vsync: this, length: _weekdays.length, initialIndex: selected)
      ..addListener(() {
        if (_tabController!.indexIsChanging) return;
        updateScroll(_weekdays[_tabController!.index]);
      });

    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => updateScroll(_weekdays[selected]));
    super.initState();
  }

  void updateScroll(String? weekday) {
    final GlobalKey? key = _keys[weekday!];
    final GlobalKey? key_0 = _keys['${weekday}_0'];
    if (key_0 == null) return;

    final RenderBox renderBox =
        key!.currentContext!.findRenderObject() as RenderBox;
    final RenderBox renderBox_0 =
        key_0.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Offset position_0 = renderBox_0.localToGlobal(Offset.zero);
    _scrollControllers[weekday]!.animateTo(position.dy - position_0.dy,
        duration: const Duration(microseconds: 1), curve: Curves.linear);
  }

  GlobalKey? getKey(String? weekday, int hour) {
    if (_keys.containsKey('${weekday}_0')) {
      if (hour == _times[weekday]!.keys.first) return _keys['${weekday}_0'];
      if (hour == _currentHour[weekday!]) return _keys[weekday];
    }
    return null;
  }

  Consumer get _tabBar => Consumer(builder: (context, ref, child) {
        return TabBar(
          controller: _tabController,
          tabs: _weekdays
              .map((weekday) => Tab(text: getTimeTitle(weekday, context)))
              .toList(),
        );
      });

  @override
  Widget build(BuildContext context) {
    final stop = StopType(
      id: _stop?.id,
      stopName: _stop?.name,
      route: _route,
    );
    return DefaultTabController(
      length: _times.keys.length,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              child: _tabBar,
            ),
          ),
          title: Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  color: colors[_route!.transport],
                  elevation: 2,
                  child: Center(
                    child: Text(
                      _route.number!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _route.name!,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(_stop!.name!),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                  favoriteStopsBox.containsKey(_stop.name)
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: Colors.white),
              onPressed: () async {
                setState(() {
                  _isFavorite = !_isFavorite;
                  if (_isFavorite) {
                    favoriteStopsBox.put(_stop.name, stop);
                  } else {
                    favoriteStopsBox.delete(_stop.name);
                  }
                });
              },
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: _weekdays.map((weekday) {
            int i = -1;
            return ListView.builder(
              controller: _scrollControllers[weekday!],
              itemCount: _times[weekday]!.length,
              itemBuilder: (context, index) {
                var hour = _times[weekday]!.keys.elementAt(index);
                var isEvenRow = index % 2 == 0;

                return Container(
                  key: getKey(weekday, hour),
                  padding: const EdgeInsets.all(10),
                  color: isEvenRow ? null : Theme.of(context).cardColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: 55,
                        child: Transform.scale(
                          scale: 1.2,
                          child: Text(
                            (hour % 24).toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.extent(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          maxCrossAxisExtent: 35.0,
                          padding: const EdgeInsets.only(right: 10.0),
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20,
                          children: _times[weekday]![hour]!.map((minute) {
                            i++;
                            final DateTime now = DateTime.now();

                            bool isPastTime = now.hour > hour ||
                                (now.hour == hour && now.minute >= minute);
                            bool isClosestFutureTime = !found && !isPastTime;
                            if (isClosestFutureTime) {
                              found = true;
                            }

                            return GestureDetector(
                              onTap: ((i) => () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TripPage(_route, _stop, weekday, i),
                                    ),
                                  ))(i),
                              child: Center(
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: SizedBox(
                                    width: 150,
                                    child: Opacity(
                                      opacity: isPastTime ? 0.5 : 1,
                                      child: Card(
                                        color: isPastTime
                                            ? Theme.of(context)
                                                .drawerTheme
                                                .backgroundColor
                                            : null,
                                        shape: RoundedRectangleBorder(
                                          side: isClosestFutureTime
                                              ? const BorderSide(
                                                  width: 1, color: Colors.amber)
                                              : BorderSide.none,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Center(
                                            child: Text(
                                              minute.toString().padLeft(2, '0'),
                                              style: const TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TimePage extends StatefulWidget {
  const TimePage(this._route, this._stop, {super.key});
  final RouteType? _route;
  final Stop? _stop;

  @override
  _TimePageState createState() => _TimePageState(_route, _stop);
}

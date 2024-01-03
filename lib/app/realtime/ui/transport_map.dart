import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rigify/api_config.dart';
import 'package:rigify/app/bus_data/stop.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';
import 'package:rigify/app/realtime/provider/location_provider.dart';
import 'package:rigify/app/realtime/provider/polyline_provider.dart';
import 'package:rigify/app/realtime/provider/search_provider.dart';
import 'package:rigify/app/realtime/provider/stops_provider.dart';
import 'package:rigify/app/realtime/widgets/user_location_marker.dart';
import 'package:rigify/theme/theme_mode_state.dart';

final selectedTransportProvider =
    StateProvider.autoDispose<Transport?>((ref) => null);

class TransportMap extends ConsumerStatefulWidget {
  final List<Transport> transports;

  const TransportMap({super.key, required this.transports});

  @override
  ConsumerState<TransportMap> createState() => _TransportMapState();
}

class _TransportMapState extends ConsumerState<TransportMap> {
  late final MapController _mapController;
  var zoomLevel = 13.0;

  Marker? _userLocationMarker;
  double? _rotation;
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapController.mapEventStream.listen((MapEvent event) {
      if (event is MapEventRotate) {
        _rotation = event.currentRotation;
        setState(() {});
      }
      if (event is MapEventMove) {
        zoomLevel = _mapController.zoom;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final urlTemplate =
        isDarkMode ? ApiConfig.mapTemplateDark : ApiConfig.mapTemplateLight;
    final selectedTransport = ref.read(selectedTransportProvider);
    final polylineColor = selectedTransport?.type.color.withOpacity(0.4);
    final showStops = ref.watch(stopVisibilityProvider);

    ref.listen<Transport?>(selectedTransportProvider, (_, selectedTransport) {
      if (selectedTransport == null) {
        setState(() {
          polylineCoordinates.clear();
        });
      } else {
        _loadAndSetPolylines(selectedTransport);
      }
    });

    ref.listen<SearchCriteria?>(searchTransportProvider, (_, searchCriteria) {
      if (searchCriteria != null) {
        _searchAndZoomIn(searchCriteria);
      } else {}
    });

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(56.9496, 24.1052),
        interactiveFlags: InteractiveFlag.all,
        maxZoom: 18,
      ),
      nonRotatedChildren: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        LatLng userLocation = await ref
                            .read(locationRepositoryProvider)
                            .getCurrentLocation();
                        setState(() {
                          _userLocationMarker = Marker(
                            point: userLocation,
                            builder: (ctx) => LocationIndicator(
                              location: userLocation,
                            ),
                            width: 40,
                            height: 40,
                            anchorPos: AnchorPos.align(AnchorAlign.center),
                          );
                          _mapController.move(
                            userLocation,
                            15.0,
                          );
                        });
                      },
                      heroTag: null,
                      backgroundColor: const Color(0xff36323a),
                      foregroundColor: Colors.blue,
                      child: const Icon(Icons.my_location),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: urlTemplate,
          subdomains: const ['a', 'b', 'c'],
          backgroundColor: Colors.transparent,
          tileProvider: FMTC.instance('mapStore').getTileProvider(),
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: polylineCoordinates,
              strokeWidth: 6.0,
              color: polylineColor ?? Colors.transparent,
            ),
          ],
        ),
        if (showStops && zoomLevel >= 14)
          MarkerLayer(
            markers: _buildStopMarkers(),
          ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            markers: _buildMarkers(
              transports: widget.transports,
              rotation: _rotation ?? 0,
            ),
            anchor: AnchorPos.align(AnchorAlign.center),
            disableClusteringAtZoom: 13,
            builder: (context, markers) {
              return FloatingActionButton(
                onPressed: null,
                heroTag: null,
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(markers.length.toString()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers({
    required List<Transport> transports,
    required double rotation,
  }) {
    List<Marker> markers = [
      for (final transport in transports)
        Marker(
          key: ObjectKey(transport),
          point: LatLng(transport.latitude, transport.longitude),
          anchorPos: AnchorPos.align(AnchorAlign.center),
          builder: (context) => _TransportIcon(
            transport: transport,
            rotation: rotation,
            onSelected: () async {
              ref.read(selectedTransportProvider.notifier).state = transport;
              _mapController.move(
                LatLng(transport.latitude, transport.longitude),
                18,
              );
            },
            isSelected: ref.read(selectedTransportProvider)?.vehicleId ==
                transport.vehicleId,
          ),
        ),
    ];
    if (_userLocationMarker != null) {
      markers.add(_userLocationMarker!);
    }
    return markers;
  }

  List<Marker> _buildStopMarkers() {
    final markers = stops.values.map(
      (stop) => Marker(
        width: 15.0,
        height: 15.0,
        point: LatLng(stop.latitude ?? 0.0, stop.longitude ?? 0.0),
        builder: (ctx) => Container(
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(stop.name!),
                ),
              );
            },
            child: // circle
                Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey.withOpacity(0.5),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return markers.toList();
  }

  void _loadAndSetPolylines(Transport transport) async {
    if (transport.number != null && transport.number != 0) {
      final transportLine = TransportLine(
        type: transport.type,
        number: transport.number ?? -1,
      );
      final polylines = await ref
          .watch(polylineRepositoryProvider)
          .fetchPolylines(transportLine, 'a-b');
      setState(() {
        polylineCoordinates = polylines;
      });
    } else {
      // If the transport number is unknown, clear the existing polylines
      setState(() {
        polylineCoordinates.clear();
      });
    }
  }

  void _searchAndZoomIn(SearchCriteria criteria) {
    final lang = AppLocalizations.of(context)!;
    final List<Transport> transports = widget.transports;

    // Filter transports by transport type if specified.
    final filteredTransports = criteria.transportType != TransportType.unknown
        ? transports
            .where((transport) => transport.type == criteria.transportType)
            .toList()
        : transports;

    // Now, search within the filtered list.
    final Transport foundTransport = filteredTransports.firstWhere(
      (transport) =>
          transport.vehicleId == criteria.searchText ||
          transport.number.toString() == criteria.searchText,
      orElse: () => Transport.empty(),
    );

    if (foundTransport.number != null) {
      setState(() {
        _mapController.move(
          LatLng(foundTransport.latitude, foundTransport.longitude),
          18.0, // Zoom level
        );
        ref.read(selectedTransportProvider.notifier).state = foundTransport;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang.realtimeMapSearchNoResults),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

class _TransportIcon extends StatelessWidget {
  final Transport transport;
  final double rotation;
  final VoidCallback onSelected;
  final bool isSelected;

  const _TransportIcon({
    required this.transport,
    required this.rotation,
    required this.onSelected,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final angle = degToRadian(transport.bearing?.toDouble() ?? 0) + pi * 3 / 4;

    return GestureDetector(
      onTap: onSelected,
      child: Transform.rotate(
        angle: angle,
        child: Material(
          elevation: 2,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(200),
            bottomRight: Radius.circular(200),
            topLeft: Radius.circular(200),
          ),
          color: transport.type.color,
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(200),
                      bottomRight: Radius.circular(200),
                      topLeft: Radius.circular(200),
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  )
                : null,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Transform.rotate(
                    angle: -angle,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(-rotation / 360),
                      child: transport.isKnown
                          ? Text(
                              transport.number.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(
                              Icons.question_mark,
                              color: Colors.white,
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
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';

class TransportMap extends StatefulWidget {
  final List<Transport> transports;

  TransportMap({
    super.key,
    required this.transports,
  });

  @override
  State<TransportMap> createState() => _TransportMapState();
}

class _TransportMapState extends State<TransportMap> {
  late final MapController _mapController;
  double? _rotation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapController.mapEventStream.listen((MapEvent event) {
      if (event is MapEventRotate) {
        _rotation = event.currentRotation;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(56.9496, 24.1052),
        interactiveFlags: InteractiveFlag.all,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/mapbox/navigation-night-v1/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZmp4cyIsImEiOiJjbG56MXZlcGQwMXNnMmlvM3V2bWU5eXRjIn0.L8IMnQbPOW53sbeDPx9R7A',
          subdomains: const ['a', 'b', 'c'],
          // tilesContainerBuilder: darkModeTilesContainerBuilder,
          backgroundColor: Colors.transparent,
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
    return [
      for (final transport in transports)
        Marker(
          key: ObjectKey(transport),
          point: LatLng(transport.latitude, transport.longitude),
          anchorPos: AnchorPos.align(AnchorAlign.center),
          builder: (context) => _TransportIcon(
            transport: transport,
            rotation: rotation,
            onSelected: () {
              _mapController.move(
                LatLng(transport.latitude, transport.longitude),
                18,
              );
            },
          ),
        ),
    ];
  }
}

class _TransportIcon extends StatelessWidget {
  final Transport transport;
  final double rotation;
  final VoidCallback onSelected;

  const _TransportIcon({
    required this.transport,
    required this.rotation,
    required this.onSelected,
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
    );
  }
}

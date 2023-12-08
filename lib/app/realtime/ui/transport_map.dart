import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rigify/app/realtime/model/transport_extension.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';
import 'package:rigify/app/realtime/provider/transport_service.dart';

class TransportMap extends ConsumerWidget {
  TransportMap({super.key});

  final _mapController = MapController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transportsAsync = ref.watch(fetchTransportsProvider);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(56.9496, 24.1052),
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        maxZoom: 18,
      ),
      nonRotatedChildren: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          // tilesContainerBuilder: darkModeTilesContainerBuilder,
          backgroundColor: Colors.transparent,
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            markers: transportsAsync.when(
              data: (transports) {
                return _buildMarkers(transports: transports);
              },
              error: (error, stackTrace) => [],
              loading: () => [],
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

  List<Marker> _buildMarkers({required List<Transport> transports}) {
    return [
      for (final transport in transports)
        Marker(
          key: ObjectKey(transport),
          point: LatLng(transport.latitude, transport.longitude),
          anchorPos: AnchorPos.align(AnchorAlign.center),
          builder: (context) => _TransportIcon(transport: transport),
        ),
    ];
  }
}

class _TransportIcon extends StatelessWidget {
  final Transport transport;

  const _TransportIcon({
    required this.transport,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.directions_bus,
      color: transport.type.color,
      size: 32,
    );
  }
}

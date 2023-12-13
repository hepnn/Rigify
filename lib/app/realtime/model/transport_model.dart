import 'package:flutter/material.dart';

enum TransportType {
  unknown(color: Colors.grey, icon: Icons.directions_bus, jsonName: ''),
  bus(
    color: Color(0xFFf4B427),
    icon: Icons.directions_bus,
    jsonName: 'bus',
  ),
  tram(
    color: Color(0xFFff000C),
    icon: Icons.tram,
    jsonName: 'tram',
  ),
  trolley(
    color: Color(0xFF009dE0),
    icon: Icons.directions_bus_filled,
    jsonName: 'trol',
  );

  final Color color;
  final IconData icon;
  final String jsonName;

  const TransportType({
    required this.color,
    required this.icon,
    required this.jsonName,
  });
}

enum TransportStatus {
  unknown,
  onTime,
  delayed,
  early,
}

class Transport {
  final TransportType type;
  final int? number;
  final double latitude;
  final double longitude;
  final String vehicleId;
  final int? bearing;

  Transport({
    required this.type,
    this.number,
    required this.latitude,
    required this.longitude,
    required this.vehicleId,
    this.bearing = 0,
  });

  factory Transport.fromCsv(String csvLine) {
    final values = csvLine.split(',');

    TransportType type = _parseTransportType(values);
    int? number = _parseNumber(values);
    double latitude = _parseLatitude(values);
    double longitude = _parseLongitude(values);
    int? bearing = _parseBearing(values);
    String vehicleId = _parseVehicleId(values);

    return Transport(
      type: type,
      number: number,
      latitude: latitude,
      longitude: longitude,
      bearing: bearing,
      vehicleId: vehicleId,
    );
  }

  factory Transport.empty() {
    return Transport(
      type: TransportType.unknown,
      number: null,
      latitude: 0.0,
      longitude: 0.0,
      vehicleId: '',
    );
  }

  static double formatCoordinate(double coordinate) {
    String coordinateStr = coordinate.toStringAsFixed(6);
    List<String> parts = coordinateStr.split('.');
    String beforeDecimal = parts[0];
    String afterDecimal = parts.length > 1 ? parts[1] : "";
    String formattedCoordinate =
        '${beforeDecimal.substring(0, 2)}.${beforeDecimal.substring(2)}$afterDecimal';
    return double.parse(formattedCoordinate);
  }

  static TransportType _parseTransportType(List<String> values) {
    int typeValue = values.isNotEmpty ? int.tryParse(values[0]) ?? 0 : 0;
    switch (typeValue) {
      // TODO: Correct the values
      case 1:
        return TransportType.trolley;
      case 2:
        return TransportType.bus;
      case 3:
        return TransportType.tram;
      default:
        return TransportType.unknown;
    }
  }

  static int? _parseNumber(List<String> values) {
    return values.length > 1 && values[1].isNotEmpty
        ? int.tryParse(values[1])
        : null;
  }

  static double _parseLongitude(List<String> values) {
    return values.length > 2
        ? formatCoordinate(
            values[2].isNotEmpty ? double.tryParse(values[2]) ?? 0.0 : 0.0)
        : 0.0;
  }

  static double _parseLatitude(List<String> values) {
    return values.length > 3
        ? formatCoordinate(
            values[3].isNotEmpty ? double.tryParse(values[3]) ?? 0.0 : 0.0)
        : 0.0;
  }

  static int? _parseBearing(List<String> values) {
    return values.length > 5 && values[5].isNotEmpty
        ? int.tryParse(values[5])
        : null;
  }

  static String _parseVehicleId(List<String> values) {
    return values.length > 6 ? values[7] : '';
  }

  bool get isKnown => number != null;
}

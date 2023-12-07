import 'package:flutter/material.dart';

enum TransportType {
  unknown,
  bus,
  tram,
  trolley,
}

class Transport {
  final TransportType type;
  final int? number;
  final double latitude;
  final double longitude;
  final String? unknownField;
  final String vehicleId;

  Transport({
    required this.type,
    this.number,
    required this.latitude,
    required this.longitude,
    this.unknownField,
    required this.vehicleId,
  });

  factory Transport.fromCsv(String csvLine) {
    final values = csvLine.split(',');

    TransportType type = _parseTransportType(values);
    int? number = _parseNumber(values);
    double latitude = _parseLatitude(values);
    double longitude = _parseLongitude(values);
    String? unknownField = _parseUnknownField(values);
    String vehicleId = _parseVehicleId(values);

    return Transport(
      type: type,
      number: number,
      latitude: latitude,
      longitude: longitude,
      unknownField: unknownField,
      vehicleId: vehicleId,
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
        return TransportType.bus;
      case 2:
        return TransportType.tram;
      case 3:
        return TransportType.trolley;
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

  static String? _parseUnknownField(List<String> values) {
    return values.length > 4 && values[4].isNotEmpty ? values[4] : null;
  }

  static String _parseVehicleId(List<String> values) {
    return values.length > 5 ? values[7] : '';
  }
}

import 'package:flutter/material.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';

extension ColorExtension on TransportType {
  Color get color {
    switch (this) {
      case TransportType.bus:
        return Colors.yellow;
      case TransportType.tram:
        return Colors.red;
      case TransportType.trolley:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

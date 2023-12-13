import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';
import 'package:rigify/app/realtime/util/polyline_codec.dart';

extension TransportTypeExtension on TransportType {
  String get value {
    switch (this) {
      case TransportType.bus:
        return 'bus';
      case TransportType.tram:
        return 'tram';
      case TransportType.trolley:
        return 'trol';
      case TransportType.unknown:
        return 'unknown';
    }
  }
}

class TransportLine {
  final TransportType type;
  final int number;

  TransportLine({required this.type, required this.number});

  String get url {
    return 'https://saraksti.rigassatiksme.lv/riga/riga_${type.value}_$number.txt';
  }
}

class PolylineRepository {
  Future<List<LatLng>> fetchPolylines(
    TransportLine transportLine,
    String route,
  ) async {
    final response = await http.get(Uri.parse(transportLine.url));

    if (response.statusCode == 200) {
      final encodedLine = _parsePolylines(response.body, route);
      final decodedLine = _decodePolyline(encodedLine);

      return decodedLine;
    } else {
      throw Exception('Failed to load polylines');
    }
  }

  String _parsePolylines(
    String responseBody,
    String route,
  ) {
    try {
      String startDelimiter = route;
      String endDelimiter = 'BBBBBBBB';

      int startIndex = responseBody.indexOf(startDelimiter);
      if (startIndex == -1) {
        return '';
      }
      startIndex += startDelimiter.length;

      int endIndex = responseBody.indexOf(endDelimiter, startIndex);
      if (endIndex == -1) {
        endIndex = responseBody.length;
      }
      String polyline = responseBody.substring(startIndex, endIndex).trim();
      return polyline;
    } catch (e) {
      throw Exception('Error parsing polyline: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    return decodePolyline(encoded);
  }
}

final polylineRepositoryProvider = Provider<PolylineRepository>((ref) {
  return PolylineRepository();
});

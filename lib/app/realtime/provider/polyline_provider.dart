import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rigify/app/realtime/model/transport_model.dart';

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
  Future<String> fetchPolylines(
    TransportLine transportLine,
    String route,
  ) async {
    final response = await http.get(Uri.parse(transportLine.url));

    if (response.statusCode == 200) {
      return parsePolylines(response.body, route);
    } else {
      throw Exception('Failed to load polylines');
    }
  }

  String parsePolylines(
    String responseBody,
    String route,
  ) {
    try {
      // Split the response body by newlines to separate the sections
      // Find the index of the routeId in the body
      int startIndex = responseBody.indexOf('$route');
      print(startIndex);
      if (startIndex != -1) {
        // Find the end of the line
        int endIndex =
            responseBody.indexOf('\n', startIndex + route.length + 1);
        if (endIndex != -1) {
          // Extract the polyline string
          String polyline =
              responseBody.substring(startIndex + route.length + 1, endIndex);
          return polyline;
        } else {
          throw Exception("End of polyline string not found.");
        }
      } else {
        throw Exception("Route ID not found in the response.");
      }
    } catch (e) {
      // If there is an error during the HTTP request, catch and rethrow it
      throw Exception('Error parsing polyline: $e');
    }
  }
}

final polylineRepositoryProvider = Provider<PolylineRepository>((ref) {
  return PolylineRepository();
});

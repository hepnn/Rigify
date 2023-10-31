import 'package:hive/hive.dart';
import 'package:rigify/app/bus_data/route.dart';

part 'stop.g.dart';

final Map<String?, Stop> stops = {};
final Map<String?, List<String?>> searchCache = {};

const Map<String, String> accentMap = {
  '\u{0105}': 'a',
  '\u{00E4}': 'a',
  '\u{0101}': 'a',
  '\u{010D}': 'c',
  '\u{0119}': 'e',
  '\u{0117}': 'e',
  '\u{012F}': 'i',
  '\u{0173}': 'u',
  '\u{016B}': 'u',
  '\u{00FC}': 'u',
  '\u{017E}': 'z',
  '\u{0113}': 'e',
  '\u{0123}': 'g',
  '\u{012B}': 'i',
  '\u{0137}': 'k',
  '\u{013C}': 'l',
  '\u{0146}': 'n',
  '\u{00F6}': 'o',
  '\u{00F5}': 'o',
  '\u{0161}': 's',
  '\u{2013}': '-',
  '\u{2014}': '-',
  '\u{0336}': '-',
  '\u{00ad}': '-',
  '\u{02d7}': '-',
  '\u{201c}': '',
  '\u{201d}': '',
  '\u{201e}': '',
  "'": '',
  '"': ''
};

String toAscii(String str) {
  final List<String> arr = str.toLowerCase().split('');

  for (int i = 0; i < arr.length; i++) {
    final String? ascii = accentMap[arr[i]];
    if (ascii != null) arr[i] = ascii;
  }

  return arr.join('');
}

@HiveType(typeId: 2)
class StopType {
  @HiveField(0)
  String? stopName;
  @HiveField(1)
  RouteType? route;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? asciiName;
  @HiveField(4)
  double? latitude;
  @HiveField(5)
  double? longitude;

  String info = '';
  String street = '';
  String area = '';
  String city = '';

  StopType({
    this.stopName,
    this.route,
    this.id,
    this.asciiName,
    this.latitude,
    this.longitude,
  });

  static fromJson(StopType? stopType) {
    return StopType()
      ..stopName = stopType!.stopName
      ..route = stopType.route
      ..id = stopType.id
      ..asciiName = stopType.asciiName
      ..latitude = stopType.latitude
      ..longitude = stopType.longitude;
  }
}

class Stop {
  String? id;
  String? name;
  String? asciiName;
  double? latitude;
  double? longitude;

  String info = '';
  String street = '';
  String area = '';
  String city = '';

  static fromJson(Stop? stop) {
    return Stop()
      ..id = stop!.id
      ..name = stop.name
      ..asciiName = stop.asciiName
      ..latitude = stop.latitude
      ..longitude = stop.longitude;
  }

  Stop({
    this.id,
    this.name,
    this.asciiName,
    this.latitude,
    this.longitude,
  });

  List<String> routes = [];

  String getValue(List<String> lineItems, int index) {
    return lineItems.length > index ? lineItems[index].trim() : '';
  }

  String or(String s1, String s2) {
    return s1.isNotEmpty ? s1 : s2;
  }

  Stop clone() {
    final Stop stop = Stop();

    stop.id = id;
    stop.name = name;
    stop.asciiName = asciiName;
    stop.info = info;
    stop.street = street;
    stop.area = area;
    stop.city = city;
    stop.routes = routes;

    return stop;
  }

  void loadValues(List<String> lineItems, Stop? prevStop) {
    id = lineItems[0];

    String name = getValue(lineItems, 2);
    if (name.isEmpty && prevStop != null) {
      name = prevStop.name!;
      asciiName = prevStop.asciiName;
    } else {
      asciiName = toAscii(name);
    }

    latitude = double.tryParse(getValue(lineItems, 4)) ?? 0.0;
    longitude = double.tryParse(getValue(lineItems, 5)) ?? 0.0;

    searchCache[asciiName] = searchCache[asciiName] ?? [];
    searchCache[asciiName]!.add(id);

    this.name = name;
  }
}

void loadStops(String text) {
  Stop? prevStop;
  final List<String> lines = text.split('\n');
  for (int i = 1; i < lines.length - 1; i++) {
    final Stop stop = Stop();
    stop.loadValues(lines[i].split(','), prevStop);
    stop.name = stop.name!.substring(1, stop.name!.length - 1);
    try {
      if (stop.name!.isNotEmpty) {
        stops[stop.id] = stop;
        prevStop = stop;
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

List<Stop> searchStops(String text) {
  if (text.length < 2) return [];
  const String separators = '–—̶­˗“”„ _-.()\'"';

  final String textAscii = toAscii(text);
  final String textAsciiW = textAscii.replaceAll(RegExp(r'\W'), '');
  final String textLower = text.toLowerCase().replaceAll(RegExp(r'\W'), '');

  final List<Stop> result = [];

  for (String? asciiName in searchCache.keys) {
    final int indexOf = asciiName!.indexOf(textAscii);
    if (indexOf == -1 ||
        indexOf != 0 && !separators.contains(asciiName[indexOf - 1])) {
      continue;
    }

    final List<String?> ids = searchCache[asciiName]!;

    for (String? id in ids) {
      final Stop? stop = stops[id];
      if (stop == null || textAsciiW != textLower) continue;

      result.add(stop.clone());
    }
  }

  final List<Stop> unique = [];
  for (Stop s in result) {
    final int idx =
        unique.indexWhere((u) => u.name == s.name && u.street == s.street);
    if (idx > -1) {
      unique[idx].id = ',${s.id}' + unique[idx].id!;
      continue;
    }
    unique.add(s);
  }
  return unique
    ..sort((a, b) {
      final int c = a.name!.compareTo(b.name!);
      if (c != 0) return c;
      final int d = a.area.compareTo(b.area);
      if (d != 0) return d;
      return a.street.compareTo(b.street);
    });
}

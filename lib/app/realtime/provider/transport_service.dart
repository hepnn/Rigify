import 'package:rigify/app/realtime/model/transport_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transport_service.g.dart';

class TransportRepository {
  final String _url = 'https://saraksti.rigassatiksme.lv/gps.txt';

  Future<List<Transport>> fetchTransports() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final lines = response.body.split('\n');
      return lines.map((line) => Transport.fromCsv(line)).toList();
    } else {
      throw Exception('Failed to load transport data');
    }
  }
}

@riverpod
TransportRepository transportRepository(TransportRepositoryRef ref) {
  return TransportRepository();
}

@riverpod
Future<List<Transport>> fetchTransports(TransportRepositoryRef ref) {
  return ref.watch(transportRepositoryProvider).fetchTransports();
}

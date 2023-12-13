import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rigify/app/realtime/model/transport_model.dart';
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

final selectedTransportTypesProvider = StateProvider<Set<TransportType>>((ref) {
  return {};
});

final transportsStreamProvider =
    StreamProvider.autoDispose<List<Transport>>((ref) {
  final selectedTransportTypes = ref.watch(selectedTransportTypesProvider);
  final initialFetch = ref.read(transportRepositoryProvider).fetchTransports();

  final periodicFetch = Stream.periodic(const Duration(seconds: 10), (_) {
    return ref.read(transportRepositoryProvider).fetchTransports();
  }).asyncMap((event) async => await event);

  return Stream.value(initialFetch).asyncExpand((initial) async* {
    yield await initial;
    yield* periodicFetch;
  }).map((transports) {
    if (selectedTransportTypes.isNotEmpty) {
      return transports
          .where((t) => selectedTransportTypes.contains(t.type))
          .toList();
    }
    return transports;
  });
});

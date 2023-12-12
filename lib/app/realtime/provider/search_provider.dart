import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';

class SearchCriteria {
  final String searchText;
  final TransportType? transportType;

  SearchCriteria({required this.searchText, this.transportType});
}

final searchTransportProvider =
    StateProvider.autoDispose<SearchCriteria?>((ref) => null);

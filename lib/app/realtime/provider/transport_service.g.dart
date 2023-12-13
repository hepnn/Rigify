// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transportRepositoryHash() =>
    r'e22b2ecb8898685c2b7bf54ebf83529dceea160d';

/// See also [transportRepository].
@ProviderFor(transportRepository)
final transportRepositoryProvider =
    AutoDisposeProvider<TransportRepository>.internal(
  transportRepository,
  name: r'transportRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transportRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TransportRepositoryRef = AutoDisposeProviderRef<TransportRepository>;
String _$fetchTransportsHash() => r'3162533db97af9b8236bec6976b7b579fd70138c';

/// See also [fetchTransports].
@ProviderFor(fetchTransports)
final fetchTransportsProvider =
    AutoDisposeFutureProvider<List<Transport>>.internal(
  (AutoDisposeFutureProviderRef<List<Transport>> ref) async {
    final transportRepositoryRef = ref.read(transportRepositoryProvider);
    return await transportRepositoryRef.fetchTransports();
  },
  name: r'fetchTransportsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchTransportsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchTransportsRef = AutoDisposeFutureProviderRef<List<Transport>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationRepositoryHash() =>
    r'f97a4c44d3ec5d3cdff421f6640641041ddeedb7';

/// See also [locationRepository].
@ProviderFor(locationRepository)
final locationRepositoryProvider =
    AutoDisposeProvider<LocationRepository>.internal(
  locationRepository,
  name: r'locationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocationRepositoryRef = AutoDisposeProviderRef<LocationRepository>;
String _$getLocationHash() => r'957177ca72831dddcc4a189e967acecee4ec2cb2';

/// See also [getLocation].
@ProviderFor(getLocation)
final getLocationProvider = AutoDisposeFutureProvider<LatLng>.internal(
  (AutoDisposeFutureProviderRef<LatLng> ref) async {
    final locationRepositoryRef = ref.read(locationRepositoryProvider);
    return await locationRepositoryRef.getCurrentLocation();
  },
  name: r'getLocationProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetLocationRef = AutoDisposeFutureProviderRef<LatLng>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

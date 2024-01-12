import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_remote_config_service.g.dart';

@riverpod
FirebaseRemoteConfigService firebaseRemoteConfigService(_) {
  throw UnimplementedError();
}

class FirebaseRemoteConfigService {
  const FirebaseRemoteConfigService({
    required this.remoteConfig,
  });

  final FirebaseRemoteConfig remoteConfig;

  Future<void> init() async {
    try {
      await remoteConfig.ensureInitialized();
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  bool getMapEnabled() {
    return remoteConfig.getBool('map_enabled');
  }
}

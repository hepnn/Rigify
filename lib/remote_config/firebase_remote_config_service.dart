import 'package:firebase_remote_config/firebase_remote_config.dart';
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
      print(
        'Unable to fetch remote config. Cached or default values will be '
        'used',
      );
      print(e);
    }
  }

  bool getMapEnabled() {
    print(remoteConfig.getBool('map_enabled'));
    return remoteConfig.getBool('map_enabled');
  }
}

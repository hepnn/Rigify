import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopVisibilityProvider = StateProvider.autoDispose<bool>((ref) => false);

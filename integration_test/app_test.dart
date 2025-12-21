// Main integration test file that runs all app integration tests.
//
// Run with:
//   flutter test integration_test/app_test.dart
//
// Or run on a device:
//   flutter test integration_test/app_test.dart -d <device_id>

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'auth_flow_test.dart' as auth_flow;
import 'video_flow_test.dart' as video_flow;
import 'video_player_navigation_test.dart' as video_navigation;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    auth_flow.main();
    video_flow.main();
    video_navigation.main();
  });
}

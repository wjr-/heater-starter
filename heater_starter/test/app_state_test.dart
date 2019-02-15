import 'package:flutter_test/flutter_test.dart';

import '../lib/app_state.dart';

void main() {
  test('Heater starts in stopped state', () {
    var settings = new Settings();
    var appState = new AppState(settings);

    expect(appState.heaterState, HeaterState.stopped);
  });
}

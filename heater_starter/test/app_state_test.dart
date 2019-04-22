import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import '../lib/app_state.dart';
import '../lib/heater_control.dart';

void main() {
  test('Heater is in stopped state by default', () {
    var appState = createAppState();

    expect(appState.heaterState, HeaterState.stopped);
  });

  test('Heater can be started', () {
    var appState = createAppState();

    expect(appState.canStart(), true);
  });

  test('Heater goes to started state', () async {
    var appState = createAppState();

    await appState.startHeater(new Duration(seconds: 1));

    expect(appState.heaterState, HeaterState.heating);
  });

  test('Heater goes to stopped state when done', () async {
    var appState = createAppState();

    await appState.startHeater(new Duration(seconds: 1));

    await Future.delayed(new Duration(seconds: 2)).then((_) {
      appState.run();
      expect(appState.heaterState, HeaterState.stopped);
    });
  });

  test('Callback is called when heater starts', () {
    var flag = false;
    var appState = createAppState();
    appState.addHeaterStartedCallback((_) => flag = true);

    appState.startHeater(new Duration(seconds: 1));

    expect(flag, true);
  });

  test('Callback is called when heater runs', () {
    var flag = false;
    var appState = createAppState();
    appState.addHeaterRunningCallback((_) => flag = true);

    appState.startHeater(new Duration(seconds: 1));
    appState.run();

    expect(flag, true);
  });

  test('Callback is called when heater stops', () async {
    var flag = false;
    var appState = createAppState();
    appState.addHeaterStoppedCallback((_) => flag = true);

    appState.startHeater(new Duration(seconds: 1));
    await Future.delayed(new Duration(seconds: 2)).then((_) {
      appState.run();
    });

    expect(flag, true);
  });
}

AppState createAppState() {
  var settings = new Settings();
  var controlMock = new HeaterControlMock();
  return new AppState(settings, controlMock);
}

class HeaterControlMock implements HeaterControl {
  Future<dynamic> start(String phoneNumber, String pin, int minutes) {
    return Future.value(null);
  }
}

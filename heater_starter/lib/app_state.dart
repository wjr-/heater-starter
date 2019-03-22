import 'dart:async';

import 'app_state_persistence.dart';

import 'heater_control.dart';

enum HeaterState { stopped, heating }

class Settings {
  String pin;
  String phoneNumber;
}

class AppState {
  AppState(this.settings, this.control) {
    heaterState = HeaterState.stopped;
  }

  Settings settings;
  HeaterControl control;

  HeaterState heaterState;
  DateTime startTime;
  Duration runningTime;

  Duration getRemainingTime() {
    if (heaterState == HeaterState.heating) {
      return runningTime - _hasBeenRunningFor();
    } else {
      return new Duration();
    }
  }

  Future<void> startHeater(Duration duration) async {
    if (canStart()) {
      await control
          .start(settings.phoneNumber, settings.pin, duration.inMinutes)
          .then((_) {
        heaterState = HeaterState.heating;
        startTime = DateTime.now();
        runningTime = duration;
      });
    }
  }

  bool canStart() {
    return heaterState == HeaterState.stopped;
  }

  void run() {
    if (heaterState != HeaterState.heating) {
      return;
    }

    if (_hasBeenRunningFor() > runningTime) {
      _stopHeater();
    }
  }

  bool _canStop() {
    return heaterState == HeaterState.heating;
  }

  void _stopHeater() {
    if (_canStop()) {
      heaterState = HeaterState.stopped;
      runningTime = new Duration();

      new Persistence().saveAppState(this);
    }
  }

  Duration _hasBeenRunningFor() => DateTime.now().difference(startTime);
}

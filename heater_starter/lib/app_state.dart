import 'dart:async';

import 'heater_control.dart';

enum HeaterState { stopped, heating }

class Settings {
  String pin;
  String phoneNumber;
}

typedef void AppStateEventHandler(AppState appState);

class AppState {
  AppState(this.settings, this.control) {
    heaterState = HeaterState.stopped;
  }

  List<AppStateEventHandler> _onHeaterStarted =
      new List<AppStateEventHandler>();
  List<AppStateEventHandler> _onHeaterStopped =
      new List<AppStateEventHandler>();
  List<AppStateEventHandler> _onHeaterRunning =
      new List<AppStateEventHandler>();

  Settings settings;
  HeaterControl control;

  HeaterState heaterState;
  DateTime startTime;
  Duration runningTime;

  void addHeaterStartedCallback(AppStateEventHandler handler) {
    _onHeaterStarted.add(handler);
  }

  void addHeaterStoppedCallback(AppStateEventHandler handler) {
    _onHeaterStopped.add(handler);
  }

  void addHeaterRunningCallback(AppStateEventHandler handler) {
    _onHeaterRunning.add(handler);
  }

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

        _onHeaterStarted.forEach((callback) => callback(this));
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

    _onHeaterRunning.forEach((callback) => callback(this));

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

      _onHeaterStopped.forEach((callback) => callback(this));
    }
  }

  Duration _hasBeenRunningFor() => DateTime.now().difference(startTime);
}

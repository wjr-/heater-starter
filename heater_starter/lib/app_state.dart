import 'dart:async';

import 'heater_control.dart';

enum HeaterState { stopped, starting, heating }

class Settings {
  String pin;
  String phoneNumber;
}

typedef void AppStateEventHandler(AppState appState);

class AppState {
  AppState(this.settings, this.control) {
    heaterState = HeaterState.stopped;
  }

  List<AppStateEventHandler> _onHeaterStarting =
      new List<AppStateEventHandler>();
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

  void addHeaterStartingCallback(AppStateEventHandler handler) {
    _onHeaterStarting.add(handler);
  }

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
          .start(settings.phoneNumber, settings.pin, duration.inMinutes,
              _heaterStarted)
          .then((_) {
        heaterState = HeaterState.starting;
        runningTime = duration;
        _onHeaterStarting.forEach((handler) => handler(this));
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

  void _heaterStarted() {
    heaterState = HeaterState.heating;
    startTime = DateTime.now();
    _onHeaterStarted.forEach((handler) => handler(this));
  }

  bool _canStop() {
    return heaterState == HeaterState.heating;
  }

  void _stopHeater() {
    if (_canStop()) {
      heaterState = HeaterState.stopped;
      runningTime = new Duration();

      _onHeaterStopped.forEach((handler) => handler(this));
    }
  }

  Duration _hasBeenRunningFor() => DateTime.now().difference(startTime);
}

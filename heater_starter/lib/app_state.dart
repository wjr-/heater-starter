import 'heater_control.dart';

enum HeaterState { stopped, starting, heating, scheduled }

class Settings {
  String pin;
  String phoneNumber;
}

class AppState {
  AppState({this.settings}) {
    heaterState = HeaterState.stopped;
  }

  Settings settings;
  HeaterState heaterState;
  DateTime _startTime;
  Duration _runningTime;

  Duration getRemainingTime() {
    if (heaterState == HeaterState.heating) {
      return _runningTime - _hasBeenRunningFor();
    } else {
      return new Duration();
    }
  }

  Future<void> startHeater(int minutes) async {
    if (canStart()) {
      var control = HeaterControl(settings.phoneNumber, settings.pin);
      await control.start(minutes).then((value) {
        heaterState = HeaterState.heating;
        _startTime = DateTime.now();
        _runningTime = new Duration(minutes: minutes);
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

    if (_hasBeenRunningFor() > _runningTime) {
      _stopHeater();
    }
  }

  bool _canStop() {
    return heaterState == HeaterState.heating;
  }

  void _stopHeater() {
    if (_canStop()) {
      heaterState = HeaterState.stopped;
      _runningTime = null;
    }
  }

  Duration _hasBeenRunningFor() => DateTime.now().difference(_startTime);
}

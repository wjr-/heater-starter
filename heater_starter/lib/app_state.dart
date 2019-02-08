import 'package:shared_preferences/shared_preferences.dart';

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
  DateTime startTime;
  Duration runningTime;

  Duration getRemainingTime() {
    if (heaterState == HeaterState.heating) {
      return runningTime - _hasBeenRunningFor();
    } else {
      return new Duration();
    }
  }

  Future<void> startHeater(int minutes) async {
    if (canStart()) {
      var control = HeaterControl(settings.phoneNumber, settings.pin);
      await control.start(minutes).then((value) {
        heaterState = HeaterState.heating;
        startTime = DateTime.now();
        runningTime = new Duration(minutes: minutes);

        _saveStateToPreferences();
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

      _saveStateToPreferences();
    }
  }

  Future<void> _saveStateToPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("heaterState", heaterState as int);
    preferences.setInt(
        "startTimeMilliseconds", startTime.millisecondsSinceEpoch);
    preferences.setInt("runningTimeMinutes", runningTime.inMinutes);
  }

  Duration _hasBeenRunningFor() => DateTime.now().difference(startTime);
}

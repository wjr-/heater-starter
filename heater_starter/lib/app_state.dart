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

  Future<void> startHeater(int minutes) async {
    if (canStart()) {
      var control = HeaterControl(settings.phoneNumber, settings.pin);
      await control.start(minutes).then((value) {
        heaterState = HeaterState.heating;
      });
    }
  }

  void stopHeater() {
    if (canStop()) {
      heaterState = HeaterState.stopped;
    }
  }

  bool canStart() {
    return heaterState == HeaterState.stopped;
  }

  bool canStop() {
    return heaterState == HeaterState.heating;
  }
}

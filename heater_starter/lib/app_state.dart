import 'heater_control.dart';

enum HeaterState { stopped, starting, heating, scheduled }

class AppState {
  AppState() {
    heaterState = HeaterState.stopped;
    pin = "0000";
    phoneNumber = "1234567";
  }

  HeaterState heaterState;
  String pin;
  String phoneNumber;

  Future<void> startHeater(int minutes) async {
    if (canStart()) {
      var control = HeaterControl(phoneNumber, pin);
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

import 'heater_control.dart';

enum HeaterState { stopped, starting, heating, scheduled }

class AppState {
  AppState() {
    this._heaterState = HeaterState.stopped;
    pin = "0000";
    phoneNumber = "1234567";

    _control = HeaterControl(pin, phoneNumber);
  }

  HeaterState _heaterState;
  HeaterControl _control;
  String pin;
  String phoneNumber;

  HeaterState getHeaterState() {
    return _heaterState;
  }

  Future<void> startHeater(int minutes) async {
    if (canStart()) {
      await _control.start(minutes).then((value) {
        _heaterState = HeaterState.heating;
      });
    }
  }

  void stopHeater() {
    if (canStop()) {
      _heaterState = HeaterState.stopped;
    }
  }

  bool canStart() {
    return _heaterState == HeaterState.stopped;
  }

  bool canStop() {
    return _heaterState == HeaterState.heating;
  }
}

import 'heater_control.dart';

enum HeaterState { stopped, starting, heating, scheduled }

class AppState {
  AppState() {
    this._heaterState = HeaterState.stopped;
    this._control = HeaterControl("1234567", "0000");
  }

  HeaterState _heaterState;
  HeaterControl _control;

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

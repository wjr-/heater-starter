enum HeaterState { stopped, starting, heating, scheduled }

class AppState {
  AppState() {
    _heaterState = HeaterState.stopped;
  }

  HeaterState _heaterState;

  void startHeater() {
    if (canStart()) {
      _heaterState = HeaterState.heating;
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

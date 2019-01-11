abstract class ControlMessage {
  ControlMessage({this.pin});
  final String pin;

  String toString() {
    return 'PIN:' + this.pin;
  }
}

class StartMessage extends ControlMessage {
  StartMessage({String pin, this.duration}) : super(pin: pin);

  final num duration;

  String toString() {
    return super.toString() + ' Heater:on,run:' + this.duration.toString();
  }
}

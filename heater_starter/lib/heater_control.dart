import "dart:async";

import 'package:flutter_sms/flutter_sms.dart';

import 'heater_control_messages.dart';

typedef void HeaterStartedEventHandler();

class HeaterControl {
  final int _heaterStartDelay =
      30; // simulates the delay from sending the email to heater actually starting

  Future<dynamic> start(String phoneNumber, String pin, int minutes,
      HeaterStartedEventHandler onHeaterStarted) async {
    var startMessage = new StartMessage(pin: pin, duration: minutes);

    return await _sendSMS(startMessage.toString(), phoneNumber).then((_) =>
        {new Timer(new Duration(seconds: _heaterStartDelay), onHeaterStarted)});
  }

  Future _sendSMS(String message, String recipient) async {
    var recipients = [recipient];

    return await FlutterSms.sendSMS(message: message, recipients: recipients);
  }
}

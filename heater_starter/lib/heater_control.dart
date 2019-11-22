import "dart:async";

import 'package:sms/sms.dart';

import 'heater_control_messages.dart';

typedef void HeaterStartedEventHandler();

class HeaterControl {
  Future<dynamic> start(String phoneNumber, String pin, int minutes,
      HeaterStartedEventHandler onHeaterStarted) async {
    var startMessage = new StartMessage(pin: pin, duration: minutes);

    return await _sendSMS(startMessage.toString(), phoneNumber)
        .then((_) => onHeaterStarted());
  }

  Future _sendSMS(String message, String recipient) async {
    var sender = new SmsSender();
    return await sender.sendSms(new SmsMessage(recipient, message));
  }
}

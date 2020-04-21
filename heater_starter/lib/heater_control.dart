import "dart:async";

import 'package:sms/sms.dart';

import 'heater_control_messages.dart';

typedef void HeaterStartedEventHandler();

class HeaterControl {
  Future<void> start(String phoneNumber, String pin, int minutes) async {
    var startMessage = new StartMessage(pin: pin, duration: minutes);

    return _sendSMS(startMessage.toString(), phoneNumber);
  }

  Future<void> _sendSMS(String message, String recipient) async {
    var sender = new SmsSender();
    return await sender.sendSms(new SmsMessage(recipient, message));
  }
}

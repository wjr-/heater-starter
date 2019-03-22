import "dart:async";

import 'package:sms/sms.dart';

import 'heater_control_messages.dart';

class HeaterControl {
  Future<dynamic> start(String phoneNumber, String pin, int minutes) async {
    var startMessage = new StartMessage(pin: pin, duration: minutes);
    SmsSender sender = new SmsSender();

    return await sender
        .sendSms(new SmsMessage(phoneNumber, startMessage.toString()));
    // handle errors?
  }
}

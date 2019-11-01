import "dart:async";

import 'package:flutter_sms/flutter_sms.dart';

import 'heater_control_messages.dart';

class HeaterControl {
  Future<dynamic> start(String phoneNumber, String pin, int minutes) async {
    var startMessage = new StartMessage(pin: pin, duration: minutes);

    return await _sendSMS(startMessage.toString(), phoneNumber);
  }

  Future _sendSMS(String message, String recipient) async {
    var recipients = [recipient];

    return await FlutterSms.sendSMS(message: message, recipients: recipients);
  }
}

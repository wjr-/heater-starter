import 'package:sms/sms.dart';

import 'heater_control_messages.dart';

class HeaterControl {
  HeaterControl(this.phoneNumber, this.pin);
  final String phoneNumber;
  final String pin;

  Future<void> start(int minutes) async {
    var startMessage = new StartMessage(pin: pin, duration: minutes);
    SmsSender sender = new SmsSender();

    return await sender
        .sendSms(new SmsMessage(phoneNumber, startMessage.toString()));
  }
}

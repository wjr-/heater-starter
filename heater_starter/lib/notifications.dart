import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static FlutterLocalNotificationsPlugin initialize() {
    var androidSettings =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = new IOSInitializationSettings();
    var initializationSettings =
        new InitializationSettings(androidSettings, iOSSettings);

    var notificationsPlugin = new FlutterLocalNotificationsPlugin();
    notificationsPlugin.initialize(initializationSettings);

    return notificationsPlugin;
  }
}

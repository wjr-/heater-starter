import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heater_starter/app_state.dart';

class Notifications {
  FlutterLocalNotificationsPlugin _notificationsPlugin;

  void initialize() {
    var androidSettings = new AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // TODO set icon
    var iOSSettings = new IOSInitializationSettings();
    var initializationSettings =
        new InitializationSettings(androidSettings, iOSSettings);

    this._notificationsPlugin = new FlutterLocalNotificationsPlugin();
    this._notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showHeaterRunningNotification(AppState appState) async {
    var until = DateTime.now().add(appState.runningTime);
    var untilText = until.toIso8601String();
    untilText = untilText.substring(11, 16);
    return _showNotification("Heating", "Heating until " + untilText, 0);
  }

  Future<void> clear() async {
    return _notificationsPlugin.cancel(0);
  }

  Future<void> _showNotification(String title, String body, int id) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'heater_starter_notifications', 'Notifications', 'All notifications',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return await _notificationsPlugin.show(
        id, title, body, platformChannelSpecifics);
  }
}

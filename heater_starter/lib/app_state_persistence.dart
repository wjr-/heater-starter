import "dart:async";

import "package:shared_preferences/shared_preferences.dart";

import "app_state.dart";

class Persistence {
  Future<AppState> loadAppState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var settings = await _loadSettings();

    var appState = new AppState(settings);
    appState.heaterState =
        HeaterState.values[preferences.getInt("heaterState") ?? 0];
    appState.startTime = new DateTime.fromMillisecondsSinceEpoch(
        preferences.getInt("startTimeMilliseconds") ?? 0);
    appState.runningTime =
        new Duration(minutes: preferences.getInt("runningTimeMinutes") ?? 0);

    return appState;
  }

  Future<void> saveAppState(AppState appState) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("heaterState", appState.heaterState.index);
    preferences.setInt(
        "startTimeMilliseconds", appState.startTime.millisecondsSinceEpoch);
    preferences.setInt("runningTimeMinutes", appState.runningTime.inMinutes);
  }

  Future<void> saveSettings(Settings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('pin', settings.pin);
    preferences.setString('phoneNumber', settings.phoneNumber);
  }

  static Future<Settings> _loadSettings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Settings settings = new Settings();
    settings.pin = preferences.getString('pin') ?? "";
    settings.phoneNumber = preferences.getString('phoneNumber') ?? "";

    return settings;
  }
}

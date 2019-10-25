import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heater_starter/start_heater_screen.dart';

import 'app_state.dart';
import 'app_state_persistence.dart';
import 'settings_screen.dart';
import 'notifications.dart';

class HeaterStarterHomeScreen extends StatefulWidget {
  HeaterStarterHomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HeaterStarterHomeState createState() => _HeaterStarterHomeState();
}

class _HeaterStarterHomeState extends State<HeaterStarterHomeScreen> {
  _HeaterStarterHomeState();

  AppState _appState;
  Timer _timer;
  Notifications _notifications;
  String _statusText = "Ready";
  FlutterLocalNotificationsPlugin notifications;

  @override
  void initState() {
    super.initState();

    _notifications = new Notifications();
    _notifications.initialize();

    new Persistence().loadAppState().then((appState) {
      appState.addHeaterStartedCallback(_updateStatusDisplay);
      appState.addHeaterStartedCallback(
          _notifications.showHeaterRunningNotification);
      appState.addHeaterStartedCallback(_startTimer);

      appState.addHeaterStoppedCallback((_) => _timer.cancel());
      appState.addHeaterStoppedCallback((_) => _notifications.clear());
      appState.addHeaterStoppedCallback(_updateStatusDisplay);

      appState.addHeaterRunningCallback(_updateStatusDisplay);

      _appState = appState;
      _appState.run();

      if (_appState.heaterState == HeaterState.heating) {
        _startTimer(_appState);
      }

      _updateStatusDisplay(_appState);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_appState == null) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Loading..')],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: _goToSettings,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Text(
                    _statusText,
                    style: new TextStyle(
                        fontSize: 35, fontWeight: FontWeight.w500),
                  )),
              MaterialButton(
                color: Theme.of(context).buttonColor,
                disabledColor: Theme.of(context).disabledColor,
                height: 60,
                onPressed: _appState.canStart() ? _startHeater : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.play_arrow),
                    Text(
                      'Start',
                      style: new TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HeaterStarterSettingsScreen(
                appState: _appState,
              )),
    );
  }

  Future<void> _startHeater() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StartHeaterScreen(
                appState: _appState,
              )),
    );
  }

  void _startTimer(AppState appState) {
    _timer =
        new Timer.periodic(new Duration(seconds: 5), (_) => appState.run());
  }

  void _updateStatusDisplay(AppState appState) {
    var newText = "??";
    var remainingTime = _appState.getRemainingTime();

    if (_appState.heaterState == HeaterState.stopped) {
      newText = "Ready";
    } else if (_appState.heaterState == HeaterState.heating) {
      if (remainingTime.inMinutes < 1 && remainingTime.inSeconds < 10) {
        newText = "Stopping..";
      } else {
        newText = remainingTime.toString().substring(2, 6) + "0";
      }
    }

    setState(() {
      _statusText = newText;
    });
  }
}

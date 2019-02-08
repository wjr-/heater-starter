import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// won't work with 1.0?

import 'app_state.dart';
import 'settings_screen.dart';
//import 'notifications.dart';

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
  String _statusText = "Ready";
  //FlutterLocalNotificationsPlugin notifications;

  @override
  void initState() {
    super.initState();

    //notifications = Notifications.Initialize();

    _loadAppState().then((appState) {
      setState(() {
        _appState = appState;
      });
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
                    style: new TextStyle(fontSize: 50),
                  )),
              MaterialButton(
                color: Theme.of(context).buttonColor,
                height: 50,
                onPressed: _appState.canStart() ? _startHeater : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.play_arrow), Text('Start')],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Settings> _loadSettings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Settings settings = new Settings();
    settings.pin = preferences.getString('pin') ?? "";
    settings.phoneNumber = preferences.getString('phoneNumber') ?? "";

    return settings;
  }

  Future<AppState> _loadAppState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var settings = await _loadSettings();

    var appState = new AppState(settings: settings);
    appState.heaterState =
        HeaterState.values[preferences.getInt("heaterState") ?? 0];
    appState.startTime = new DateTime.fromMillisecondsSinceEpoch(
        preferences.getInt("startTimeMilliseconds") ?? 0);
    appState.runningTime =
        new Duration(minutes: preferences.getInt("runningTimeMinutes") ?? 0);

    return appState;
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
    // TODO: check settings are in place
    var minutes = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              contentPadding: EdgeInsets.only(top: 12, left: 10, bottom: 12),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 1);
                  },
                  child: const Text('1'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 2);
                  },
                  child: const Text('2'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 10);
                  },
                  child: const Text('10'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 15);
                  },
                  child: const Text('15'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 20);
                  },
                  child: const Text('20'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 25);
                  },
                  child: const Text('25'),
                ),
              ]);
        });

    if (minutes == null) {
      return;
    }

    await _appState.startHeater(minutes).then((_) {
      _timer = new Timer.periodic(new Duration(seconds: 10), _tick);
      _updateStatusDisplay(new Duration(minutes: minutes));
    });
  }

  void _tick(Timer timer) {
    _appState.run();

    if (_appState.heaterState != HeaterState.heating) {
      _timer.cancel();
    }

    _updateStatusDisplay(_appState.getRemainingTime());
  }

  void _updateStatusDisplay(Duration remainingTime) {
    var newText = "??";

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

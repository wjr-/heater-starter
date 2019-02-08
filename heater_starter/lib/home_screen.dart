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

  AppState appState;
  Timer _timer;
  Duration _timeLeft = new Duration();
  //FlutterLocalNotificationsPlugin notifications;

  @override
  void initState() {
    super.initState();

    //notifications = Notifications.Initialize();

    _loadSettings().then((settings) {
      setState(() {
        appState = new AppState(settings: settings);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (appState == null) {
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
              Text(
                _timeLeft.toString(),
                style: new TextStyle(fontSize: 40),
              ),
              MaterialButton(
                color: Theme.of(context).buttonColor,
                height: 50,
                onPressed: appState.canStart() ? _startHeater : null,
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

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HeaterStarterSettingsScreen(
                appState: appState,
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

    await appState.startHeater(minutes).then((_) {
      _timer = new Timer.periodic(new Duration(seconds: 10), _tick);
      setState(() {
        _timeLeft = new Duration(minutes: minutes);
      });
    });
  }

  void _tick(Timer timer) {
    appState.run();

    if (appState.heaterState == HeaterState.heating) {
    } else {
      _timer.cancel();
    }

    setState(() {
      _timeLeft = appState.getRemainingTime();
    });
  }
}

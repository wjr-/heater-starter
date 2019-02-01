import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';
import 'settings_screen.dart';

class HeaterStarterHomeScreen extends StatefulWidget {
  HeaterStarterHomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HeaterStarterHomeState createState() => _HeaterStarterHomeState();
}

class _HeaterStarterHomeState extends State<HeaterStarterHomeScreen> {
  _HeaterStarterHomeState();

  AppState appState;

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
    var minutes = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(title: const Text('Heat'), children: <Widget>[
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
      setState(() {});
    });
  }

  void _stopHeater() {
    setState(() {
      appState.stopHeater();
    });
  }

  @override
  void initState() {
    _loadSettings().then((settings) {
      setState(() {
        appState = new AppState(settings: settings);
      });
    });

    super.initState();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(appState.heaterState.toString()),
            Text(appState.settings.phoneNumber),
            Text(appState.settings.pin),
            RaisedButton(
              onPressed: appState.canStart() ? _startHeater : null,
              child: Row(
                children: <Widget>[Icon(Icons.play_arrow), Text('Heat')],
              ),
            ),
            RaisedButton(
              onPressed: appState.canStop() ? _stopHeater : null,
              child: Row(
                children: <Widget>[Icon(Icons.stop), Text('Stop')],
              ),
            ),
            RaisedButton(
              onPressed: null,
              child: Row(
                children: <Widget>[Icon(Icons.schedule), Text('Schedule')],
              ),
            )
          ],
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
}

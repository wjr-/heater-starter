import 'package:flutter/material.dart';

import 'app_state.dart';
import 'settings_screen.dart';

class HeaterStarterHomeScreen extends StatefulWidget {
  HeaterStarterHomeScreen({Key key, this.title, this.appState})
      : super(key: key);

  final String title;
  final AppState appState;

  @override
  _HeaterStarterHomeState createState() => _HeaterStarterHomeState(appState);
}

class _HeaterStarterHomeState extends State<HeaterStarterHomeScreen> {
  _HeaterStarterHomeState(this.appState) {
    _heaterState = this.appState.getHeaterState();
  }

  final AppState appState;
  HeaterState _heaterState;

  void _settings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HeaterStarterSettingsScreen()),
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
          ]);
        });

    if (minutes == null) {
      return;
    }

    await appState.startHeater(minutes).then((_) {
      setState(() {
        _heaterState = appState.getHeaterState();
      });
    });
  }

  void _stopHeater() {
    setState(() {
      appState.stopHeater();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: _settings,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(this.appState.toString()),
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
}

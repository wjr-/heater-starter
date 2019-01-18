import 'package:flutter/material.dart';

import 'app_state.dart';

class HeaterStarterSettingsScreen extends StatefulWidget {
  HeaterStarterSettingsScreen({Key key, this.appState}) : super(key: key);
  final AppState appState;

  @override
  _HeaterStarterSettingsState createState() =>
      _HeaterStarterSettingsState(appState);
}

class _HeaterStarterSettingsState extends State<HeaterStarterSettingsScreen> {
  _HeaterStarterSettingsState(this.appState);
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: <Widget>[Text('Ok')],
                ))
          ],
        ),
      ),
    );
  }
}

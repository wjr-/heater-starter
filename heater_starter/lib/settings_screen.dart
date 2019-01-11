import 'package:flutter/material.dart';

class HeaterStarterSettingsScreen extends StatefulWidget {
  HeaterStarterSettingsScreen({Key key}) : super(key: key) {}

  @override
  _HeaterStarterSettingsState createState() => _HeaterStarterSettingsState();
}

class _HeaterStarterSettingsState extends State<HeaterStarterSettingsScreen> {
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

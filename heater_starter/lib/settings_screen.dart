import 'package:flutter/material.dart';

import 'app_state.dart';

class HeaterStarterSettingsScreen extends StatefulWidget {
  HeaterStarterSettingsScreen({Key key, @required this.appState})
      : super(key: key);
  final AppState appState;

  @override
  _HeaterStarterSettingsState createState() =>
      _HeaterStarterSettingsState(appState);
}

class _HeaterStarterSettingsState extends State<HeaterStarterSettingsScreen> {
  _HeaterStarterSettingsState(this.appState) {
    _phoneNumberController.text = appState.phoneNumber;
    _pinController.text = appState.pin;
  }

  final AppState appState;
  final _settingsFormKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _pinController = TextEditingController();

  void _saveSettings() {
    appState.phoneNumber = _phoneNumberController.text;
    appState.pin = _pinController.text;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: "Save",
            onPressed: _saveSettings,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _settingsFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: "Phone number",
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _pinController,
                    decoration: InputDecoration(labelText: "PIN"),
                    maxLength: 4,
                    maxLengthEnforced: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _phoneNumberController.text = appState.settings.phoneNumber;
    _pinController.text = appState.settings.pin;
  }

  final AppState appState;
  final _settingsFormKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _pinController = TextEditingController();

  void _saveSettings() {
    var phoneNumber = _phoneNumberController.text;
    var pin = _pinController.text;

    _saveToPreferences(pin, phoneNumber).then((_) {
      appState.settings.pin = pin;
      appState.settings.phoneNumber = phoneNumber;
    });

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

  Future<void> _saveToPreferences(String pin, String phoneNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('pin', pin);
    preferences.setString('phoneNumber', phoneNumber);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heater_starter/app_state.dart';

class StartHeaterScreen extends StatefulWidget {
  StartHeaterScreen({Key key, @required this.appState}) : super(key: key);

  final AppState appState;

  @override
  _StartHeaterState createState() => _StartHeaterState(appState);
}

class _StartHeaterState extends State<StartHeaterScreen> {
  _StartHeaterState(this._appState);

  final AppState _appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Start")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _createButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> _createButtons() {
    const runTimes = [10, 15, 20, 25, 30, 35, 40, 45];
    var buttons = List<Widget>();
    for (var runTime in runTimes) {
      buttons.add(MaterialButton(
        onPressed: () => _startHeater(runTime),
        color: Theme.of(context).buttonColor,
        disabledColor: Theme.of(context).disabledColor,
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.play_arrow),
          Text(
            runTime.toString() + " mins ",
            style: const TextStyle(fontSize: 20),
          ),
          Icon(Icons.access_time),
          Text(
            _getButtonUntilText(runTime),
            style: const TextStyle(fontSize: 20),
          ),
        ]),
      ));
      buttons.add(SizedBox(height: 15));
    }
    return buttons;
  }

  Future<void> _startHeater(int runTime) async {
    var duration = Duration(minutes: runTime);
    await _appState.startHeater(duration).then((_) => Navigator.pop(context));
  }

  String _getButtonUntilText(int runTime) {
    var until = DateTime.now().add(Duration(minutes: runTime));
    var untilText = until.toIso8601String();
    untilText = untilText.substring(11, 16);
    return " " + untilText;
  }
}

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

  static const runTimes = [10, 15, 20, 25, 30, 35, 40, 45];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Start")),
      body: Center(
          child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: runTimes.length,
        itemBuilder: _createListItems,
      )),
    );
  }

  Widget _createListItems(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: MaterialButton(
        onPressed: () => _startHeater(runTimes[index]),
        color: Theme.of(context).buttonColor,
        disabledColor: Theme.of(context).disabledColor,
        padding: const EdgeInsets.all(10),
        height: 60,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.play_arrow),
          Text(
            runTimes[index].toString() + " mins ",
            style: const TextStyle(fontSize: 20),
          ),
          Icon(Icons.access_time),
          Text(
            _getButtonUntilText(runTimes[index]),
            style: const TextStyle(fontSize: 20),
          ),
        ]),
      ),
    );
  }

  Future<void> _startHeater(int runTime) async {
    var duration = Duration(minutes: runTime);
    await _appState.startHeater(duration);
    Navigator.pop(context);
  }

  String _getButtonUntilText(int runTime) {
    var until = DateTime.now().add(Duration(minutes: runTime));
    var untilText = until.toIso8601String();
    untilText = untilText.substring(11, 16);
    return " " + untilText;
  }
}

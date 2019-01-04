import 'package:flutter/material.dart';

void main() => runApp(HeaterStarter());

class HeaterStarter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heater Starter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HeaterStarterHomePage(title: 'Heater Starter'),
    );
  }
}

class HeaterStarterHomePage extends StatefulWidget {
  HeaterStarterHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HeaterStarterState createState() => _HeaterStarterState();
}

enum HeaterState { stopped, starting, heating, scheduled }

class _HeaterStarterState extends State<HeaterStarterHomePage> {
  HeaterState _heaterState = HeaterState.stopped;

  void _startHeater() {
    setState(() {
      _heaterState = HeaterState.heating;
    });
  }

  void _stopHeater() {
    setState(() {
      _heaterState = HeaterState.stopped;
    });
  }

  bool _canStart() {
    return _heaterState == HeaterState.stopped;
  }

  bool _canStop() {
    return _heaterState == HeaterState.heating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_heaterState.toString()),
            RaisedButton(
              onPressed: _canStart() ? _startHeater : null,
              child: Row(
                children: <Widget>[Icon(Icons.play_arrow), Text('Heat')],
              ),
            ),
            RaisedButton(
              onPressed: _canStop() ? _stopHeater : null,
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

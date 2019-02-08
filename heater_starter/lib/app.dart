import 'package:flutter/material.dart';

import 'home_screen.dart';

class HeaterStarterApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HeaterStarterState();
}

enum HeaterState { stopped, starting, heating, scheduled }

class HeaterStarterState extends State<HeaterStarterApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heater Starter',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: HeaterStarterHomeScreen(title: 'Heater Starter'),
    );
  }
}

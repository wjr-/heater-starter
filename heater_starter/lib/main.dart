import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() => runApp(HeaterStarterApp());

class HeaterStarterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heater Starter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HeaterStarterHomeScreen(title: 'Heater Starter'),
    );
  }
}

import 'package:flutter/material.dart';

import 'home_page.dart';

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

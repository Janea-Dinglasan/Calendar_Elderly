import 'package:flutter/material.dart';
import 'home_page.dart';  // Import HomePage

void main() => runApp(CalendarApp());

class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elderly Friendly Calendar',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      home: HomePage(),  // Set HomePage as the first screen
    );
  }
}

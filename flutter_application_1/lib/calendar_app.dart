import 'package:flutter/material.dart';
import 'screens/calendar_page.dart';


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
      home: CalendarPage(),
    );
  }
}

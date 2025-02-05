import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import '/screens/profile_page.dart';  // Import ProfilePage
import 'screens/splash_screen.dart'; // Import splash screen

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(), // Start with SplashScreen
  ));
}

class CalendarApp extends StatelessWidget {
  Future<bool> _isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') == null;  // Check if userName is stored
  }

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
      home: FutureBuilder<bool>(
        future: _isFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            return snapshot.data == true ? ProfilePage() : HomePage();
          }
        },
      ),
    );
  }
}

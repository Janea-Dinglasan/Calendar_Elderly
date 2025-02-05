import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/calendar_page.dart';
import '/screens/add_task_page.dart';
import '/widgets/schedule_view.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = "User";
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "User";
      _profilePicture = prefs.getString('profilePicture');
    });
  }

  Future<void> _saveTaskToStorage(DateTime date, Map<String, dynamic> task) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsData = prefs.getString('events');
    Map<DateTime, List<Map<String, dynamic>>> events = {};

    if (eventsData != null) {
      final Map<String, dynamic> decoded = json.decode(eventsData);
      events = decoded.map((key, value) {
        return MapEntry(
          DateTime.parse(key),
          List<Map<String, dynamic>>.from(value),
        );
      });
    }

    events.putIfAbsent(date, () => []).add(task);
    final updatedData = json.encode(
      events.map((key, value) => MapEntry(key.toIso8601String(), value)),
    );
    await prefs.setString('events', updatedData);
  }

  Future<void> _addTaskAndUpdateCalendar(BuildContext context) async {
    final selectedDate = DateTime.now();
    final task = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          selectedDate: selectedDate,
          onAddTask: (date, task) async {
            await _saveTaskToStorage(date, task);
            setState(() {}); // Refresh home screen to reflect updates
          },
        ),
      ),
    );

    if (task != null) {
      await _saveTaskToStorage(selectedDate, task);
      setState(() {}); // Refresh UI after task is added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildGreeting(),
            const SizedBox(height: 50),
            _buildMainButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return CircleAvatar(
      radius: 70,
      backgroundImage: _profilePicture != null
          ? NetworkImage(_profilePicture!)
          : AssetImage('assets/default_profile.png') as ImageProvider,
      backgroundColor: Colors.deepPurple[300],
    );
  }

  Widget _buildGreeting() {
    return Column(
      children: [
        Text(
          "Hello $_userName,",
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "What's Up Today?",
          style: TextStyle(fontSize: 20, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildMainButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureCard(context, 'Calendar', Icons.calendar_today, () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage(fromHomePage: true)),
              );
              setState(() {}); // Refresh home screen when returning from calendar
            }),
            const SizedBox(width: 20),
            _buildFeatureCard(context, 'Schedule', Icons.schedule, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduleView(
                    focusedDay: DateTime.now(),
                    events: {},
                    onEventsUpdated: (day, updatedEvents) {},
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureCard(context, 'Add Task', Icons.add_task, () {
              _addTaskAndUpdateCalendar(context);
            }),
            const SizedBox(width: 20),
            _buildFeatureCard(context, 'Help', Icons.help, () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Help'),
                  content: Text('This is a temporary help dialog.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

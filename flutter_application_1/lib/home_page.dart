import 'package:flutter/material.dart';
import 'screens/calendar_page.dart';
import '/screens/add_task_page.dart';
import '/widgets/schedule_view.dart';
import 'dart:ui';

class HomePage extends StatelessWidget {
  void _onAddTask(DateTime date, Map<String, dynamic> task) {
    print('Task added: $task');
  }

  final DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};

  void _onDateChanged(DateTime newDate) {
    print('New focused day: $newDate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 139, 86, 231),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: AppBar(
            title: const Text(
              'FIRST AIDE CALENDAR',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[200]!, Colors.deepPurple[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUserProfile(),
            const SizedBox(height: 40),
            const Text(
              'Welcome to Your Calendar App!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(
                    context,
                    'Calendar',
                    Icons.calendar_today,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalendarPage()),
                      );
                    },
                  ),
                  _buildButton(
                    context,
                    'Add Task',
                    Icons.add_task,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskPage(onAddTask: _onAddTask),
                        ),
                      );
                    },
                  ),
                  _buildButton(
                    context,
                    'Schedule',
                    Icons.schedule,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleView(
                            focusedDay: _focusedDay,
                            events: _events,
                            onDateChanged: _onDateChanged,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildButton(
                    context,
                    'Help',
                    Icons.help,
                    () {
                      // Temporary Help Action
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
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: const CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage(
              'https://www.w3schools.com/w3images/avatar2.png',
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'FE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[400],
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 6,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/calendar_view.dart';
import 'add_task_page.dart';
import '../widgets/schedule_view.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  int _currentTabIndex = 0;

  void _addTask(DateTime date, Map<String, dynamic> task) {
    setState(() {
      _events.putIfAbsent(date, () => []).add(task);
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Calendar", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _currentTabIndex == 0
            ? CalendarView(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    events: _events,
                    onDaySelected: _onDaySelected, // Pass the callback
                  )
                  : (_currentTabIndex == 1
                  ? ScheduleView(
                focusedDay: _focusedDay,
                events: _events,
                onDateChanged: (newDate) {
                  setState(() {
                    _focusedDay = newDate;
                  });
                },
                  )
                : AddTaskPage(onAddTask: _addTask)),
      )
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentTabIndex,
          onTap: (index) => setState(() => _currentTabIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Task"),
          ],
        ),
      ),
    );
  }
}

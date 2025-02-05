import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/calendar_view.dart';
import 'add_task_page.dart';
import '../widgets/schedule_view.dart';
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  final bool fromHomePage; // Add this flag

  CalendarPage({this.fromHomePage = false}); // Default to false if not coming from HomePage

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  int _currentTabIndex = 1;

  @override
  void initState() {
    super.initState();
    // If coming from the Home Page, set the default selectedDay to today
    if (widget.fromHomePage) {
      _selectedDay = DateTime.now(); 
    } else {
      _selectedDay = _focusedDay; // Default to focused day if not from HomePage
    }

    // Load events after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents(); // Load events from SharedPreferences
    });
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsData = prefs.getString('events');
    if (eventsData != null) {
      final Map<String, dynamic> decoded = json.decode(eventsData);
      setState(() {
        _events = decoded.map((key, value) {
          DateTime parsedDate = DateTime.parse(key);
          return MapEntry(
            DateTime(parsedDate.year, parsedDate.month, parsedDate.day),
            List<Map<String, dynamic>>.from(value),
          );
        });
      });
    }
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsData = json.encode(
      _events.map((key, value) {
        return MapEntry(key.toIso8601String(), value);
      }),
    );
    await prefs.setString('events', eventsData); // Save events to SharedPreferences
  }

  void _addTask(DateTime date, Map<String, dynamic> task) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    setState(() {
      _events.putIfAbsent(normalizedDate, () => []).add(task);
      _selectedDay = normalizedDate; // Update the selected day to the task's date
    });
    _saveEvents(); // Save the events after adding a new task
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      _focusedDay = focusedDay;
    });
  }

  void _openAddTaskPage() async {
    if (_selectedDay == null) return;
    final task = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          onAddTask: (date, newTask) {
            _addTask(date, newTask);
            setState(() {});
          },
          selectedDate: _selectedDay!,
        ),
      ),
    );
    if (task != null) {
      _addTask(_selectedDay!, task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentTabIndex == 1
          ? AppBar(
              title: Text("My Calendar", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _currentTabIndex == 1
                  ? CalendarView(
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay,
                      events: _events,
                      onDaySelected: _onDaySelected,
                    )
                  : ScheduleView(
                      focusedDay: _focusedDay,
                      events: _events,
                      onEventsUpdated: (newDate, updatedEvents) {
                        setState(() {
                          _focusedDay = newDate;
                          _events.clear();
                          _events.addAll(updatedEvents);
                          _saveEvents();
                        });
                      },
                      showBackButton: false,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskPage,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
          ],
        ),
      ),
    );
  }
}

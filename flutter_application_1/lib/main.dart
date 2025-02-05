import 'package:flutter/material.dart';
<<<<<<< HEAD
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

=======
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(CalendarApp());

class CalendarApp extends StatelessWidget {
>>>>>>> 00e71dc1e982c53e6caa7e900d347355895d2e88
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
<<<<<<< HEAD
      home: FutureBuilder<bool>(
        future: _isFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            return snapshot.data == true ? ProfilePage() : HomePage();
          }
        },
=======
      home: CalendarPage(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Calendar",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _currentTabIndex == 0
            ? _buildScheduleView()
            : (_currentTabIndex == 1 ? _buildCalendarView() : AddTaskPage(
                    onAddTask: _addTask, // Pass selected date
                  )),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentTabIndex,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Schedule"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Task"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
  return Column(
    children: [
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) => _events[day] ?? [],
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.deepPurple[100], shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.deepPurple[300], shape: BoxShape.circle),
            ),
          ),
        ),
      ),
      // Task Box Below the Calendar
      Flexible(
  flex: 1,
  child: Container(
    width: double.infinity, // Stretch across the screen width
    padding: EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
    decoration: BoxDecoration(
      color: Colors.deepPurple.shade50,
      borderRadius: BorderRadius.circular(10),
      //border: Border.all(color: Colors.deepPurple),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tasks for ${_selectedDay?.toLocal().toString().split(' ')[0] ?? 'select a date'}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        SizedBox(height: 10),
        _events[_selectedDay]?.isNotEmpty ?? false
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _events[_selectedDay]!.map((task) {
                  return Text(task['title']);
                }).toList(),
              )
            : Text("No tasks for this day."),
      ],
    ),
  ),
),
    ],
  );
}

Widget _buildScheduleView() {
  return Column(
    children: [
      // Header: Centralized Date with Arrows
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.deepPurple[200],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                setState(() {
                  _focusedDay = _focusedDay.subtract(const Duration(days: 1));
                });
              },
            ),
            Text(
              "${_focusedDay.toLocal()}".split(' ')[0], // Format as "YYYY-MM-DD"
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                setState(() {
                  _focusedDay = _focusedDay.add(const Duration(days: 1));
                });
              },
            ),
          ],
        ),
      ),

      // Time Slots and Events
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: 24, // From 12:00 AM to 11:00 PM
          itemBuilder: (context, index) {
            DateTime timeSlot = DateTime(
              _focusedDay.year,
              _focusedDay.month,
              _focusedDay.day,
              6 + index, // Change this from 7 + index to index
            );

            // Sample Event for a specific time (e.g., 7:00 AM to 8:00 AM)
            if (_events[timeSlot] == null) {
              _events[timeSlot] = [];
            }

            // Only add "THERAPY" event at 7:00 AM to 8:00 AM if it doesn't already exist
            if (timeSlot.hour == 7 && !_events[timeSlot]!.any((event) => event['title'] == 'THERAPY')) {
              _events[timeSlot]?.add({
                'title': 'THERAPY',
                'description': 'Therapy session with Doc. Juan',
                'startTime': timeSlot,
                'endTime': timeSlot.add(const Duration(hours: 1)), // 8:00 AM
              });
            }

            List<Map<String, dynamic>> events = _events[timeSlot] ?? [];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Column
                  SizedBox(
                    width: 70,
                    child: Text(
                      // Format time in "12:00 AM" format (one line)
                      '${timeSlot.hour == 0 ? 12 : (timeSlot.hour > 12 ? timeSlot.hour - 12 : timeSlot.hour)}:00 ${timeSlot.hour >= 12 ? 'PM' : 'AM'}',

                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Event Column
                  Expanded(
                    child: events.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: events.map((event) {
                              final startTime = event['startTime'];
                              final endTime = event['endTime'];
                              final duration = endTime.difference(startTime).inMinutes;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                height: (duration == 60) // Adjust height if duration is 1 hour
                                    ? 80.0 // 7:00 AM to 8:00 AM event
                                    : 40.0, // Default for 1 hour event
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple[50],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Display the title of the event
                                    Text(
                                      event['title'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple[900],
                                      ),
                                    ),
                                    // Display the event description
                                    Text(
                                      event['description'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.deepPurple[700],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        : Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "No Events",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}


}
class AddTaskPage extends StatefulWidget {
  final Function(DateTime, Map<String, dynamic>) onAddTask;

  AddTaskPage({required this.onAddTask});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}



class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _selectedDate;
  bool _isAllDay = false;
  bool _repeatEveryday = false;
  bool _isNotificationEnabled = false;  // New boolean for notification
  String _selectedCategory = 'Health';  // Default category

  // Categories list
  List<String> categories = ['Health', 'Family', 'Personal', 'Urgent'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime({required bool isStartTime}) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  // Custom designed category picker
  Widget _buildCategoryDropdown() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        category,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.category, color: Colors.deepPurple),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                _selectedCategory,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker({required String label, required IconData icon, required VoidCallback onTap, String? value}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                value ?? label,
                style: TextStyle(
                  fontSize: 16,
                  color: value == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Task",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        padding: EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildCategoryDropdown(), // Styled category dropdown here
                SizedBox(height: 20),
                Text(
                  "Select Date",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildPicker(
                  label: 'No date selected',
                  icon: Icons.calendar_today,
                  onTap: _pickDate,
                  value: _selectedDate == null ? null : '${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildPicker(
                        label: 'Start Time',
                        icon: Icons.access_time,
                        onTap: () => _pickTime(isStartTime: true),
                        value: _startTime?.format(context),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildPicker(
                        label: 'End Time',
                        icon: Icons.access_time,
                        onTap: () => _pickTime(isStartTime: false),
                        value: _endTime?.format(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isAllDay,
                          onChanged: (value) {
                            setState(() {
                              _isAllDay = value!;
                            });
                          },
                        ),
                        Text("All Day"),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _repeatEveryday,
                          onChanged: (value) {
                            setState(() {
                              _repeatEveryday = value!;
                            });
                          },
                        ),
                        Text("Repeat Everyday"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Add Location',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title *',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Task Description (optional)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Enable Notification:"),
                    Switch(
                      value: _isNotificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isNotificationEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _titleController.clear();
                        _descriptionController.clear();
                        _locationController.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 243, 243, 243)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isNotEmpty && _selectedDate != null) {
                          if (_endTime != null && _startTime != null &&
                              _endTime!.hour * 60 + _endTime!.minute <=
                                  _startTime!.hour * 60 + _startTime!.minute) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("End Time must be after Start Time")),
                            );
                            return;
                          }
                          final task = {
                            'title': _titleController.text,
                            'description': _descriptionController.text,
                            'location': _locationController.text,
                            'category': _selectedCategory,  // Include category
                            'startTime': _startTime?.format(context),
                            'endTime': _endTime?.format(context),
                            'isAllDay': _isAllDay,
                            'repeatEveryday': _repeatEveryday,
                            'isNotificationEnabled': _isNotificationEnabled,  // Include notification status
                          };
                          widget.onAddTask(_selectedDate!, task);
                          _titleController.clear();
                          _descriptionController.clear();
                          _locationController.clear();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter a title and select a date")),
                          );
                        }
                      },
                      child: Text("Add Task"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
>>>>>>> 00e71dc1e982c53e6caa7e900d347355895d2e88
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> events;
  final Function(DateTime, DateTime) onDaySelected; // Callback to notify the parent

  CalendarView({
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar View
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: focusedDay, // Corrected variable
              calendarFormat: CalendarFormat.month, // Default format
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                onDaySelected(selectedDay, focusedDay); // Call the callback
              },
              eventLoader: (day) => events[day] ?? [],
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: Colors.deepPurple[100], shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(
                    color: Colors.deepPurple[300], shape: BoxShape.circle),
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tasks for ${selectedDay?.toLocal().toString().split(' ')[0] ?? 'select a date'}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 10),
                events[selectedDay]?.isNotEmpty ?? false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: events[selectedDay]!.map((task) {
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
}

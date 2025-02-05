import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> events;
  final Function(DateTime, DateTime) onDaySelected;

  CalendarView({
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
  });

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  void _toggleTaskStatus(DateTime day, int index) {
    setState(() {
      final task = widget.events[day]![index];
      task['status'] = task['status'] == 'Completed' ? 'Pending' : 'Completed';
    });
  }

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
  focusedDay: widget.focusedDay,
  calendarFormat: CalendarFormat.month,
  selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
  onDaySelected: (selectedDay, focusedDay) {
    widget.onDaySelected(selectedDay, focusedDay);
  },
  eventLoader: (day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return widget.events.containsKey(normalizedDay) ? widget.events[normalizedDay]! : [];
  },
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

        // Wrap the task list inside a SingleChildScrollView to handle overflow
        if (widget.selectedDay != null)
          Flexible(
            flex: 1,
            child: SingleChildScrollView( // This makes the content scrollable
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tasks for ${widget.selectedDay!.toLocal().toString().split(' ')[0]}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...(widget.events[widget.selectedDay] ?? []).asMap().entries.map((entry) {
                      int index = entry.key;
                      var task = entry.value;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Checkbox(
                              value: task['status'] == 'Completed',
                              onChanged: (bool? value) {
                                _toggleTaskStatus(widget.selectedDay!, index);
                              },
                            ),
                            Expanded(
                              child: Text(task['title'] ?? 'No title'),
                            ),
                            Text(
                              task['status'] ?? 'Pending',
                              style: TextStyle(
                                color: task['status'] == 'Completed'
                                    ? Colors.green.shade600
                                    : Colors.orange.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            task['description'] ?? 'No description',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

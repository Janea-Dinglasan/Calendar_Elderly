import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  final DateTime focusedDay;
  final Map<DateTime, List<Map<String, dynamic>>> events;
  final Function(DateTime) onDateChanged;

  ScheduleView({required this.focusedDay, required this.events, required this.onDateChanged});

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late DateTime _focusedDay;
  late Map<DateTime, List<Map<String, dynamic>>> _events;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay;
    _events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule View", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Pop the current screen and go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
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
                      widget.onDateChanged(_focusedDay); // Notify the parent widget
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
                      widget.onDateChanged(_focusedDay); // Notify the parent widget
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
                    index, // Use the index directly for each hour
                  );

                  // Initialize events for the time slot
                  if (_events[timeSlot] == null) {
                    _events[timeSlot] = [];
                  }

                  // Add event if it's the desired time (e.g., at 7 AM)
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
                                      height: (duration == 60) ? 80.0 : 40.0, // Adjust height for 1-hour events
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
                                          // Event title
                                          Text(
                                            event['title'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple[900],
                                            ),
                                          ),
                                          // Event description
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
        ),
      ),
    );
  }
}

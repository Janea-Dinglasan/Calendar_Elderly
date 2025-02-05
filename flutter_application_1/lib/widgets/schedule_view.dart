import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  final DateTime focusedDay;
  final Map<DateTime, List<Map<String, dynamic>>> events;
  final Function(DateTime, Map<DateTime, List<Map<String, dynamic>>>) onEventsUpdated;
  final bool showBackButton;

  ScheduleView({
    required this.focusedDay,
    required this.events,
    required this.onEventsUpdated,
    this.showBackButton = true,
  });

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
    _events = Map.from(widget.events ?? {}); // Ensure it's never null
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _changeDay(bool isNext) {
    setState(() {
      _focusedDay = isNext
          ? _focusedDay.add(Duration(days: 1))
          : _focusedDay.subtract(Duration(days: 1));
    });

    // Call the onEventsUpdated callback to update events for the new date
    widget.onEventsUpdated(_focusedDay, _events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: widget.showBackButton,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildDateHeader(),
            _buildTimeSlotsAndEvents(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _changeDay(false), // Move to the previous day
          ),
          Text(
            "${_focusedDay.toLocal().toString().split(' ')[0]}",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () => _changeDay(true), // Move to the next day
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsAndEvents() {
    List<DateTime> timeSlotsWithEvents = _events.keys
        .where((key) => isSameDay(key, _focusedDay)) // Filter events for the focused day
        .toList()
      ..sort((a, b) => a.compareTo(b));

    return Expanded(
      child: timeSlotsWithEvents.isEmpty
          ? Center(
              child: Text(
                "No tasks added yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: timeSlotsWithEvents.length,
              itemBuilder: (context, index) {
                DateTime timeSlot = timeSlotsWithEvents[index];
                List<Map<String, dynamic>> events = _events[timeSlot] ?? [];

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: _buildEventList(events),
                );
              },
            ),
    );
  }

  Widget _buildEventList(List<Map<String, dynamic>> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: events.map((event) {
        return Container(
          margin: EdgeInsets.only(bottom: 5),
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['title'],
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[900]),
              ),
              Text(
                event['description'],
                style: TextStyle(fontSize: 12, color: Colors.deepPurple[700]),
              ),
              Text(
                'Time: ${event['startTime']} - ${event['endTime']}',
                style: TextStyle(fontSize: 12, color: Colors.deepPurple[600]),
              ),
              Text(
                'Status: ${event['status']}',
                style: TextStyle(fontSize: 12, color: Colors.deepPurple[600]),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';

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
        backgroundColor: Colors.deepPurple,
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
      ),
    );
  }
}

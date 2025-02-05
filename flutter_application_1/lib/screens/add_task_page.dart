import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  final Function(DateTime, Map<String, dynamic>) onAddTask;
  final DateTime selectedDate;

  AddTaskPage({required this.onAddTask, required this.selectedDate});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  bool _isAllDay = false;
  bool _repeatEveryday = false;
  String _selectedCategory = 'Health';
  String _taskStatus = 'Pending'; // New task status

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

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
      initialDate: _selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_titleController, 'Task Title *', Icons.title),
              SizedBox(height: 15),
              _buildDatePicker(),
              SizedBox(height: 15),
              _buildTextField(_locationController, 'Location', Icons.location_on),
              SizedBox(height: 15),
              _buildTextField(_descriptionController, 'Description', Icons.description),
              SizedBox(height: 15),
              _buildCheckbox('All Day', _isAllDay, (value) {
                setState(() {
                  _isAllDay = value!;
                });
              }),
              _buildCheckbox('Repeat Everyday', _repeatEveryday, (value) {
                setState(() {
                  _repeatEveryday = value!;
                });
              }),
              SizedBox(height: 15),
              _buildCategoryDropdown(),
              SizedBox(height: 15),
              _buildTaskStatusDropdown(),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickTime(true),
                    child: Text("Start Time"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _startTime != null ? _startTime!.format(context) : 'Select Time',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickTime(false),
                    child: Text("End Time"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _endTime != null ? _endTime!.format(context) : 'Select Time',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTask,
                child: Text("Add Task", style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(),
      ),
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildDatePicker() {
    final formattedDate = DateFormat('MMM dd, yyyy').format(_selectedDate!);
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue!;
        });
      },
      items: ['Health', 'Work', 'Personal', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
    );
  }

  Widget _buildTaskStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _taskStatus,
      onChanged: (String? newValue) {
        setState(() {
          _taskStatus = newValue!;
        });
      },
      items: ['Pending', 'Completed']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(labelText: 'Task Status', border: OutlineInputBorder()),
    );
  }

  void _addTask() {
    if (_titleController.text.isEmpty || _selectedDate == null || _startTime == null || _endTime == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Required Fields Missing'),
            content: Text('Please fill in the task title, date, start time, and end time to add a task.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final task = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'isAllDay': _isAllDay,
        'repeatEveryday': _repeatEveryday,
        'category': _selectedCategory,
        'status': _taskStatus,
        'startTime': _startTime?.format(context),
        'endTime': _endTime?.format(context),
      };
      widget.onAddTask(_selectedDate!, task);
      Navigator.pop(context);
    }
  }
}

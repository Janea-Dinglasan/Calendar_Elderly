import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;  // For web file input
import 'dart:typed_data';  // For Uint8List (image data)
import '/home_page.dart'; // Make sure HomePage is imported
import '/screens/welcome_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  Uint8List? _imageBytes; // Store image as bytes
  bool _isLoading = false; // Flag to manage loading state

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Function to pick an image from the file system
  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';  // Accept only image files
    uploadInput.click();  // Trigger the file picker dialog

    // When the user selects a file
    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      // Get the selected file
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]!);  // Read file as ArrayBuffer (binary)

      reader.onLoadEnd.listen((e) {
        // Convert ArrayBuffer to Uint8List (image data)
        setState(() {
          _imageBytes = reader.result as Uint8List?;
        });

        // Save the image file name or data to SharedPreferences (if necessary)
        final prefs = SharedPreferences.getInstance();
        prefs.then((prefs) {
          prefs.setString('userImage', files[0]!.name); // Save file name (or path if needed)
        });
      });
    });
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('userName') ?? '';
      _ageController.text = prefs.getInt('userAge')?.toString() ?? '';
      String? imagePath = prefs.getString('userImage');
      if (imagePath != null) {
        // Handle image loading logic if necessary (e.g., load from assets or a URL)
      }
    });
  }

  // Function to save the profile and show loading page
 Future<void> _saveProfile() async {
  // Check if the name is empty
  if (_nameController.text.isEmpty) {
    // Show an error message if the name is empty
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please enter your name."),
        backgroundColor: Colors.red,
      ),
    );
    return; // Don't proceed with saving the profile
  }

  setState(() {
    _isLoading = true; // Show the loading page
  });

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userName', _nameController.text);
  await prefs.setInt('userAge', int.tryParse(_ageController.text) ?? 0);
  await prefs.setBool('isNewUser', false);

  // Wait for a short duration to simulate loading
  await Future.delayed(Duration(seconds: 2));

  setState(() {
    _isLoading = false; // Hide the loading page
  });

  print("Profile saved, navigating to HomePage...");

  // Ensure proper navigation to HomePage after saving the profile
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF673AB7),
      body: Stack(
        children: [
          // Main content of the profile page
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: _imageBytes != null
                        ? Image.memory(
                            _imageBytes!, // Display the selected image from memory
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.camera_alt, size: 40, color: Color(0xFF673AB7)),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Create Profile",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter your age",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF673AB7),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Save & Continue",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Loading page (this is shown while profile is saving)
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF673AB7)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

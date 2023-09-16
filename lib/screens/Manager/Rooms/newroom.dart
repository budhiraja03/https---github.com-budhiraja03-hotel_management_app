import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class NewRoomForm extends StatefulWidget {
  @override
  _NewRoomFormState createState() => _NewRoomFormState();
}

class _NewRoomFormState extends State<NewRoomForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 194, 221, 233),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: screenWidth*0.4,
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: screenHeight*0.07,
                  width: screenHeight*0.7,
                  child: TextFormField(
                    controller: _roomNoController,
                    decoration: formFieldDecoration(labelText: 'Room No.'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a room no.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                SizedBox(
                  height: screenHeight*0.07,
                  width: screenHeight*0.7,
                  child: TextFormField(
                    controller: _typeController,
                    decoration: formFieldDecoration(labelText: 'Room Type'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a room type';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                SizedBox(
                  height: screenHeight*0.07,
                  width: screenHeight*0.7,
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: formFieldDecoration(labelText:'Price (\$)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: screenWidth*0.7, // Set the desired width for the image preview
                    height: MediaQuery.of(context).size.height*0.07, // Set the desired height for the image preview
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 181, 200, 210),
                        borderRadius: BorderRadius.circular(40.0), // Adjust the radius value as needed
                        border: Border.all(
                          color: Colors.black, // Border color
                          width: 1.0, // Border width
                          ),
                        ),// Placeholder color
                    child: _selectedImage != null
                        ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                        : Center(
                            child: Icon(Icons.camera_alt, size: 48),
                          ),
                  ),
                ),
                SizedBox(height: screenHeight*0.04,),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Room'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submitting the data to Firestore

      // Collect room data from NewRoomForm
      final roomData = getData();

      // Upload the selected image to Firebase Storage
      try {
        final existingRooms = await FirebaseFirestore.instance
              .collection('managers')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('rooms')
              .where('roomNo', isEqualTo: roomData['roomNo'])
              .get();
        if (existingRooms.docs.isNotEmpty) {
    // A room with the same name already exists, show an error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Room with the same room number already exists.'),
            ),
          );
        }else{
        final imageFile = File(_selectedImage!.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('room_images/${UniqueKey().toString()}'); // Create a unique storage path for each image

        final uploadTask = storageRef.putFile(imageFile);

        await uploadTask.whenComplete(() async {
          // Get the download URL of the uploaded image
          final imageUrl = await storageRef.getDownloadURL();

          // Add the new room data to Firestore with the image URL
          await FirebaseFirestore.instance
              .collection('managers') // Replace with your collection path
              .doc(FirebaseAuth.instance.currentUser!.uid) // Use the manager's ID as the document ID
              .collection('rooms').doc(roomData['roomNo'])
              .set({
                'roomNo': roomData['roomNo'],
                'type': roomData['type'],
                'price': roomData['price'],
                'imageUrl': imageUrl, // Store the image URL
                'available': true, // Set room availability as needed
                // Add other room data fields as needed
              });

          // Reset the form and clear the selected image
          setState(() {
            _formKey.currentState!.reset();
            _selectedImage = null;
          });
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New Room has been added'),
            duration: Duration(seconds: 2), // Adjust the duration as needed
          ),
        );
        });
        }
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
        // Handle the error as needed, e.g., show an error message
      }
    }
  }
  formFieldDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      filled: true,
      focusColor: const Color.fromARGB(255, 85, 108, 149),
    );
  }

 Map<String, dynamic> getData() {
    return {
      'roomNo': _roomNoController.text.trim(),
      'type': _typeController.text.trim(),
      'price': double.tryParse(_priceController.text) ?? 0.0,
    };
  }

  @override
  void dispose() {
    _roomNoController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

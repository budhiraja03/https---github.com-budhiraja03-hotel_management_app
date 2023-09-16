import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'roomModel.dart';
class EditRoomDialog extends StatefulWidget {
  final Room room;

  const EditRoomDialog({super.key, required this.room});

  @override
  _EditRoomDialogState createState() => _EditRoomDialogState();
}

class _EditRoomDialogState extends State<EditRoomDialog> {
  double? _updatedPrice;
  String? _updatedImageUrl;
  XFile? _pickedImage; // Stores the picked image file

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with the current room data
    _updatedPrice = widget.room.price;
    _updatedImageUrl = widget.room.imageUrl;
  }
  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
        // Update the _updatedImageUrl with the picked image file path
        _updatedImageUrl = pickedImage.path;
      });
    }
  }
  // Inside _EditRoomDialogState class
void _updateRoomDetails() async {

  try {
    final storageRef = FirebaseStorage.instance
            .ref()
            .child('room_images/${UniqueKey().toString()}'); // Create a unique storage path for each image

        final uploadTask = storageRef.putFile(File(_pickedImage!.path));

        await uploadTask.whenComplete(() async {
          // Get the download URL of the uploaded image
          final imageUrl = await storageRef.getDownloadURL();

          // Add the new room data to Firestore with the image URL
          await FirebaseFirestore.instance
              .collection('managers') // Replace with your collection path
              .doc(FirebaseAuth.instance.currentUser!.uid) // Use the manager's ID as the document ID
              .collection('rooms')
              .doc(widget.room.roomNo) // Use the room's ID to reference the document
              .update({
                'price': _updatedPrice,
                'imageUrl': imageUrl,
              });

          // Reset the form and clear the selected image
          setState(() {
            _updatedPrice=null;
            _updatedImageUrl = null;
          });
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Room has been updated'),
            duration: Duration(seconds: 2), // Adjust the duration as needed
          ),
        );
        });
  } catch (e) {
    // Handle errors (e.g., Firebase exceptions) here
    print('Error updating room details: $e');
    // You can show an error message or take appropriate actions based on the error.
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Room Details'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Text field for updating the price
            TextField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _updatedPrice = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            // Text field for updating the image URL
            SizedBox(height: MediaQuery.of(context).size.height*0.03,),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.4,
                  height: MediaQuery.of(context).size.height*0.04,
                  child: Text(_updatedImageUrl.toString(),),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.2,
                  height: MediaQuery.of(context).size.height*0.055,
                  child: ElevatedButton(
                    onPressed: () {
                      _pickImage(); // Call the _pickImage function
                    },
                    child: const Text('Pick Image'),
                  ),
                ),
              ],
            ),
            // Display the picked image (if available)
            if (_pickedImage != null)
              Image.file(
                File(_pickedImage!.path),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Cancel button
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Save button
            // Perform the update operation here
            // You can update the room details in Firestore with _updatedPrice and _updatedImageUrl
            // Then, close the dialog
            _updateRoomDetails();
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

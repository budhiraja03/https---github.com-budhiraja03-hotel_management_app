import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_management_app/screens/Manager/Guests/guestModel.dart';

class DeleteGuestDialog extends StatefulWidget {
  final Guest guest;

  const DeleteGuestDialog({Key? key, required this.guest}) : super(key: key);

  @override
  _DeleteGuestDialogState createState() => _DeleteGuestDialogState();
}

class _DeleteGuestDialogState extends State<DeleteGuestDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this guest?'),
      actions: [
        TextButton(
          onPressed: () {
            // Cancel button
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            deleteGuest(); // Call the onDelete function provided when showing the dialog
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future<void> deleteGuest() async {
    try {
      await FirebaseFirestore.instance.collection('managers').doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('guests')
          .doc(widget.guest.roomNo)
          .delete();
      await FirebaseFirestore.instance.collection('managers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('rooms')
      .doc(widget.guest.roomNo)
      .update({
        'available': true,
      });
    } catch (e) {
      // Handle errors (e.g., Firebase exceptions) here
      print('Error deleting guest: $e');
      // You can show an error message or take appropriate actions based on the error.
    }
  }
}

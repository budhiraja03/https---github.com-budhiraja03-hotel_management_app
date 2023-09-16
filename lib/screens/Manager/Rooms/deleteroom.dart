import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'roomModel.dart';
class DeleteRoomDialog extends StatefulWidget {
  final Room room;
  const DeleteRoomDialog({super.key,required this.room});

  @override
  State<DeleteRoomDialog> createState() => _DeleteRoomDialogState();
}

class _DeleteRoomDialogState extends State<DeleteRoomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Deletion'),
      content: Text('Are you sure you want to delete this room?'),
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
            deleteRoom(); // Call the onDelete function provided when showing the dialog
            Navigator.of(context).pop();
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
  Future<void> deleteRoom() async {
    try {
      await FirebaseFirestore.instance
          .collection('managers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('rooms')
          .doc(widget.room.roomNo)
          .delete();
    } catch (e) {
      // Handle errors (e.g., Firebase exceptions) here
      print('Error deleting room: $e');
      // You can show an error message or take appropriate actions based on the error.
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'foodItemModel.dart'; // Replace with the actual food item model

class DeleteFoodItemDialog extends StatefulWidget {
  final FoodItem foodItem;

  const DeleteFoodItemDialog({Key? key, required this.foodItem}) : super(key: key);

  @override
  _DeleteFoodItemDialogState createState() => _DeleteFoodItemDialogState();
}

class _DeleteFoodItemDialogState extends State<DeleteFoodItemDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this food item?'),
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
            deleteFoodItem(); // Call the onDelete function provided when showing the dialog
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future<void> deleteFoodItem() async {
    try {
      await FirebaseFirestore.instance
          .collection('managers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('foodmenu')
          .doc(widget.foodItem.name)
          .delete();
    } catch (e) {
      // Handle errors (e.g., Firebase exceptions) here
      print('Error deleting food item: $e');
      // You can show an error message or take appropriate actions based on the error.
    }
  }
}

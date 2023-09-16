import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'foodItemModel.dart'; // Replace with the actual food item model

class EditFoodItemDialog extends StatefulWidget {
  final FoodItem foodItem;

  const EditFoodItemDialog({Key? key, required this.foodItem}) : super(key: key);

  @override
  _EditFoodItemDialogState createState() => _EditFoodItemDialogState();
}

class _EditFoodItemDialogState extends State<EditFoodItemDialog> {
  double? _updatedPrice;
  String? _updatedDescription;
  
  @override
  void initState() {
    super.initState();
    // Initialize the form fields with the current food item data
    _updatedPrice = widget.foodItem.price;
    _updatedDescription = widget.foodItem.description;
  }


  Future<void> _updateFoodItemDetails() async {
    try {
        await FirebaseFirestore.instance
            .collection('managers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('foodmenu')
            .doc(widget.foodItem.name)
            .update({
              'price': _updatedPrice,
              'description': _updatedDescription,});


        setState(() {
          _updatedPrice = null;
          _updatedDescription = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Food item has been updated'),
            duration: Duration(seconds: 2),
          ),
        );
    } catch (e) {
      print('Error updating food item details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:const Text('Edit Food Item Details'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _updatedPrice = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  _updatedDescription = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _updateFoodItemDetails();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

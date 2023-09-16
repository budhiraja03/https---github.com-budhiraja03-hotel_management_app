import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewFoodItemForm extends StatefulWidget {
  @override
  _NewFoodItemFormState createState() => _NewFoodItemFormState();
}

class _NewFoodItemFormState extends State<NewFoodItemForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

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
          width: screenWidth * 0.4,
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: screenHeight * 0.07,
                  width: screenHeight * 0.7,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: formFieldDecoration(labelText: 'Food Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a food name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: screenHeight * 0.07,
                  width: screenHeight * 0.7,
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration:
                        formFieldDecoration(labelText: 'Food Description'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a food description';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: screenHeight * 0.07,
                  width: screenHeight * 0.7,
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: formFieldDecoration(labelText: 'Price (\$)'),
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
                SizedBox(height: screenHeight * 0.04),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Food Item'),
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
      final foodItemData = getData();

      try {
        final existingFoodItems = await FirebaseFirestore.instance
            .collection('managers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('foodmenu')
            .where('name', isEqualTo: foodItemData['name'])
            .get();

        if (existingFoodItems.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Food item with the same name already exists.'),
            ),
          );
        } else {
            await FirebaseFirestore.instance
                .collection('managers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('foodmenu')
                .doc(foodItemData['name'])
                .set({
              'name': foodItemData['name'],
              'description': foodItemData['description'],
              'price': foodItemData['price'],
            });

            setState(() {
              _formKey.currentState!.reset();
            });

            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New Food Item has been added'),
                duration: Duration(seconds: 2),
              ),
            );
        }
      } catch (e) {
        print('Error uploading data to Firebase Storage: $e');
      }
    }
  }

  InputDecoration formFieldDecoration({required String labelText}) {
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
      'name': _nameController.text.trim(),
      'description': _descriptionController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}

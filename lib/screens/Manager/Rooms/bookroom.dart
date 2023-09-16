import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'roomModel.dart';
class BookingDialog extends StatefulWidget {
  final Room room;

  const BookingDialog({super.key, required this.room});

  @override
  _BookingDialogState createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _checkInDate;
  DateTime? _checkoutDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Book Room'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Guest Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a guest name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Guest Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a guest phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText:'Guest Age'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a guest address';
                  }
                  return null;
                },
              ),
              // Date picker for check-in date
              ElevatedButton(
                onPressed: () {
                  _showDatePicker(context, isCheckInDate: true);
                },
                child: const Text('Select Check-In Date'),
              ),
              Text(
                _checkInDate != null
                    ? 'Check-In Date: ${_checkInDate!.toLocal()}'
                    : 'No Check-In Date Selected',
              ),
              // Date picker for check-out date
              ElevatedButton(
                onPressed: () {
                  _showDatePicker(context, isCheckInDate: false);
                },
                child: const Text('Select Check-Out Date'),
              ),
              Text(
                _checkoutDate != null
                    ? 'Check-Out Date: ${_checkoutDate!.toLocal()}'
                    : 'No Check-Out Date Selected',
              ),
            ],
          ),
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
            // Validate the form
            if (_formKey.currentState!.validate()) {
              // Form is valid, proceed to book the room
              _bookRoom();
            }
          },
          child: const Text('Book'),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context, {bool isCheckInDate = true}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        if (isCheckInDate) {
          _checkInDate = selectedDate;
        } else {
          _checkoutDate = selectedDate;
        }
      });
    }
  }

  void _bookRoom() async {
    final firestore = FirebaseFirestore.instance;
    final roomId = widget.room.roomNo;
    final guestName = _nameController.text;
    final guestEmail = _emailController.text;
    final guestPhone = _phoneController.text;
    final guestAddress = _addressController.text;
    final guestAge = _ageController.text;
    final roomPrice = widget.room.price;
    if (_checkInDate == null || _checkoutDate == null) {
      // Ensure that both check-in and check-out dates are selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both check-in and check-out dates.'),
        ),
      );
      return;
    }
    final duration = _checkoutDate!.difference(_checkInDate!);
    try {
      // Store guest information in Firestore
      await firestore.collection('managers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('guests').doc(roomId).set({
                  'roomId': roomId,
                  'name': guestName,
                  'email': guestEmail,
                  'phone': guestPhone,
                  'address': guestAddress,
                  'age': int.tryParse(guestAge) ?? 0,
                  'checkInDate': _checkInDate,
                  'checkoutDate': _checkoutDate,
                  'pricePaid': (duration.inDays)*roomPrice,
                });
      // Update the room document to mark it as booked
      await firestore.collection('managers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('rooms')
      .doc(roomId)
      .update({
        'available': false,
      });

      // Close the dialog after booking
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Room booking has been successful.'),
        ),
      );
    } catch (e) {
      // Handle errors (e.g., Firebase exceptions) here
      print('Error booking room: $e');
      // You can show an error message or take appropriate actions based on the error.
    }
  }
}

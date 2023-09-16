import 'package:flutter/material.dart';

import 'guestModel.dart';
class ShowDetailsDialog extends StatefulWidget {
  final Guest guest;
  const ShowDetailsDialog({super.key, required this.guest});

  @override
  State<ShowDetailsDialog> createState() => _ShowDetailsDialogState();
}

class _ShowDetailsDialogState extends State<ShowDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: Text('Guest Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                Text('Age: ${widget.guest.age.toString()}',style: const TextStyle(color: Colors.blueGrey),),
                Text('Phone: ${widget.guest.phone}',style: const TextStyle(color: Colors.blueGrey),),
                Text('Address: ${widget.guest.address}',style: const TextStyle(color: Colors.blueGrey),),
                Text('Check-In Date: ${widget.guest.checkInDate.toString()}',style: const TextStyle(color: Colors.blueGrey),),
                Text('Check-Out Date: ${widget.guest.checkOutDate.toString()}',style: const TextStyle(color: Colors.blueGrey),),
                Text('Price Paid: ${widget.guest.paidPrice.toString()}',style: const TextStyle(color: Colors.blueGrey),)
              ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
  }
}
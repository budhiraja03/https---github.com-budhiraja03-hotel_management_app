import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'guestCard.dart';
import 'guestModel.dart';
class GuestListScreen extends StatefulWidget {
  const GuestListScreen({super.key});

  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  List<Guest> guests = [];
  
  @override
  void initState() {
    super.initState();
    _fetchGuests();
  }

  Future<List<Guest>> fetchGuestsForRoom() async {
    final guestQuery = await FirebaseFirestore.instance
        .collection('managers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('guests')
        .get();
    final guestQuerySnapshot = guestQuery;
    final guestDocuments = guestQuerySnapshot.docs;
    final guests = guestDocuments.map((doc) {
      final data = doc.data();
      return Guest(
        roomNo: data['roomId'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        age: data['age'] != null ? int.tryParse(data['age'].toString()) ?? 0 : 0,
        phone: data['phone'] ?? '',
        address: data['address'] ?? '',
        paidPrice: data['pricePaid'] != null ? double.tryParse(data['pricePaid'].toString()) ?? 0.0 : 0.0,
        checkInDate: data['checkInDate'] != null
            ? (data['checkInDate'] as Timestamp).toDate()
            : DateTime.now(),
        checkOutDate: data['checkoutDate'] != null
            ? (data['checkoutDate'] as Timestamp).toDate()
            : DateTime.now(),
      );
    }).toList();
    return guests;
  }

  Future<void> _fetchGuests() async {
    final guestList = await fetchGuestsForRoom();
    setState(() {
      guests = guestList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildGuestList(), // Call a function to build the guest list
        ],
      ),
    );
  }

  Widget _buildGuestList() {
    if (guests.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GuestCard(guest: guests[index]);
          },
          childCount: guests.length,
        ),
      );
    } else {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('There are no guests in this room'),
        ),
      );
    }
  }
}

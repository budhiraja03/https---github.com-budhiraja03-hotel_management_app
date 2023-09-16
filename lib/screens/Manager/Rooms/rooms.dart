import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'newroom.dart';
import 'roomModel.dart';
import 'roomTile.dart';
class RoomPage extends StatefulWidget {
  final User? user;
  const RoomPage({super.key, this.user});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Room> rooms = [];
  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<List<Room>> fetchRoomsForManager(String managerId) async {
      final roomQuery = await FirebaseFirestore.instance
                        .collection('managers')
                        .doc(managerId)
                        .collection('rooms').get();
      final roomQuerySnapshot = roomQuery;
      final roomDocuments = roomQuerySnapshot.docs;
      final rooms = roomDocuments.map((doc) {
        final data = doc.data();
        return Room(
          roomNo: data['roomNo'] ?? '',
          type: data['type'] ?? '',
          price: data['price'] != null ? double.tryParse(data['price'].toString()) ?? 0.0 : 0.0,
          available: data['available'] ?? false,
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
      return rooms;
  }

  Future<void> _fetchRooms() async {
    final roomList = await fetchRoomsForManager(widget.user!.uid);
    setState(() {
      rooms = roomList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildRoomList(), // Call a function to build the room list
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: customFAB(context),
    );
  }
  customFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => newRoomDialog(context),
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.add),
    );
  }
  newRoomDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewRoomForm();
      },
    ).then((value) => setState(() {}));
  }
  Widget _buildRoomList() {
    if (rooms.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return RoomCard(room: rooms[index]);
          },
          childCount: rooms.length,
        ),
      );
    }
    else {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('There is nothing to show'),
        ),
      );
    }
  }
}
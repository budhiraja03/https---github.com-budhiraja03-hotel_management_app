import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bookroom.dart';
import 'deleteroom.dart';
import 'editRoom.dart';
import 'roomModel.dart';
class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.85, // Set the desired width for the image
            height: MediaQuery.of(context).size.height*0.2,
            padding: const EdgeInsets.all(10), // Set the desired height for the image
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10), // Use BoxShape.rectangle for a rounded rectangle
            ),
            child: Image.network(room.imageUrl)),
          ListTile(
            title: Row(
              children: [
                Text(room.roomNo,
                  style: GoogleFonts.getFont('Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
                room.available ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.cancel, color: Colors.red),  
              ],
            ),
            subtitle: Text('Type: ${room.type}, Price: \$${room.price.toStringAsFixed(2)}',
            style: GoogleFonts.getFont('PT Sans',fontSize: 16),),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert), // Dotted menu icon
              onSelected: (value) {
                if (value == 'edit') {
                  // Handle the "Edit" option by calling the _editRoom function
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditRoomDialog(room: room);
                    },
                  );
                }
                else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteRoomDialog(room: room);
                    },
                  );
                  // Handle the "Delete" option here
                  // You can show a confirmation dialog and then delete the room
                  // Pass 'room' to the delete function to identify the room to delete
                }
              },
              itemBuilder: (BuildContext context) {
                return ['edit', 'delete'].map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option == 'edit' ? 'Edit' : 'Delete'),
                  );
                }).toList();
              },)//room.available ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.cancel, color: Colors.red),
          ),
          Visibility(
            visible: room.available,
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: ElevatedButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BookingDialog(room: room);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  elevation: 5, // Elevation (shadow)
                  padding: EdgeInsets.all(10), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),),
                child: Text("Book Now")),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'deleteguest.dart';
import 'guestModel.dart';
import 'showdetails.dart';
class GuestCard extends StatelessWidget {
  final Guest guest;

  const GuestCard({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final isCheckoutDatePassed = guest.checkOutDate.isBefore(currentDate);
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: Text(guest.name,style: GoogleFonts.getFont('Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isCheckoutDatePassed ? Colors.red : Colors.black),),
            subtitle: Text(guest.email,style: GoogleFonts.getFont('PT Sans',fontSize: 16),),
            // Add more guest details as needed
            trailing:Text('Room ${guest.roomNo}',style: const TextStyle(fontSize:20,color: Colors.blueAccent,fontWeight: FontWeight.bold),)),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.4,
                  child: ElevatedButton(
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ShowDetailsDialog(guest: guest);
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
                    child: Text("Show Details")),
                ),
                Visibility(
                  visible: isCheckoutDatePassed,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.4,
                    child: ElevatedButton(
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteGuestDialog(guest: guest);
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
                      child: Text("Check-Out")),
                  ),
                ),
                
              ],)),
          ])
    );
  }
}
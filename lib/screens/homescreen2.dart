import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_management_app/screens/Manager/Food/food.dart';
import 'package:hotel_management_app/screens/Manager/Guests/guests.dart';
import 'package:hotel_management_app/screens/Manager/LoginPage.dart';
import 'package:hotel_management_app/screens/Manager/Rooms/rooms.dart';

class HomeScreen2 extends StatefulWidget {
  final User? user;
  const HomeScreen2({super.key, this.user});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  int _selectedIndex = 0;
  String? _managerName;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> getManagerName() async {
    if (widget.user != null) {
      await FirebaseFirestore.instance
          .collection('managers').where("email",isEqualTo:widget.user!.email).get().then((value) {
            for(var docSnap in value.docs){
              setState(() {
              _managerName = docSnap.data()['name'];
            });}
          },);
        //withConverter(fromFirestore: Manager.fromFirestore, toFirestore: (Manager manager,_)=>manager.toFirestore());
      
    }
  }
  @override
  void initState() {
    super.initState();
    _loadManagerName();
  }

  Future<void> _loadManagerName() async {
    await getManagerName();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: [IconButton(
                icon: const Icon(Icons.power_settings_new, color: Colors.white),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                    // After signing out, you can navigate to another screen or perform any other necessary actions.
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                },
              ),
              ],
              expandedHeight: 150.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Welcome, $_managerName',style: GoogleFonts.getFont('Crimson Text',fontSize: 20),),
                background: const Image(
                  image: AssetImage('images/appbar.jpg'),
                  fit: BoxFit.cover,
                ),
                ),
            ),
            SliverFillRemaining(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.bed_outlined),
              label: 'Rooms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_outlined),
              label: 'Food Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              label: 'Guests',
              ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
    );
  }
  late final List<Widget> _widgetOptions = <Widget>[
    RoomPage(user: widget.user),
    FoodMenuPage(user: widget.user,),
    const GuestListScreen(),
  ];
}

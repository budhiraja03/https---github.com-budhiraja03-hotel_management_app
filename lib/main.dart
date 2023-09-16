import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hotel_management_app/screens/LoginScreen.dart';
import 'package:hotel_management_app/screens/homescreen2.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  runApp(MainApp(user: user));
}

class MainApp extends StatelessWidget {
  final User? user;
  const MainApp({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user!=null ?
              HomeScreen2(user: user):const LoginScreen()
    );
  }
}

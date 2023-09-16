import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_management_app/screens/LoginScreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  Future<void> _initializeApp() async {
    // Perform app initialization tasks here
    // For example: fetching data, setting up services, etc.
    
    // Simulate a delay for the splash screen (e.g., 2 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to the login screen and replace the splash screen
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen()),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 222, 247),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('images/suitcase.jpg'),
              radius: 150,
            ),
            const SizedBox(height: 20),
            Text("Seamlessly Managed Stays",
            style: GoogleFonts.getFont('Shadows Into Light',
              fontSize: 34,
              color: Colors.black,
              fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AnimatedTextKit(
              repeatForever: true,
                animatedTexts: [
                  TyperAnimatedText("Let's Explore",
                      speed: const Duration(milliseconds: 150),
                      textStyle: GoogleFonts.getFont(
                        'Play',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 248, 90, 156))
                        )],
            ),
          ],
        ),
      ),
    );
  }
}
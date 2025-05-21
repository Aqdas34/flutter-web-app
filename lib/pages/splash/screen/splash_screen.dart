import 'package:flutter/material.dart';
import 'package:only_shef/pages/home/screen/home_screen.dart';
import 'dart:async';
import 'package:only_shef/pages/login_sign/login_or_signup.dart';
import 'package:only_shef/pages/splash/services/splash_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  SplashServices services = SplashServices();

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Animation duration for slide and fade
      vsync: this,
    );

    // Define the sliding animation from top to center
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1), // Start from top
      end: Offset(0, 0), // End at the center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Animation curve
    ));

    // Define the fade-out animation
    _fadeAnimation = Tween<double>(
      begin: 1.0, // Start fully visible
      end: 0.0, // End fully transparent
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Animation curve
    ));

    // Start the slide animation
    _controller.forward();

    // After the slide animation is complete, wait for the logo to stay visible for a moment before fading out
    Timer(Duration(seconds: 2), () {
      _controller.reverse(); // Start fade-out after the slide is done
    });

    navigateUser();
    // Navigate to the home screen after the fade-out completes
    // Timer(Duration(seconds: 4), () {

    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginOrSignup()),
    //   );
    // });
  }

  // Asynchronous function for navigation logic
  void navigateUser() async {
    await Future.delayed(Duration(seconds: 4)); // Wait for 4 seconds

    // For testing, directly navigate to login screen
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginOrSignup()),
        (route) => false,
      );
    }

    // Comment out the original code for now
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');

    // Check if token exists
    if (token != null && token.isNotEmpty) {
      if (mounted) {
        await services.getUserData(token, context);
        // If token exists, navigate to HomeScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false, // This line removes all previous routes
        );
      }
    } else {
      if (mounted) {
        // If no token, navigate to LoginOrSignup screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginOrSignup()),
          (route) => false, // This line removes all previous routes
        );
      }
    }
    */
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC1BFC1), // Set splash screen background color
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation, // Apply fade-out transition
          child: SlideTransition(
            position: _slideAnimation, // Apply slide-in transition
            child: Image.asset(
              'assets/logo.png', // Replace with your image path
              width: 300, // Set the width of the image
              height: 300, // Set the height of the image
            ),
          ),
        ),
      ),
    );
  }
}

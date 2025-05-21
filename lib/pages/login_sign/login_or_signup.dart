import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/pages/auth/login/screen/login_screen.dart';
import 'package:only_shef/pages/auth/register/screens/register_screen.dart';

class LoginOrSignup extends StatelessWidget {
  const LoginOrSignup({super.key});

  // Function to handle the navigation with animation to the Login page
  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide, fade, and scale transitions
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
          var scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(animation);

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: SlideTransition(position: offsetAnimation, child: child),
            ),
          );
        },
      ),
    );
  }

  // Function to handle the navigation with animation to the Register page
  void _navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RegisterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide, fade, and scale transitions
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
          var scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(animation);

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: SlideTransition(position: offsetAnimation, child: child),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Light background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  // Green shapes (First Positioned container)
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Transform.rotate(
                      angle: -0.1, // Slight rotation
                      child: Container(
                        height: 86.78,
                        width: 374.8,
                        decoration: BoxDecoration(
                          color: primaryColor, // Dark green color
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  // Chef image
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/chef.png', // Your chef image path
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              // Now, place the second green shape below the image
              // const SizedBox(height: 20), // Add some spacing
              Transform.rotate(
                angle: -0.1, // Slight rotation
                child: Container(
                  height: 86.78,
                  width: 297,
                  decoration: BoxDecoration(
                    color: secondryColor, // Light green color
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 80), // Add some spacing
              // Text content
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get Started",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Empowering chefs to craft\nunforgettable culinary experiences.",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => _navigateToRegisterPage(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFC3DEA9), // Light green button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(13), // Reduced radius
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 55), // Increased width
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => _navigateToLoginPage(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF1E451B), // Dark green button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(13), // Reduced radius
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 60), // Increased width
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

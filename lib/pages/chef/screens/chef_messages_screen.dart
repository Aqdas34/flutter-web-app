import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/widgets/chef_nav_bar.dart';

class ChefMessagesScreen extends StatefulWidget {
  const ChefMessagesScreen({super.key});

  @override
  State<ChefMessagesScreen> createState() => _ChefMessagesScreenState();
}

class _ChefMessagesScreenState extends State<ChefMessagesScreen> {
  int _currentIndex = 2; // Messages index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDF7F2),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E451B),
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message_outlined,
                  size: 80,
                  color: Color(0xFF1E451B),
                ),
                SizedBox(height: 16),
                Text(
                  'No Messages Yet',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your customer messages will appear here',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Color(0xFF707070),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 50,
            right: 50,
            child: ChefNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, '/chef-home');
                    break;
                  case 1:
                    Navigator.pushReplacementNamed(
                        context, '/chef-appointments');
                    break;
                  case 2:
                    // Already on messages screen
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(context, '/profile-settings');
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:only_shef/pages/chef/home/screens/chef_home_screen.dart';
import 'package:only_shef/pages/chef_appointments/screens/chef_appointments.dart';
import 'package:only_shef/pages/chat/screen/messages_screen.dart';
import 'package:only_shef/pages/profile_setting/screen/profile_setting.dart';

class ChefNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ChefNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<ChefNavigationBar> createState() => _ChefNavigationBarState();
}

class _ChefNavigationBarState extends State<ChefNavigationBar> {
  // List of icons and corresponding screens
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.calendar_today, 'label': 'Appointments'},
    {'icon': Icons.message, 'label': 'Messages'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1E451B), // Dark green background
        borderRadius: BorderRadius.circular(50),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _navItems.length,
          (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = index == widget.currentIndex;

    return GestureDetector(
      onTap: () {
        widget.onTap(index);
      },
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Color(0xFF355B34), // White when selected, light green otherwise
          shape: BoxShape.circle,
          border: Border.all(
              color: Color(0xFF355B34), width: 2), // Light green border
        ),
        child: Icon(
          _navItems[index]['icon'],
          color: isSelected
              ? Colors.green[900]
              : Colors.white, // Green when selected, white otherwise
          size: 35,
        ),
      ),
    );
  }
}

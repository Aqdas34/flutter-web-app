import 'package:flutter/material.dart';

class CustomProfileWidget extends StatelessWidget {
  final IconData icon;
  final String rowTitle;
  final String rowText;
  final Widget? trainlingIcon;
  final bool isSwitchProfile;
  final bool isLogout;

  const CustomProfileWidget(
      {super.key,
      required this.icon,
      required this.rowTitle,
      required this.rowText,
      this.trainlingIcon,
      this.isSwitchProfile = false,
      this.isLogout = false});

  @override
  Widget build(BuildContext context) {
    return const Row(
      
    );
  }
}

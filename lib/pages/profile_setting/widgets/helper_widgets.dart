import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/login_sign/login_or_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/colors/colors.dart';

Widget buildSectionHeader(String title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 25),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF707070)),
      ),
    ),
  );
}

Widget buildSettingsCard(List<Widget> children) {
  return Card(
    margin: EdgeInsets.zero,
    color: Color(0xFFF0F0F0),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
    child:
        Column(mainAxisAlignment: MainAxisAlignment.start, children: children),
  );
}

Widget buildSwitchTile({
  required IconData icon,
  required String title,
  String? subtitle,
  required bool value,
  required Function(bool) onChanged,
}) {
  return SizedBox(
    height: 45,
    child: Align(
      child: SwitchListTile(
        // minVerticalPadding: 0, // else 2px still present
        dense: true, // else 2px still present
        visualDensity: VisualDensity.compact, // Else theme will be use
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
// Removed padding
        secondary: Container(
            margin: EdgeInsets.zero, // Removed margin
            padding: EdgeInsets.zero, // Ensure no padding
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Icon(icon, size: 20, color: Color(0xFF707070))),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              )
            : null,
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
    ),
  );
}

Widget buildNavigationTile({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    margin: EdgeInsets.zero,
    height: 43,
    child: ListTile(
      minVerticalPadding: 0, // else 2px still present
      dense: true, // else 2px still present
      visualDensity: VisualDensity.compact, // Else theme will be use
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
// Removed padding

      leading: Container(
          margin: EdgeInsets.zero, // Removed margin
          padding: EdgeInsets.zero, // Ensure no padding
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Icon(icon, size: 20, color: Color(0xFF707070))),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    ),
  );
}

Widget buildLogoutButton(BuildContext context) {
  return InkWell(
    onTap: () {
      showLogoutDialog(context);
    },
    child: SizedBox(
      height: 43,
      child: ListTile(
        minVerticalPadding: 0, // else 2px still present
        dense: true, // else 2px still present
        visualDensity: VisualDensity.compact, // Else theme will be use
        contentPadding: EdgeInsets.symmetric(horizontal: 20),

// Ensure no padding
        leading: Container(
            height: 30,
            width: 30,
            padding: EdgeInsets.zero, // Ensure no padding
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFFF63C4E).withOpacity(0.33)),
            child: Icon(Icons.logout, size: 20, color: Color(0xFFD82300))),
        title: Text(
          "Logout",
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red),
        ),
      ),
    ),
  );
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Confirm Logout",
            textAlign: TextAlign.center,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          // Increase width
          child: Text(
            "Are you sure you want to logout?",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF117BE8).withAlpha(33),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Add your logout logic here
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(color: Color(0xFF117BE8)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async{
                  Navigator.pop(context);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('x-auth-token');
                  Navigator.pushAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => LoginOrSignup()),
                    (route) => false,
                  );

                  // Add your logout logic here
                },
                child: Text(
                  "Logout",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

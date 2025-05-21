import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  CircleAvatar(
                    radius: 52.5,
                    backgroundImage: AssetImage('assets/chef_image.jpg'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Junaid Rafiq",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "junaidrafiq007@gmail.com",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF707070),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 35,
                    width: 93,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Center(
                      child: Text(
                        "Edit Profile",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Inventories",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF707070),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Container(
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Column(
                  children: [],
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/pages/chef_appointments/screens/appointment_details_screen.dart';
import 'package:only_shef/pages/chef_appointments/models/appointment.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../provider/profile_state_provider.dart';
import '../../chat/screen/chat_screen.dart';


class AppointmentWidget extends StatelessWidget {
  final Appointment appointment;

  const AppointmentWidget({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final profileState = Provider.of<ProfileStateProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Stack(children: [
        ClipPath(
          clipper: CustomCardClipper(),
          child: Container(
            height: 240,
            padding: EdgeInsets.only(top: 15, left: 15),
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      appointment.chefInfo.name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      appointment.userId.isNotEmpty
                          ? appointment.userId['name']
                          : "Chef",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 149, 170, 127),
                              borderRadius: BorderRadius.circular(3)),
                          child: Icon(
                            Icons.timer_sharp,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          DateFormat('dd MMM, yyyy').format(appointment.date),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 149, 170, 127),
                              borderRadius: BorderRadius.circular(3)),
                          child: Icon(
                            Icons.timer_sharp,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          appointment.time,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 90,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            chef: appointment.chefInfo,
                                            currentUserId:
                                                appointment.userId['_id'] ?? '',
                                          )));
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 133, 152, 113),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Chat  ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  height: 240,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/newchef.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 18,
          left: 12,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentDetailsScreen(
                    appointment: appointment,
                    isFromPending: profileState.isChefProfile &&
                        appointment.status.toLowerCase().contains('pending'),
                    isFromAccepted: profileState.isChefProfile &&
                        appointment.status.toLowerCase().contains('accepted'),
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 33,
              backgroundColor: primaryColor,
              child: Icon(
                Icons.arrow_outward_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 30.0; // Border radius for corners

    final path = Path();
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0); // Top-left rounded corner
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(
        size.width, 0, size.width, radius); // Top-right rounded corner
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius,
        size.height); // Bottom-right rounded corner

    // Bottom-left custom cutout
    path.lineTo(90 + radius, size.height);
    path.quadraticBezierTo(90, size.height, 90, size.height - radius);

    path.quadraticBezierTo(90, size.height - 80, radius, size.height - 75);

    path.quadraticBezierTo(0, size.height - 75, 0, size.height - 75 - radius);

    path.lineTo(0, radius); // Close path for smooth rounded finish
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

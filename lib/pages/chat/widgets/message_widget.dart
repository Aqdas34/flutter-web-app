import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';

class MessageItemWidget extends StatelessWidget {
  final String profilePicture;
  final String name;
  final String message;
  final String time;
  final bool isUnread;
  final String numberofMessagesPending;

  const MessageItemWidget({
    super.key,
    required this.profilePicture,
    required this.name,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.numberofMessagesPending,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(profilePicture),
          ),
          const SizedBox(width: 15),

          // Chat details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Time
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF707070),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: isUnread
                      ? const EdgeInsets.only(top: 0.0)
                      : const EdgeInsets.only(top: 3.0),
                  child: Row(
                    children: [
                      if (!isUnread)
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.done_all,
                            size: 15,
                            color: primaryColor,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          message,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: isUnread ? Colors.black : Colors.grey,
                            fontWeight:
                                isUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 10.0, top: 4.0),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: primaryColor,
                            child: Text(
                              numberofMessagesPending,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Text(
                //   message,
                //   style: GoogleFonts.poppins(
                //     fontSize: 10,
                //     color: isUnread ? Colors.black : Colors.grey,
                //     fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                //   ),
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ),
          ),

          // Unread indicator
          // if (isUnread)
          //   Padding(
          //     padding: const EdgeInsets.only(left: 8.0),
          //     child: CircleAvatar(
          //       radius: 5,
          //       backgroundColor: primaryColor,
          //     ),
          //   ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../../../provider/user_provider.dart';
import '../../chat/screen/chat_screen.dart';

import '../../cuisine/models/chef.dart';
import '../../send_offer/screens/send_offer_screen.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final String bio;
  final int rating;
  final String image;
  final List<String> tags;
  final Chef chef;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.username,
    required this.bio,
    required this.rating,
    required this.image,
    required this.tags,
    required this.chef,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none, // Allows profile image to overflow
          alignment: Alignment.center,
          children: [
            // Container(
            //   height: 206,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.black,
            //   ),
            // ),
            Image.network(
              "https://example.com/chef_background.png",
              height: 206, // Increased height for better positioning
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Container(
                    height: 206,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container(
                  height: 206,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 206, // Same height as the image
                width: double.infinity,
                color: Colors.black
                    .withOpacity(0.5), // Placeholder color with opacity
              ),
            ),
            Positioned(
              bottom: -50, // Moves profile picture into the white section
              child: Container(
                padding: EdgeInsets.all(10), // White border padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 80, // Slightly larger size
                  backgroundImage: NetworkImage(chef.profileImage),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 40), // Adjusted spacing after profile image
        Text(
          chef.name,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(chef.username,
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 10,
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            chef.bio,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rating:  ",
              style: GoogleFonts.poppins(
                fontSize: 13,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                chef.rating.floor(),
                (index) => Icon(Icons.star, color: Colors.amber, size: 13),
              ),
            ),
          ],
        ),

        SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: chef.specialties.take(3).map((tag) {
            return Chip(
              avatar: Icon(Icons.tag, color: Colors.black, size: 15),
              label: Text(
                tag,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                ),
              ),
              backgroundColor: Colors.grey.shade200,
            );
          }).toList(),
        ),
        // SizedBox(height: 2),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    // Prepare booked dates set
                    final bookedDates = chef.bookedDates
                        .map((b) => DateTime.tryParse(b.date))
                        .whereType<DateTime>()
                        .toSet();
                    DateTime? selectedDate;
                    bool isDateAvailable(DateTime date) {
                      final now = DateTime.now();
                      final lastAllowed =
                          DateTime(now.year, now.month + 1, now.day);
                      final isBooked = bookedDates.any((d) =>
                          d.year == date.year &&
                          d.month == date.month &&
                          d.day == date.day);
                      final isInRange = !date.isBefore(
                              DateTime(now.year, now.month, now.day)) &&
                          !date.isAfter(lastAllowed);
                      return isInRange && !isBooked;
                    }

                    await showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              title: Text(
                                'Book Chef',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: primaryColor,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 350,
                                    height: 350,
                                    child: CalendarCarousel(
                                      onDayPressed: (date, events) {
                                        if (!isDateAvailable(date)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Please select a valid, available date.')),
                                          );
                                          return;
                                        }
                                        setState(() {
                                          selectedDate = date;
                                        });
                                      },
                                      selectedDateTime: selectedDate,
                                      minSelectedDate: DateTime.now(),
                                      maxSelectedDate: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month + 1,
                                          DateTime.now().day),
                                      weekendTextStyle: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      weekdayTextStyle: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      headerTextStyle: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      daysTextStyle: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      selectedDayButtonColor: secondryColor,
                                      selectedDayBorderColor: secondryColor,
                                      todayButtonColor: selectedDate == null
                                          ? secondryColor
                                          : Colors.transparent,
                                      todayBorderColor: selectedDate == null
                                          ? secondryColor
                                          : Colors.transparent,
                                      thisMonthDayBorderColor:
                                          Colors.transparent,
                                      customDayBuilder: (
                                        bool isSelectable,
                                        int index,
                                        bool isSelectedDay,
                                        bool isToday,
                                        bool isPrevMonthDay,
                                        TextStyle textStyle,
                                        bool isNextMonthDay,
                                        bool isThisMonthDay,
                                        DateTime day,
                                      ) {
                                        final isBooked = bookedDates.any((d) =>
                                            d.year == day.year &&
                                            d.month == day.month &&
                                            d.day == day.day);
                                        if (isBooked) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${day.day}',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                        return null;
                                      },
                                      daysHaveCircularBorder: true,
                                      height: 350.0,
                                      showOnlyCurrentMonthDate: true,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: (selectedDate != null &&
                                              isDateAvailable(selectedDate!))
                                          ? () {
                                              // TODO: Implement send offer logic
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SendOfferScreen(
                                                    chefId: chef.id,
                                                    selectedDate: selectedDate!,
                                                    chef: chef,
                                                  ),
                                                ),
                                              );
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        'Send Offer',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondryColor,
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  child: Text(
                    "Book Chef",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder<String?>(
                          future: getCurrentUserId(context),
                          builder: (context, snapshot) {
                            return ChatScreen(
                              chef: chef,
                              currentUserId: snapshot.data!,
                            );
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E451B),
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  child: Text(
                    "Message",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<String?> getCurrentUserId(BuildContext context) async {
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString('userId');
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return user.id;
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:provider/provider.dart';
// import 'package:only_shef/pages/cuisine_item_details/widgets/Tags_Widget.dart';
import '../../../models/user.dart';
import '../../../provider/profile_state_provider.dart';
import '../../../provider/user_provider.dart';

import '../widgets/tags_widget.dart';
import 'package:only_shef/pages/cuisine_item_details/widgets/hexagon_icon.dart';
import 'package:only_shef/pages/chef/add_cuisine/screens/add_cuisine.dart';

import '../../chat/screen/chat_screen.dart';
import '../../cuisine/models/chef.dart';
import '../../cuisine/models/cuisines.dart';

class CuisineItemDetails extends StatelessWidget {
  const CuisineItemDetails(
      {super.key, required this.cuisine, required this.chef});
  final Cuisine cuisine;
  final Chef chef;
  final String chefName = "Alex Bhatti";
  final String chuisineName = "Chicken Biryani";
  final bool isChefAvaiblable = true;

  @override
  Widget build(BuildContext context) {
    final profileState = Provider.of<ProfileStateProvider>(context);
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Color(0xffFDF7F2),
      appBar: profileState.isChefProfile
          ? AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCuisineScreen(
                          chefId: chef.id,
                          cuisine: cuisine,
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  SafeArea(
            //    child:
            Container(
              height: 283,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: primaryColor,
                image: DecorationImage(
                  image: NetworkImage(cuisine.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              //    ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                cuisine.name,
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.centerLeft,
              child: Text("Cuisines",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TagsWidget(value: cuisine.cuisineType),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.centerLeft,
              child: Text(
                "Ingredients",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Wrap(
                    spacing: 10, // Add spacing between tags
                    children: [
                      for (int i = 0;
                          i < cuisine.ingredients.length && i < 3;
                          i++)
                        TagsWidget(value: cuisine.ingredients[i]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 28,
            ),
            if (!profileState.isChefProfile)
              Container(
                height: 66,
                margin: EdgeInsets.symmetric(horizontal: 7),
                padding: EdgeInsets.only(left: 20, right: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFE1E1D7),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Use an Image for the icon
                    ClipPath(
                      clipper: HexagonClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              chef.availabilityStatus == "true"
                                  ? Colors.teal.shade700
                                  : Colors.red.shade700, // Darker red
                              chef.availabilityStatus == "true"
                                  ? Colors.green
                                  : Colors.red, // Base red
                              Colors.white38, // Shiny effect
                            ],
                            stops: [0.0, 0.7, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Icon(
                            Icons.remove, // The minus icon
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 16), // Spacing between the icon and the text
                    if (!profileState.isChefProfile)
                      Expanded(
                        child: Text(
                          chef.availabilityStatus == "true"
                              ? 'Congratulations, the Chef is available. Chef ${chef.name} is usually fully booked.'
                              : 'Sadly, The Chef is all Booked , You can hire him Later',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black.withAlpha((0.6 * 255).toInt()),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                  ],
                ),
              ),

            SizedBox(
              height: 28,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                cuisine.description,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              height: 28,
            ),
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff1E451B),
              ),
            ),
            SizedBox(
              height: 28,
            ),
            if (!profileState.isChefProfile)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 7),
                height: 205,
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0xffE1E1D7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This Service includes",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons
                              .kitchen_rounded, // Use kitchen icon for "All Ingredients"
                          size: 35,
                          color: Color.fromARGB(255, 153, 115, 26),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "All Ingredients",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF846518)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons
                              .airplanemode_active_rounded, // Use airplane icon for "Chef's travel and insurance costs"
                          size: 35,
                          color: Color.fromARGB(255, 153, 115, 26),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Chef's travel and insurance costs",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF846518)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons
                              .cleaning_services_rounded, // Use cleaning services icon for "Serving and Cleanup"
                          size: 35,
                          color: Color.fromARGB(255, 153, 115, 26),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Serving and Cleanup",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF846518)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 20,
            ),
            if (!profileState.isChefProfile)
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RS ${cuisine.price}",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Material(
                        color: Color(0xff1E451B),
                        borderRadius: BorderRadius.circular(6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {},
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FutureBuilder<String?>(
                                          future: getCurrentUserId(context),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                            if (snapshot.hasError ||
                                                !snapshot.hasData) {
                                              return const Center(
                                                  child: Text(
                                                      'Error loading user data'));
                                            }
                                            return ChatScreen(
                                              chef: chef,
                                              currentUserId: snapshot.data!,
                                            );
                                          },
                                        ))),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                "Message Chef",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> getCurrentUserId(BuildContext context) async {
  final User user = Provider.of<UserProvider>(context, listen: false).user;
  return user.id;
}

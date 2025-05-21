import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/chef_profile/screen/review_card.dart';
import 'package:only_shef/pages/chef_profile/widgets/profile_header.dart';

import '../../cuisine/models/chef.dart';

class ChefProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> allReviews = [
    {
      "name": "Mahad Masih",
      "location": "Lahore, Pakistan",
      "review":
          "The nihari was absolutely delicious! The chef's spices and flavors were perfect—just like authentic Pakistani cuisine!",
      "image": "assets/chef_image.jpg",
      "rating": 5,
    },
    {
      "name": "Huzaifa Rauf",
      "location": "Texas, USA",
      "review":
          "The nihari was absolutely delicious! The chef's spices and flavors were perfect—just like authentic Pakistani cuisine!",
      "image": "assets/chef_image.jpg",
      "rating": 4,
    },
  ];

  ChefProfileScreen({super.key, required this.chef});

  final Chef chef;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs
      child: Scaffold(
        // appBar: AppBar(title: Text("Chef Profile")),
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeader(
                chef: chef,
                name: chef.name,
                username: chef.username,
                bio: chef.bio,
                rating: chef.rating.toInt(),
                image: chef.profileImage,
                tags: chef.specialties,
              ),
              Container(
                color: Colors.white,
                child: Theme(
                  data: ThemeData(
                    tabBarTheme: TabBarTheme(
                      dividerColor: Colors
                          .transparent, // Removes the grey line under TabBar
                    ),
                  ),
                  child: TabBar(
                    labelColor: Color(0xFF1E451B),
                    indicatorColor: Color(0xFF1E451B),
                    unselectedLabelColor: Colors.black,
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 30),
                    tabs: [
                      Tab(text: "All Reviews (${allReviews.length})"),
                      Tab(text: "Repeated (40)"),
                      Tab(text: "Cuisines (5)"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // All Reviews Tab
                    Flexible(
                      // Use Flexible instead of Expanded
                      child: ListView.builder(
                        itemCount: allReviews.length,
                        itemBuilder: (context, index) {
                          return ReviewCard(
                            name: allReviews[index]["name"]!,
                            location: allReviews[index]["location"]!,
                            review: allReviews[index]["review"]!,
                            image: allReviews[index]["image"]!,
                            rating: allReviews[index]["rating"]!,
                          );
                        },
                      ),
                    ),
                    // Repeated Reviews Tab (Example: Filtering "Mahad Masih" reviews)
                    Flexible(
                      // Use Flexible instead of Expanded
                      child: ListView.builder(
                        itemCount: allReviews
                            .where((review) => review["name"] == "Mahad Masih")
                            .length,
                        itemBuilder: (context, index) {
                          final repeatedReviews = allReviews
                              .where(
                                  (review) => review["name"] == "Mahad Masih")
                              .toList();
                          return ReviewCard(
                            name: repeatedReviews[index]["name"]!,
                            location: repeatedReviews[index]["location"]!,
                            review: repeatedReviews[index]["review"]!,
                            image: repeatedReviews[index]["image"]!,
                            rating: repeatedReviews[index]["rating"]!,
                          );
                        },
                      ),
                    ),
                    // Cuisines Tab (Currently Empty)
                    Center(child: Text("Cuisines data coming soon!")),
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

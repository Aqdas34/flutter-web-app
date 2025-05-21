import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/chef_profile/screen/chef_profile.dart';
import 'package:only_shef/pages/cuisine/models/cuisines.dart';
import 'package:only_shef/pages/cuisine/services/chef_gig_services.dart';
import 'package:only_shef/pages/cuisine/widgets/chef_gig.dart';
import 'package:only_shef/pages/cuisine/widgets/cuisine_widget.dart';
import 'package:only_shef/pages/cuisine_item_details/screens/cuisine_item_details.dart';
import 'package:only_shef/widgets/custom_menu_button.dart';

import '../../../common/colors/colors.dart';
import '../models/chef.dart';

class CuisineScreen extends StatefulWidget {
  final String imagePath;
  final String cuisineName;
  const CuisineScreen(
      {super.key, required this.imagePath, required this.cuisineName});

  @override
  State<CuisineScreen> createState() => _CuisineScreenState();
}

final List<String> chef = ["ibad", "ali", "ahmed"];

class _CuisineScreenState extends State<CuisineScreen> {
  int _selectedType = 0;
  ChefGigServices chefGigServices = ChefGigServices();
  List<Chef> chefs = [];
  List<Cuisine> cuisines = [];
  int currentChefIndes = 0;
  bool cuisineShowable = false;
  bool isLoading = true;

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    chefs = await chefGigServices.getChefProfiles(context, widget.cuisineName);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDF7F2),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                // color: Colors.yellow,
                ),
            child: Stack(
              children: [
                Positioned(
                  top: 70,
                  left: 30,
                  child: InkWell(
                    child: ThreeGreenBarsMenu(),
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Positioned(
                  right: -30,
                  top: 50,
                  child: SizedBox(
                    height: 230,
                    width: 180,
                    child: Image(
                      image: AssetImage(
                        widget.imagePath,
                      ),
                      width: 180,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  top: 26,
                  right: -80,
                  child: CircularText(
                    radius: 137,
                    position: CircularTextPosition.inside,
                    children: [
                      TextItem(
                        text: Text(
                          widget.cuisineName,
                          style: GoogleFonts.poppins(
                            fontSize: 31,
                            color: Color.fromARGB(40, 30, 69, 27),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        space: 10,
                        startAngleAlignment: StartAngleAlignment.center,
                        startAngle: -190,
                        direction: CircularTextDirection.clockwise,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 160,
                    left: 25,
                    child: Text(
                      widget.cuisineName.replaceFirst(' ', '\n'),
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        color: Color.fromARGB(
                          255,
                          30,
                          69,
                          27,
                        ),
                        fontWeight: FontWeight.w800,
                      ),
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedType = 0;
                  });
                },
                child: Text(
                  "Chefs",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color.fromARGB(255, 30, 69, 27),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 30),
              if (cuisineShowable == true)
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedType = 1;
                    });
                  },
                  child: Text(
                    "Cuisines",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Color.fromARGB(255, 30, 69, 27),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 6,
                width: 90,
                decoration: BoxDecoration(
                  color: _selectedType == 1
                      ? Color.fromARGB(55, 30, 69, 27)
                      : Color(0xFF1E451B),
                ),
              ),
              Container(
                height: 6,
                width: 90,
                decoration: BoxDecoration(
                  color: _selectedType == 0
                      ? cuisineShowable
                          ? Color.fromARGB(55, 30, 69, 27)
                          : Color(0xFF1E451B)
                      : Color(0xFF1E451B),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1E451B),
                    ),
                  )
                : _selectedType == 0
                    ? chefs.isEmpty
                        ? Center(
                            child: Text(
                              'No chef is available',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => InkWell(
                              onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChefProfileScreen(
                                              chef: chefs[index],
                                            )));
                              },
                              onTap: () async {
                                cuisines = await chefGigServices.getChefCuisine(
                                    context, chefs[index].id);
                                setState(() {
                                  cuisineShowable = true;
                                  _selectedType = 1;
                                  currentChefIndes = index;
                                });
                              },
                              child: ChefGig(
                                chef: chefs[index],
                              ),
                            ),
                            itemCount: chefs.length,
                          )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CuisineItemDetails(
                                          cuisine: cuisines[index],
                                          chef: chefs[currentChefIndes],
                                        )));
                          },
                          child: SingleCuisineWidget(
                            rating: 4,
                            cuisineName: cuisines[index].name,
                            imageUrl: cuisines[index].imageUrl,
                            location: chefs[currentChefIndes]
                                .address
                                .split(' ')
                                .first,
                            totalOrders: 500,
                            cuisineType: cuisines[index].cuisineType,
                          ),
                        ),
                        itemCount: cuisines.length,
                      ),
          ),
        ],
      ),
    );
  }
}

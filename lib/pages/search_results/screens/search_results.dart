import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:only_shef/pages/chef_profile/screen/chef_profile.dart';
import 'package:only_shef/pages/cuisine/models/cuisines.dart';
import 'package:only_shef/pages/cuisine/services/chef_gig_services.dart';
import 'package:only_shef/pages/cuisine/widgets/chef_gig.dart';
import 'package:only_shef/pages/cuisine/widgets/cuisine_widget.dart';
import 'package:only_shef/pages/cuisine_item_details/screens/cuisine_item_details.dart';
import 'package:only_shef/pages/search_results/services/search_services.dart';

import '../../../common/colors/colors.dart';
import '../../../common/constants/show_snack_bar.dart';
import '../../cuisine/models/chef.dart';

class SearchResults extends StatefulWidget {
  final String cuisineType;
  final int chefBudget;
  final DateTime initialDate;
  final DateTime endDate;

  // final String imagePath;
  final String cuisineName;
  const SearchResults(
      {super.key,
      required this.cuisineName,
      required this.cuisineType,
      required this.chefBudget,
      required this.initialDate,
      required this.endDate});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  int _selectedType = 0;
  ChefGigServices chefGigServices = ChefGigServices();
  SearchServices searchServices = SearchServices();
  List<Chef> chefs = [];
  List<Cuisine> cuisines = [];
  int currentChefIndes = 0;
  bool cuisineShowable = false;
  bool isLoading = true;

  void fetchData() async {
    try {
      // Format dates to ISO string format
      final startDate = widget.initialDate.toIso8601String();
      final endDate = widget.endDate.toIso8601String();

      // Search chefs by availability
      chefs = await searchServices.searchByAvailability(
          context, startDate, endDate);

      // Filter chefs by cuisine name
      if (widget.cuisineName.isNotEmpty) {
        chefs = chefs
            .where((chef) => chef.specialties.any((specialty) => specialty
                .toLowerCase()
                .contains(widget.cuisineType.toLowerCase())))
            .toList();
      }
      print(widget.cuisineType);

      if (chefs.isEmpty) {
        showSnackBar(context, "No chefs available for the selected dates");
      } else {
        showSnackBar(context, "Chefs available for the selected dates");
      }
    } catch (e) {
      showSnackBar(context, "Error searching chefs: ${e.toString()}");
      // print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 80, left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Total Results (${chefs.length})",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Color.fromARGB(255, 30, 69, 27),
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                SizedBox(height: 25),
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
                  child: _selectedType == 0
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
                                          builder: (context) =>
                                              ChefProfileScreen(
                                                chef: chefs[index],
                                              )));
                                },
                                onTap: () async {
                                  cuisines = await chefGigServices
                                      .getChefCuisine(context, chefs[index].id);
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

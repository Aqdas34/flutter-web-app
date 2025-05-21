import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/main.dart';
import 'package:only_shef/pages/search_results/screens/search_results.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

bool isFilterSelected = false;
List<String> cuisineTypes = [
  "Pakistani",
  "Chinese",
  "Italian",
  "Mexican",
  "Fast Food",
  "Others",
  "Thai"
];
List<bool> cuisineBools = [true, false, false, false, false, false];

List<String> chefTypes = [
  "Pakistani",
  "Chinese",
  "Mexican",
  "Thai",
  "Continental",
];
List<bool> chefBools = [false, false, false, false, false];

List<String> priceRanges = [
  "Under 5k",
  "5k-10k",
  "10k-15k",
  "15k-20k",
  "20k-25k",
  "Above 30k",
];
List<bool> priceBools = [true, false, false, false, false, false];

DateTime initialDate = DateTime.now();
DateTime finalDate = DateTime.now().add(Duration(days: 30));

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: screen_height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 25,
                  ),
                ),
                SizedBox(
                  width: screen_width * 0.04,
                ),
                Text(
                  "Filter",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFilterSelected = false;
                      cuisineBools =
                          cuisineBools.map<bool>((v) => false).toList();
                      cuisineBools[0] = true;
                      chefBools = chefBools.map<bool>((v) => false).toList();
                      priceBools = priceBools.map<bool>((v) => false).toList();
                      priceBools[0] = true;
                      initialDate = DateTime.now();
                      finalDate = DateTime.now().add(Duration(days: 30));
                    });
                  },
                  child: Text(
                    "Clear All",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff707070),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            endIndent: screen_width * 0.05,
            indent: screen_width * 0.05,
          ),
          SizedBox(
            height: screen_height * 0.02,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Cuisine Type",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff707070),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
                padding: EdgeInsets.only(right: 8, left: 8),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      backgroundColor: backgroundColor,
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(cuisineTypes[index]),
                      ),
                      labelStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff707070)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(153),
                      ),
                      selected: cuisineBools[index],
                      selectedColor: secondryColor,
                      selectedShadowColor: secondryColor,
                      onSelected: (check) {
                        setState(() {
                          cuisineBools =
                              cuisineBools.map<bool>((v) => false).toList();
                          cuisineBools[index] = check;
                        });
                      },
                      checkmarkColor: primaryColor,
                      pressElevation: 3,
                      deleteIcon: Icon(
                        Icons.close,
                        size: 15,
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: screen_height * 0.02,
          ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 20),
          //     child: Text(
          //       "Chef",
          //       style: GoogleFonts.poppins(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //         color: Color(0xff707070),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 60,
          //   child: Expanded(
          //     flex: 1,
          //     child: ListView.builder(
          //         padding: EdgeInsets.only(right: 8, left: 8),
          //         scrollDirection: Axis.horizontal,
          //         itemCount: 5,
          //         physics: const BouncingScrollPhysics(),
          //         itemBuilder: (context, index) {
          //           return Padding(
          //             padding: const EdgeInsets.only(right: 8.0),
          //             child: FilterChip(
          //               backgroundColor: backgroundColor,
          //               label: Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //                 child: Text(chefTypes[index]),
          //               ),
          //               labelStyle: GoogleFonts.poppins(
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.w500,
          //                   color: Color(0xff707070)),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(153),
          //               ),
          //               selected: chefBools[index],
          //               selectedColor: secondryColor,
          //               selectedShadowColor: secondryColor,
          //               onSelected: (check) {
          //                 setState(() {
          //                   chefBools[index] = !chefBools[index];
          //                 });
          //               },
          //               checkmarkColor: primaryColor,
          //               pressElevation: 3,
          //               deleteIcon: Icon(
          //                 Icons.close,
          //                 size: 15,
          //               ),
          //             ),
          //           );
          //         }),
          //   ),
          // ),
          // SizedBox(
          //   height: screen_height * 0.02,
          // ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Chef",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff707070),
                ),
              ),
            ),
          ),
          SizedBox(
            height: screen_height * 0.02,
          ),
          SizedBox(
            height: screen_height * 0.19,
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 4.5,
                ),
                padding: EdgeInsets.only(right: 8, left: 8),
                scrollDirection: Axis.vertical,
                itemCount: priceRanges.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: screen_width * 0.4,
                      child: FilterChip(
                        backgroundColor: backgroundColor,
                        label: Container(
                          height: 20,
                          width: screen_width * 0.38,
                          alignment: Alignment.center,
                          child: Text(
                            priceRanges[index],
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff707070),
                            ),
                          ),
                        ),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff707070)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(153),
                        ),
                        selected: priceBools[index],
                        selectedColor: secondryColor,
                        selectedShadowColor: secondryColor,
                        onSelected: (check) {
                          setState(() {
                            priceBools =
                                priceBools.map<bool>((v) => false).toList();
                            priceBools[index] = check;
                          });
                        },
                        checkmarkColor: primaryColor,
                        pressElevation: 3,
                        deleteIcon: Icon(
                          Icons.close,
                          size: 15,
                        ),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: screen_height * 0.02,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Dates",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff707070),
                ),
              ),
            ),
          ),
          SizedBox(
            height: screen_height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterChip(
                  backgroundColor: backgroundColor,
                  label: Container(
                    height: 20,
                    width: screen_width * 0.38,
                    alignment: Alignment.center,
                    child: Text(
                      "${initialDate.day}/${initialDate.month}/${initialDate.year}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff707070)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(153),
                  ),
                  selected: false,
                  selectedColor: secondryColor,
                  selectedShadowColor: secondryColor,
                  onSelected: (check) async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 30)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: primaryColor,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            dialogBackgroundColor: Colors.white,
                            textTheme: TextTheme(
                              displayLarge: GoogleFonts.poppins(),
                              displayMedium: GoogleFonts.poppins(),
                              displaySmall: GoogleFonts.poppins(),
                              headlineLarge: GoogleFonts.poppins(),
                              headlineMedium: GoogleFonts.poppins(),
                              headlineSmall: GoogleFonts.poppins(),
                              titleLarge: GoogleFonts.poppins(),
                              titleMedium: GoogleFonts.poppins(),
                              titleSmall: GoogleFonts.poppins(),
                              bodyLarge: GoogleFonts.poppins(),
                              bodyMedium: GoogleFonts.poppins(),
                              bodySmall: GoogleFonts.poppins(),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    setState(() {
                      if (date != null) {
                        initialDate = date;
                      }
                    });
                  },
                  checkmarkColor: primaryColor,
                  pressElevation: 3,
                  deleteIcon: Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
                FilterChip(
                  backgroundColor: backgroundColor,
                  label: Container(
                    height: 20,
                    width: screen_width * 0.38,
                    alignment: Alignment.center,
                    child: Text(
                      "${finalDate.day}/${finalDate.month}/${finalDate.year}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff707070)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(153),
                  ),
                  selected: false,
                  selectedColor: secondryColor,
                  selectedShadowColor: secondryColor,
                  onSelected: (check) async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 30)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: primaryColor,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            dialogBackgroundColor: Colors.white,
                            textTheme: TextTheme(
                              displayLarge: GoogleFonts.poppins(),
                              displayMedium: GoogleFonts.poppins(),
                              displaySmall: GoogleFonts.poppins(),
                              headlineLarge: GoogleFonts.poppins(),
                              headlineMedium: GoogleFonts.poppins(),
                              headlineSmall: GoogleFonts.poppins(),
                              titleLarge: GoogleFonts.poppins(),
                              titleMedium: GoogleFonts.poppins(),
                              titleSmall: GoogleFonts.poppins(),
                              bodyLarge: GoogleFonts.poppins(),
                              bodyMedium: GoogleFonts.poppins(),
                              bodySmall: GoogleFonts.poppins(),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    setState(() {
                      if (date != null) {
                        finalDate = date;
                      }
                    });
                  },
                  checkmarkColor: primaryColor,
                  pressElevation: 3,
                  deleteIcon: Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screen_height * 0.02,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isFilterSelected = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResults(
                          cuisineName: 'Pakistani',
                          cuisineType: cuisineTypes[cuisineBools
                              .indexWhere((element) => element == true)],
                          initialDate: initialDate,
                          endDate: finalDate,
                          chefBudget: priceBools
                                  .indexWhere((element) => element == true) +
                              1,
                        )),
              );
            },
            child: Container(
              width: screen_width * 0.95,
              height: screen_height * 0.05,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                "Show ALL",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

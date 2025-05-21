import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleCuisineWidget extends StatelessWidget {
  const SingleCuisineWidget({
    super.key,
    required this.rating,
    required this.cuisineName,
    required this.imageUrl,
    required this.location,
    required this.totalOrders,
    required this.cuisineType,
  });
  final int rating;
  final String cuisineName;
  final String location;
  final String imageUrl;
  final int totalOrders;
  final String cuisineType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        // color: Colors.cyan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cuisineName,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Icon(Icons.place, color: Colors.black),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            location,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$rating (0 reviews)",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                    // SizedBox(width: 10),
                    // Icon(
                    //   Icons.shopping_cart,
                    //   color: Colors.black,
                    // ),
                    // Text(
                    //   totalOrders.toString(),
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Icon(
                            Icons.food_bank,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            cuisineType,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 140,
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "$totalOrders+ orders",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

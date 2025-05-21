import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String location;
  final String review;
  final String image;
  final int rating; // New property for star rating

  const ReviewCard({
    super.key,
    required this.name,
    required this.location,
    required this.review,
    required this.image,
    required this.rating, // Accept rating as input
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(width: 1, color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image with Name & Location below it
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(image),
                ),
                const SizedBox(
                    height: 8), // Add some spacing between image and text
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  location,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Divider
            Container(
              width: 1,
              height: 120,
              color: Colors.grey.shade300,
            ),
            const SizedBox(width: 12),

            // Review Text and Rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),

                  // Review Text
                  Text(
                    review,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/cuisine/widgets/gig_arrow.dart';

class CustomCuisineCard extends StatelessWidget {
  const CustomCuisineCard(
      {super.key,
      required this.backColor,
      required this.imageLink,
      required this.cuisineName,
      required this.onTap});
  final Color backColor;
  final String imageLink;
  final String cuisineName;
  final VoidCallback onTap;
  final double size = 170;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0.176 * size,
              left: 0.22 * size,
              child: Container(
                width: 0.55 * size,
                height: 0.55 * size,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFF5F5F3),
                    )),
              ),
            ),
            Positioned(
              top: 0.117 * size,
              left: 0.164 * size,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 0.67 * size,
                height: 0.67 * size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Image(
                  image: AssetImage(
                    imageLink,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: 0.076 * size,
              left: 0.1 * size,
              child: Text(
                cuisineName,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
            Positioned(
              right: size * 0.10,
              bottom: 0.076 * size,
              child: GigArrow(
                size: 0.20 * size,
                color: backColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

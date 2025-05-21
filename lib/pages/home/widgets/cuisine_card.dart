import 'package:flutter/material.dart';

class CuisineCard extends StatelessWidget {
  final Color color;
  final String imagePath;
  final VoidCallback onTap;
  final double size; // Added a size parameter to control the round box size

  const CuisineCard({super.key, 
    required this.color,
    required this.imagePath,
    required this.onTap,
    this.size = 100.0, // Default size if not specified
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(size / 2), // Makes it round
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // Ensures the image fills the card
          ),
        ),
      ),
    );
  }
}

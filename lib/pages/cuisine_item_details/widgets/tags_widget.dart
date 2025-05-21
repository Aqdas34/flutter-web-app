import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagsWidget extends StatelessWidget {
  const TagsWidget({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Text(
        value,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}

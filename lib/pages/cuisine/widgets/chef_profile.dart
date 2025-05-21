import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChefProfile extends StatelessWidget {
  const ChefProfile({super.key, required this.chefName, required this.chefImage, required this.chefUsername});
   final String chefName ;
   final  String chefImage;
   final  String chefUsername ;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 190,
      height: 60,
      decoration: BoxDecoration(
        color: Color.fromARGB(40, 116, 113, 113),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(chefImage),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chefName,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              Text(
                "@$chefUsername",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

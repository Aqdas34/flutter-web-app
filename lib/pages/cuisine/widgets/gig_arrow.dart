import 'package:flutter/material.dart';

class GigArrow extends StatelessWidget {
  final double angle;
  final double size;
  final Color color;
  const GigArrow(
      {super.key,
      this.angle = 0.0,
      this.size = 50,
      this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
  
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Transform.rotate(
          angle: -3.14 / 50, // Correct the angle to -π/4 radians
          child: Center(
            child: Opacity(
              opacity: 1, // Modify this line to make the arrow transparent
              child: Icon(
                Icons.arrow_outward_rounded,
                color: color, // Modify this line to make the arrow transparent
                size: size - 5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

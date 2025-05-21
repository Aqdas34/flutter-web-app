import 'package:flutter/material.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    return Path()
      ..moveTo(w * 0.5, h) // Bottom center
      ..lineTo(w, h * 0.5) // Bottom-right
      ..lineTo(w * 0.8, 0) // Top-right
      ..lineTo(w * 0.2, 0) // Top-left
      ..lineTo(0, h * 0.5) // Bottom-left
      ..close(); // Close the path
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

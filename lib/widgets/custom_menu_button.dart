import 'package:flutter/material.dart';

class ThreeGreenBarsMenu extends StatelessWidget {
  const ThreeGreenBarsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 35,
      padding: const EdgeInsets.all(2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _buildGreenBar(18, 3),
            ),
            const SizedBox(height: 5), // Space between bars
            _buildGreenBar(30, 3.2),
            const SizedBox(height: 5), // Space between bars

            Align(
              alignment: Alignment.centerLeft,
              child: _buildGreenBar(18, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreenBar(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF244622), // Green color
        borderRadius: BorderRadius.circular(4), // Rounded edges
      ),
    );
  }
}

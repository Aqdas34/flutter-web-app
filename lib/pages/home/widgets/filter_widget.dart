import 'package:flutter/material.dart';

class FilterOptionWidget extends StatelessWidget {
  const FilterOptionWidget(
      {super.key, required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7F2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

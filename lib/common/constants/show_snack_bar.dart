
import 'package:flutter/material.dart';


void showSnackBar(
  BuildContext context,
  String msg,
) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
    ),
  );
}
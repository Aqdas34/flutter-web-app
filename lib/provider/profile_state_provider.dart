import 'package:flutter/material.dart';

class ProfileStateProvider with ChangeNotifier {
  bool _isChefProfile = false;

  bool get isChefProfile => _isChefProfile;

  void toggleProfile(bool value) {
    _isChefProfile = value;
    notifyListeners();
  }
}

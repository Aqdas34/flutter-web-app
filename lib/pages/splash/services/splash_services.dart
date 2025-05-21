import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:only_shef/pages/login_sign/login_or_signup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/global_variable.dart';
import '../../../common/constants/http_response.dart';
import '../../../provider/user_provider.dart';

class SplashServices {
  Future<void> getUserData(
    String token,
    BuildContext context,
  ) async {
    try {
      // Construct URL with query parameter
      final uri_1 = Uri.parse('$uri/');

      final response = await http.get(
        uri_1,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      print(response.statusCode);

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);

          print(Provider.of<UserProvider>(context, listen: false).user.name);

          // print(chefProfiles[0].name);
          // Handle the response here (e.g., parse JSON or update state)
        },
      );
    } catch (error) {
      // Handle any errors (e.g., network errors)

      // Remove x-auth-token from SharedPreference
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('x-auth-token');

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Fetching Details')),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginOrSignup()),
          (route) => false);
    }
  }
}

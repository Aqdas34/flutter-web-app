// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:only_shef/pages/auth/register/screens/verify_registration_otp_screen.dart';
import 'package:only_shef/services/email_service.dart';
import 'package:only_shef/widgets/snack_bar_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/global_variable.dart';
import '../../../common/constants/http_response.dart';
import '../../../common/constants/show_snack_bar.dart';
import '../../../models/user.dart';
import '../../../provider/user_provider.dart';

class AuthService {
  Future<bool> signUpUser({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // First send OTP
      bool otpSent = await EmailService.sendOTP(email);
      if (!otpSent) {
        showError(context, "Failed to send verification email");
        return false;
      }

      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyRegistrationOTPScreen(
            email: email,
            name: name,
            password: password,
          ),
        ),
      );

      return true;
    } catch (e) {
      showSnackBar(context, 'Something went wrong');
    }
    return false;
  }

  Future<bool> completeRegistration({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
      );
      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      httpErrorHandling(
          response: response,
          context: context,
          onSuccess: () async {
            Provider.of<UserProvider>(context, listen: false)
                .setUser(response.body);

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'x-auth-token', jsonDecode(response.body)['token']);

            showSuccess(context, 'Account Created - You are Logged in');
          });
      return true;
    } catch (e) {
      showSnackBar(context, 'Something went wrong');
    }
    return false;
  }

  Future<bool> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Provider.of<UserProvider>(context, listen: false)
            .setUser(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'x-auth-token', jsonDecode(response.body)['token']);
        return true;
      } else {
        showError(
            context, jsonDecode(response.body)['error'] ?? 'Login failed');
        return false;
      }
    } catch (e) {
      showError(context, e.toString());
      return false;
    }
  }

  // void getUserData(
  //   BuildContext context,
  // ) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('x-auth-token');
  //     if (token == null) {
  //       prefs.setString('x-auth-token', '');
  //     }
  //     var tokenRes = await http
  //         .post(Uri.parse('$uri/tokenIsValid'), headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'x-auth-token': token!,
  //     });

  //     var response = jsonDecode(tokenRes.body);
  //     if (response == true) {
  //       http.Response userRes =
  //           await http.get(Uri.parse('$uri/'), headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': token,
  //       });
  //       var userProvider = Provider.of<UserProvider>(context, listen: false);
  //       userProvider.setUser(userRes.body);
  //     }
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }
}

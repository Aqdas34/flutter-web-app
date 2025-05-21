import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/common/constants/global_variable.dart';
import 'package:only_shef/services/email_service.dart';
import 'package:only_shef/widgets/snack_bar_util.dart';
import 'package:only_shef/pages/auth/forget_password/screen/verify_otp_screen.dart';
import 'dart:convert';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<String?> _getUserId() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/getUserID?email=${_emailController.text}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['userId'];
      } else if (response.statusCode == 404) {
        showError(context, "User not found");
        return null;
      } else if (response.statusCode == 400) {
        showError(context, "Email is required");
        return null;
      } else {
        final data = jsonDecode(response.body);
        showError(context, data['error'] ?? "Failed to get user ID");
        return null;
      }
    } catch (e) {
      print('Error getting user ID: $e');
      showError(context, "Failed to get user ID");
      return null;
    }
  }

  void _sendOTP() async {
    if (_emailController.text.isEmpty) {
      showError(context, "Please enter your email address");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // First get the user ID
      final userId = await _getUserId();
      if (userId == null) {
        showError(context, "User not found");
        return;
      }

      // Then send OTP
      bool success = await EmailService.sendOTP(_emailController.text);
      if (success) {
        showSuccess(context, "OTP has been sent to your email");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOTPScreen(
              email: _emailController.text,
              userId: userId,
            ),
          ),
        );
      } else {
        showError(context, "Failed to send OTP. Please try again.");
      }
    } catch (e) {
      showError(context, "Failed to send OTP. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Forgot Password",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter your email address and we'll send you an OTP to reset your password",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              // Email Input Field
              TextFormField(
                controller: _emailController,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14, color: Color(0xFFBABABA)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.black45),
                ),
              ),
              const SizedBox(height: 30),
              // Send OTP Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Send OTP",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

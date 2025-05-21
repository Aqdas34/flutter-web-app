import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/services/email_service.dart';
import 'package:only_shef/widgets/snack_bar_util.dart';
import 'package:only_shef/pages/home/screen/home_screen.dart';

class VerifyRegistrationOTPScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  const VerifyRegistrationOTPScreen({
    super.key,
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  State<VerifyRegistrationOTPScreen> createState() =>
      _VerifyRegistrationOTPScreenState();
}

class _VerifyRegistrationOTPScreenState
    extends State<VerifyRegistrationOTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOTP() async {
    if (_otpController.text.isEmpty) {
      showError(context, "Please enter the OTP");
      return;
    }

    if (_otpController.text.length != 6) {
      showError(context, "OTP must be 6 digits");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool isValid = EmailService.verifyOTP(widget.email, _otpController.text);
      if (isValid) {
        // TODO: Complete registration with backend
        showSuccess(context, "Registration successful");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        showError(context, "Invalid OTP. Please try again.");
      }
    } catch (e) {
      showError(context, "Something went wrong. Please try again.");
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
                "Verify Email",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter the 6-digit OTP sent to ${widget.email}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              // OTP Input Field
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter OTP",
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
                  prefixIcon: const Icon(Icons.lock, color: Colors.black45),
                ),
              ),
              const SizedBox(height: 30),
              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
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
                          "Verify OTP",
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

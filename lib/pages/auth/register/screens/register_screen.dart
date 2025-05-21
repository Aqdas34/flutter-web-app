import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/auth/login/screen/login_screen.dart';
import 'package:only_shef/pages/auth/service/register_service.dart';
import 'package:only_shef/widgets/snack_bar_util.dart';
import 'package:only_shef/pages/about/screens/terms_conditions_screen.dart';

import '../../../../common/colors/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _termsAccepted = false;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  void _register() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      showError(context, "All fields are required.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showError(context, "Passwords do not match.");
      return;
    }

    if (!_termsAccepted) {
      showError(context, "You must accept the terms and conditions.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await _authService.signUpUser(
      name: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      context: context,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Logo Section
            Image.asset(
              'assets/logo.png',
              height: 230,
            ),

            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Let's Get Started",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 1),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Create your own account",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF355B34),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Name Input
            SizedBox(
              height: 55,
              child: TextFormField(
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "eg. Junaid Rafiq",
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 14, color: primaryColor),
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14, color: Color(0xFFBABABA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Email Input
            SizedBox(
              height: 55,
              child: TextFormField(
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 14, color: primaryColor),
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14, color: Color(0xFFBABABA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: secondryColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Password Input
            SizedBox(
              height: 55,
              child: TextFormField(
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 14, color: primaryColor),
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14, color: Color(0xFFBABABA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: secondryColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Confirm Password Input
            SizedBox(
              height: 55,
              child: TextFormField(
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 14, color: primaryColor),
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14, color: Color(0xFFBABABA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: secondryColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Terms and Conditions
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _termsAccepted = value!;
                    });
                  },
                  activeColor: primaryColor,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsConditionsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "I agree to the Terms and Conditions",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
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
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: GoogleFonts.poppins(color: Colors.black45),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/auth/service/register_service.dart';
import 'package:only_shef/pages/home/screen/home_screen.dart';
import 'package:only_shef/widgets/snack_bar_util.dart';
import 'package:only_shef/pages/auth/register/screens/register_screen.dart';
import 'package:only_shef/pages/auth/forget_password/screen/forget_password_screen.dart';

import '../../../../common/colors/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showError(context, "All fields are required.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      AuthService authService = AuthService();
      bool loginSuccess = await authService.signInUser(
        context: context,  
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Only navigate if login was successful
      if (loginSuccess && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),
            // Logo Section
            Image.asset(
              'assets/logo.png',
              height: 230,
            ),
            const SizedBox(height: 20),
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome Back",
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
                "Login to your account",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF355B34),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Email Input
            TextFormField(
              controller: _emailController,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle:
                    GoogleFonts.poppins(fontSize: 14, color: Color(0xFFBABABA)),
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
            const SizedBox(height: 20),
            // Password Input
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle:
                    GoogleFonts.poppins(fontSize: 14, color: Color(0xFFBABABA)),
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
            const SizedBox(height: 10),
            // Forget Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  "Forget password?",
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
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
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // Signup Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: GoogleFonts.poppins(color: Colors.black45),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
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

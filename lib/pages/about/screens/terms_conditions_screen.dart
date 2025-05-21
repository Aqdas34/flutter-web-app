import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/colors/colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms & Conditions',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: May 1, 2024',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using OnlyShef, you accept and agree to be bound by the terms and provision of this agreement.',
            ),
            _buildSection(
              '2. User Accounts',
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
            ),
            _buildSection(
              '3. Content Guidelines',
              'Users must not post any content that is illegal, harmful, threatening, abusive, harassing, defamatory, or otherwise objectionable.',
            ),
            _buildSection(
              '4. Privacy Policy',
              'Your use of OnlyShef is also governed by our Privacy Policy. Please review our Privacy Policy, which also governs the Site and informs users of our data collection practices.',
            ),
            _buildSection(
              '5. Intellectual Property',
              'All content included on this site, such as text, graphics, logos, images, and software, is the property of OnlyShef and is protected by copyright laws.',
            ),
            _buildSection(
              '6. Limitation of Liability',
              'OnlyShef shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service.',
            ),
            _buildSection(
              '7. Changes to Terms',
              'We reserve the right to modify these terms at any time. We will notify users of any changes by updating the "Last Updated" date of these terms.',
            ),
            const SizedBox(height: 30),
            Text(
              'If you have any questions about these Terms, please contact us at support@onlyshef.com',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

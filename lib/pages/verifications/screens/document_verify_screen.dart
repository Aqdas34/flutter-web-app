import 'package:flutter/material.dart';
import 'package:only_shef/common/colors/colors.dart';

class DocumentVerifyScreen extends StatefulWidget {
  const DocumentVerifyScreen({super.key});

  @override
  _DocumentVerifyScreenState createState() => _DocumentVerifyScreenState();
}

class _DocumentVerifyScreenState extends State<DocumentVerifyScreen> {
  bool isVerifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Document Verification'),
        backgroundColor: Color(0xFF1E451B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verifying Your Documents',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildVerificationCard(
                    title: 'Government ID',
                    status: 'Verified',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  _buildVerificationCard(
                    title: 'Food Safety Certificate',
                    status: 'Verified',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  _buildVerificationCard(
                    title: 'Business License',
                    status: 'Verified',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile-picture');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E451B),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Continue to Profile Picture',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCard({
    required String title,
    required String status,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

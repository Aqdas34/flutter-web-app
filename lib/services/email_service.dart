import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static final String _host = 'smtp.hostinger.com';
  static final int _port = 587;
  static final String _username = 'aqdas@webncodes.com';
  static final String _password = 'Aqdas123@@@';

  // Store OTPs with their associated emails
  static final Map<String, String> _otpMap = {};

  static String generateOTP() {
    Random random = Random();
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += random.nextInt(10).toString();
    }
    return otp;
  }

  static Future<bool> sendOTP(String recipientEmail) async {
    try {
      final smtpServer = SmtpServer(
        _host,
        port: _port,
        ssl: false,
        allowInsecure: true,
        username: _username,
        password: _password,
      );

      String otp = generateOTP();
      // Store the OTP with the email
      _otpMap[recipientEmail] = otp;

      final message = Message()
        ..from = Address(_username, 'Only Chef')
        ..recipients.add(recipientEmail)
        ..subject = 'Password Reset OTP - Only Chef'
        ..html = '''
          <h2>Password Reset OTP</h2>
          <p>Your OTP for password reset is: <strong>$otp</strong></p>
          <p>This OTP will expire in 5 minutes.</p>
          <p>If you didn't request this, please ignore this email.</p>
          <br>
          <p>Best regards,<br>Only Chef Team</p>
        ''';

      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  static bool verifyOTP(String email, String otp) {
    // Check if the email exists in our map and if the OTP matches
    if (_otpMap.containsKey(email) && _otpMap[email] == otp) {
      // Remove the OTP after successful verification
      _otpMap.remove(email);
      return true;
    }
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:only_shef/provider/user_provider.dart';
import 'package:only_shef/provider/profile_state_provider.dart';
import 'pages/profile_setting/screen/profile_setting.dart';
import 'pages/splash/screen/splash_screen.dart';
import 'common/theme/app_theme.dart';
import 'pages/chef/home/screens/chef_home_screen.dart';
import 'pages/verifications/screens/document_capture_screen.dart';
import 'pages/verifications/screens/document_verify_screen.dart';
import 'pages/verifications/screens/profile_picture_screen.dart';
import 'pages/chef/appointments/screens/chef_appointments_screen.dart';
import 'pages/chef/screens/chef_messages_screen.dart';
import 'pages/home/screen/home_screen.dart';
import 'pages/chef_appointments/screens/chef_appointments.dart';
import 'pages/chat/screen/messages_screen.dart';

// import 'package:only_shef/pages/splash/screen/splash_screen.dart';
// import 'package:only_shef/utils/custome_nav_bar.dart';
// import 'package:only_shef/pages/splash/screen/splash_screen.dart';
var screen_height;
var screen_width;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProfileStateProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      title: 'Only Chef',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/appointments': (context) => const ChefAppointments(),
        '/messages': (context) => const MessagesScreen(),
        '/profile-settings': (context) => const ProfileSettingsScreen(),
        '/chef-home': (context) => const ChefHomeScreen(),
        '/chef-appointments': (context) => const ChefAppointmentsScreen(),
        '/chef-messages': (context) => const ChefMessagesScreen(),
        '/document-capture': (context) => const DocumentCaptureScreen(),
        '/document-verify': (context) => const DocumentVerifyScreen(),
        '/profile-picture': (context) => const ProfilePictureScreen(),
      },
    );
  }
}

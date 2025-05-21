import 'package:flutter/material.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/pages/profile_setting/widgets/helper_widgets.dart';
import 'package:only_shef/widgets/custome_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:only_shef/pages/about/screens/terms_conditions_screen.dart';
import 'package:only_shef/pages/about/screens/about_us_screen.dart';
import 'package:only_shef/pages/about/screens/support_screen.dart';
import 'package:only_shef/pages/profile_setting/screens/edit_profile_screen.dart';
import 'package:only_shef/pages/verifications/screens/document_verify_screen.dart';
import '../../../provider/user_provider.dart';
import '../../../provider/profile_state_provider.dart';
import '../../../widgets/chef_nav_bar.dart';
import '../../chef/home/screens/chef_home_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  int _currentIndex = 3; // Profile is at index 3
  bool isPushNotificationsEnabled = true;

  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/appointments');
        break;
      case 2:
        Navigator.pushNamed(context, '/messages');
        break;
      case 3:
        // Already on profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final profileState = Provider.of<ProfileStateProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.profileImage),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333)),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(color: Color(0xFF707070), fontSize: 10),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(93, 35),
                      backgroundColor: Color(0xFF1E451B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildSectionHeader("Inventories"),
                  buildSettingsCard([
                    buildSwitchTile(
                      icon: Icons.swap_horiz,
                      title: "Switch Profiles",
                      subtitle: profileState.isChefProfile
                          ? "Chef Profile"
                          : "User Profile",
                      value: profileState.isChefProfile,
                      onChanged: (value) {
                        if (!user.isVerified) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DocumentVerifyScreen(),
                            ),
                          );
                        } else {
                          profileState.toggleProfile(value);
                          if (value) {
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const ChefHomeScreen(),
                            //   ),
                            // );
                          } else {
                            // Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Divider()),
                    buildNavigationTile(
                      icon: Icons.support,
                      title: "Support",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportScreen(),
                          ),
                        );
                      },
                    ),
                  ]),
                  buildSectionHeader("Settings"),
                  buildSettingsCard(
                    [
                      buildSwitchTile(
                        icon: Icons.notifications,
                        title: "Push Notifications",
                        value: isPushNotificationsEnabled,
                        onChanged: (value) {
                          setState(() => isPushNotificationsEnabled = value);
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Divider()),
                      buildNavigationTile(
                        icon: Icons.info_outline,
                        title: "About Us",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUsScreen(),
                            ),
                          );
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Divider()),
                      buildNavigationTile(
                        icon: Icons.policy,
                        title: "Terms and Conditions",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TermsConditionsScreen(),
                            ),
                          );
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Divider()),
                      buildLogoutButton(context),
                    ],
                  ),
                  // SizedBox(height: 120),
                ],
              ),
            ),
            Positioned(
              bottom: 15,
              left: 50,
              right: 50,
              child: profileState.isChefProfile
                  ? ChefNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                        switch (index) {
                          case 0:
                            Navigator.pushReplacementNamed(
                                context, '/chef-home');
                            break;
                          case 1:
                            Navigator.pushReplacementNamed(
                                context, '/chef-appointments');
                            // Already on appointments screen
                            break;
                          case 2:
                            Navigator.pushReplacementNamed(
                                context, '/chef-messages');
                            break;
                          case 3:
                            break;
                        }
                      },
                    )
                  : CustomNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: _onNavItemTapped,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

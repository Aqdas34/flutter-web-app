import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/chat/widgets/message_widget.dart';
import 'package:only_shef/widgets/custom_menu_button.dart';
import 'package:only_shef/widgets/custome_nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:only_shef/pages/chat/screen/chat_screen.dart';
import 'package:only_shef/common/constants/global_variable.dart';
import 'package:only_shef/pages/cuisine/models/chef.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';

import '../../../common/colors/colors.dart';
import '../../../models/user.dart';
import '../../../provider/user_provider.dart';
import '../data/dummy_data.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with RouteAware {
  int _currentIndex = 2; // Messages is at index 2
  List<dynamic> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back to this screen
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    setState(() {
      isLoading = true;
    });
    try {
      User user = Provider.of<UserProvider>(context, listen: false).user;
      // Replace with your auth token logic

      final response = await http.get(
        Uri.parse('$uri/chat/conversations/${user.id}'),
        headers: {'x-auth-token': '${user.token}'},
      );
      if (response.statusCode == 200) {
        setState(() {
          conversations = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load conversations: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching conversations: $e');
    }
  }

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
        // Already on messages
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ThreeGreenBarsMenu(),
                    Text(
                      'Messages',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox()
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F3),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: primaryColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Color(0xFF9F9F9F),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              maintainHintHeight: true,
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Color(0xFF9F9F9F),
                              ),
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: primaryColor))
                      : conversations.isEmpty
                          ? Center(child: Text('No conversations found'))
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: conversations.length,
                              itemBuilder: (context, index) {
                                final conv = conversations[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          chef: Chef(
                                            id: conv['chatPartnerId'],
                                            chefId: '',
                                            bio: '',
                                            experience: 0,
                                            specialties: [],
                                            rating: 0.0,
                                            availabilityStatus: '',
                                            pricingPerHour: 0.0,
                                            profileVerificationStatus: '',
                                            verifiedBadge: false,
                                            bookedDates: [],
                                            name: conv['partnerName'] ?? '',
                                            email: '',
                                            address: '',
                                            type: '',
                                            isVerified: false,
                                            profileImage:
                                                conv['partnerProfileImage'] ??
                                                    '',
                                            password: '',
                                            backgroundImage: '',
                                            gigImage: '',
                                            username: conv['partnerName'] ?? '',
                                          ),
                                          currentUserId: user.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: MessageItemWidget(
                                    profilePicture:
                                        conv['partnerProfileImage'] ?? '',
                                    name: conv['partnerName'] ?? '',
                                    time: conv['lastMessageTime'] != null
                                        ? conv['lastMessageTime']
                                            .toString()
                                            .substring(0, 16)
                                        : '',
                                    message: conv['lastMessage'] ?? '',
                                    isUnread:
                                        false, // You can enhance this with unread logic
                                    numberofMessagesPending:
                                        '0', // You can enhance this with unread logic
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 50,
            right: 50,
            child: CustomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onNavItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper to get current userId synchronously (implement as needed)
String getCurrentUserIdSync() {
  // TODO: Replace with your actual logic
  return '';
}

// Helper to get token (implement as needed)
Future<String> getToken() async {
  // TODO: Replace with your actual logic
  return '';
}

// Helper to get current userId (implement as needed)
Future<String> getCurrentUserId() async {
  return '';
}

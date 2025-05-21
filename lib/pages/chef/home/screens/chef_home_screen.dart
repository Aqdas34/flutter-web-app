import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/constants/show_snack_bar.dart';
import 'package:only_shef/pages/cuisine/screens/cuisine_screen.dart';
import 'package:only_shef/pages/home/screen/filter_bottom_sheet.dart';
import 'package:only_shef/pages/home/widgets/cuisine_custom_card.dart';
import 'package:only_shef/widgets/custom_menu_button.dart';
import 'package:only_shef/widgets/chef_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../../common/colors/colors.dart';
import '../../../../provider/user_provider.dart';
import '../../../../main.dart';
import '../../../cuisine/services/chef_gig_services.dart';
import '../../../cuisine/models/cuisines.dart';
import '../../../cuisine_item_details/screens/cuisine_item_details.dart';
import '../../../cuisine/models/chef.dart';
import 'package:only_shef/pages/chef/home/widgets/cuisine_widgets.dart';

import '../../add_cuisine/screens/add_cuisine.dart';

class ChefHomeScreen extends StatefulWidget {
  const ChefHomeScreen({super.key});

  @override
  State<ChefHomeScreen> createState() => _ChefHomeScreenState();
}

class _ChefHomeScreenState extends State<ChefHomeScreen>
    with WidgetsBindingObserver, RouteAware {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  int _currentIndex = 0;
  List<Cuisine> _chefCuisines = [];
  bool _isLoadingCuisines = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChange);
    fetchChefCuisines();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.addListener(() {
        if (!FocusManager.instance.primaryFocus!.hasFocus) {
          setState(() {
            _isSearchFocused = false;
          });
          FocusScope.of(context).unfocus();
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _chefCuisines = _chefCuisines;
      } else {
        _chefCuisines = _chefCuisines.where((cuisine) {
          return cuisine.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void fetchChefCuisines() async {
    setState(() {
      _isLoadingCuisines = true;
    });
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Cuisine> cuisines =
        await ChefGigServices().getChefCuisine(context, user.id);
    setState(() {
      _chefCuisines = cuisines;
      _isLoadingCuisines = false;
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearchFocused = false;
    });
  }

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Home
        // Already on home screen
        break;
      case 1: // Appointments
        Navigator.pushNamed(context, '/chef-appointments');
        break;
      case 2: // Messages
        Navigator.pushNamed(context, '/messages');
        break;
      case 3: // Profile
        Navigator.pushNamed(context, '/profile-settings');
        break;
    }
  }

  void _switchToUserProfile() {
    // Navigate to user home screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return WillPopScope(
      onWillPop: () async {
        if (_searchFocusNode.hasFocus) {
          FocusScope.of(context).unfocus();
          await Future.delayed(Duration(milliseconds: 50));
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xffFDF7F2),
        key: scaffoldKey,
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                color: Color(0xFF1E451B),
                child: SizedBox(
                  height: 80,
                  width: double.infinity,
                ),
              ),
              Container(
                color: Color(0xFF1E451B),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        user.profileImage,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.name,
                          style: GoogleFonts.poppins(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          color: Color(0xFFFFFFFF),
                        ),
                      ],
                    ),
                    Text(
                      user.email,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.add_circle_outline),
                title: Text(
                  'Add New Cuisine',
                  style: GoogleFonts.poppins(),
                ),
                contentPadding: EdgeInsets.only(top: 40, left: 20),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add cuisine screen
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_outlined),
                title: Text(
                  'Messages',
                  style: GoogleFonts.poppins(),
                ),
                contentPadding: EdgeInsets.only(top: 10, left: 20),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to chat screen
                },
              ),
              ListTile(
                leading: Icon(Icons.verified_outlined),
                title: Text(
                  'Verification Status',
                  style: GoogleFonts.poppins(),
                ),
                contentPadding: EdgeInsets.only(top: 10, left: 20),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text(
                  'Settings',
                  style: GoogleFonts.poppins(),
                ),
                contentPadding: EdgeInsets.only(top: 10, left: 20),
                onTap: () {},
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E451B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _switchToUserProfile,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swap_horiz, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Switch to User Profile',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // appBar: AppBar(
        //   backgroundColor: Color(0xFF1E451B),
        //   title: Text(
        //     'Chef Dashboard',
        //     style: GoogleFonts.poppins(
        //       color: Colors.white,
        //       fontSize: 20,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        //   leading: IconButton(
        //     icon: Icon(Icons.menu, color: Colors.white),
        //     onPressed: () {
        //       scaffoldKey.currentState?.openDrawer();
        //     },
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.notifications_outlined, color: Colors.white),
        //       onPressed: () {
        //         // Handle notifications
        //       },
        //     ),
        //   ],
        // ),
        body: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              scaffoldKey.currentState!.openDrawer();
                            },
                            child: ThreeGreenBarsMenu(),
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(user.profileImage),
                          ),
                        ],
                      ),

                      Text(
                        'My Cuisines',
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Add New Cuisine Button
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCuisineScreen(
                                chefId: user.id,
                              ),
                            ),
                          );
                          // Navigate to add cuisine screen
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add New Cuisine'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondryColor,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Cuisines Grid
                      _isLoadingCuisines
                          ? Center(child: CircularProgressIndicator())
                          : _chefCuisines.isEmpty
                              ? Center(child: Text('No cuisines found'))
                              : GridView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: _chefCuisines.length,
                                  itemBuilder: (context, index) {
                                    final cuisine = _chefCuisines[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CuisineItemDetails(
                                              cuisine: cuisine,
                                              chef: Chef(
                                                id: user.id,
                                                chefId: user.id,
                                                bio: "Professional chef",
                                                experience: 5,
                                                specialties: [
                                                  "Pakistani",
                                                  "Indian"
                                                ],
                                                rating: 4.5,
                                                availabilityStatus: "true",
                                                pricingPerHour: 50.0,
                                                profileVerificationStatus:
                                                    "Verified",
                                                verifiedBadge: true,
                                                bookedDates: [],
                                                name: user.name,
                                                email: user.email,
                                                address: user.address,
                                                type: "chef",
                                                isVerified: true,
                                                profileImage: user.profileImage,
                                                password: "",
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: CuisineCard(
                                        cuisineName: cuisine.name,
                                        imageUrl: (cuisine.imageUrl != null &&
                                                cuisine.imageUrl.isNotEmpty)
                                            ? cuisine.imageUrl
                                            : 'assets/images/demo_cuisine_icon.png',
                                      ),
                                    );
                                  },
                                ),
                      // SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 50,
                right: 50,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: _isSearchFocused
                      ? SizedBox.shrink()
                      : ChefNavigationBar(
                          currentIndex: _currentIndex,
                          onTap: _handleNavigation,
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

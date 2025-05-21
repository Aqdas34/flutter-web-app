import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/cuisine/screens/cuisine_screen.dart';
import 'package:only_shef/pages/home/screen/filter_bottom_sheet.dart';
import 'package:only_shef/pages/home/widgets/cuisine_custom_card.dart';
import 'package:only_shef/pages/verifications/screens/document_verify_screen.dart';
import 'package:only_shef/widgets/custom_menu_button.dart';

import 'package:only_shef/widgets/custome_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../common/colors/colors.dart';
import '../../../provider/user_provider.dart';
import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, RouteAware {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _cuisines = [
    {
      'name': 'Pakistani',
      'color': Color(0xFF1B4149),
      'image': 'assets/turkey.png',
      'cuisineImage': 'assets/pakistani1.png',
    },
    {
      'name': 'Chinese',
      'color': Color(0xFF81C0FF),
      'image': 'assets/chinese_logo.png',
      'cuisineImage': 'assets/chinese1.png',
    },
    {
      'name': 'Mexican',
      'color': Color(0xFFCA4943),
      'image': 'assets/mexican_logo.png',
      'cuisineImage': 'assets/mexican1.png',
    },
    {
      'name': 'Fast Food',
      'color': Color(0xFF8186D9),
      'image': 'assets/fastfood_logo.png',
      'cuisineImage': 'assets/fastfood1.png',
    },
    {
      'name': 'Desserts',
      'color': Color(0xFF77B255),
      'image': 'assets/deserts_logo.png',
      'cuisineImage': 'assets/desert1.png',
    },
    {
      'name': 'Others',
      'color': Color(0xFFB769D3),
      'image': 'assets/others_logo.png',
      'cuisineImage': 'assets/desert1.png',
    },
  ];

  List<Map<String, dynamic>> _filteredCuisines = [];

  @override
  void initState() {
    super.initState();
    _filteredCuisines = _cuisines;
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChange);

    // Add keyboard visibility listener
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
        _filteredCuisines = _cuisines;
      } else {
        _filteredCuisines = _cuisines.where((cuisine) {
          return cuisine['name'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/appointments');
        break;
      case 2:
        Navigator.pushNamed(context, '/messages');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-settings');
        break;
    }
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
    // Called when coming back to this screen
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearchFocused = false;
    });
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
              ), // Margin from top
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
                leading: Icon(Icons.verified_outlined),
                title: Text(
                  'Verification',
                  style: GoogleFonts.poppins(),
                ),
                contentPadding: EdgeInsets.only(top: 40, left: 20),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocumentVerifyScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner_outlined),
                title: Text(
                  'Terms and Conditions',
                  style: GoogleFonts.poppins(),
                ),
                contentPadding: EdgeInsets.only(top: 10, left: 20),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text(
                  'About',
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
                  onPressed: () {
                    // Handle switch profile action
                  },
                  child: Center(
                    child: Text(
                      'Switch Profile',
                      style: GoogleFonts.poppins(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "What cuisine chef\nwould you like 2 Select?",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E451B),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _searchFocusNode.unfocus();
                            },
                            child: TextField(
                              focusNode: _searchFocusNode,
                              controller: _searchController,
                              style: GoogleFonts.poppins(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.black54),
                                hintText: "Search food, chefs",
                                hintStyle:
                                    GoogleFonts.poppins(color: Colors.black54),
                                labelStyle: GoogleFonts.poppins(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(45),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFF1E451B)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled:
                                  true, // This makes the bottom sheet full screen
                              backgroundColor: backgroundColor, // Optional
                              builder: (context) => SizedBox(
                                height: MediaQuery.of(context).size.height * 1,
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // Covers 90% of the screen
                                child: FilterBottomSheet(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color(0xFF1E451B), width: 1)),
                            child: Image.asset(
                              'assets/icons/filter_icon.png',
                              height: 21,
                              width: 21,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: GridView.count(
                        padding: EdgeInsets.only(top: 5, bottom: 80),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: _filteredCuisines.map((cuisine) {
                          return CustomCuisineCard(
                            cuisineName: cuisine['name'],
                            backColor: cuisine['color'],
                            imageLink: cuisine['image'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CuisineScreen(
                                        imagePath: cuisine['cuisineImage'],
                                        cuisineName:
                                            '${cuisine['name']} Cuisine')),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 50,
              right: 50,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: _isSearchFocused
                    ? SizedBox.shrink()
                    : CustomNavigationBar(
                        currentIndex: _currentIndex,
                        onTap: _onNavItemTapped,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class CuisineCard extends StatelessWidget {
//   final String title;
//   final Color color;
//   final IconData icon;
//   final VoidCallback onTap; // Added onTap property

//   const CuisineCard({
//     required this.title,
//     required this.color,
//     required this.icon,
//     required this.onTap, // Marked as required
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap, // Handle tap event
//       child: Container(
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Stack(
//           children: [
//             Center(
//               child: Icon(icon, size: 48, color: color),
//             ),
//             Positioned(
//               bottom: 8,
//               left: 8,
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 8,
//               right: 8,
//               child: CircleAvatar(
//                 backgroundColor: color,
//                 child: Icon(Icons.edit, size: 16, color: Colors.white),
//                 radius: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/main.dart';
import 'package:provider/provider.dart';

import '../../../common/constants/show_snack_bar.dart';
import '../../../provider/user_provider.dart';
import '../../chat/screen/chat_screen.dart';

import '../../cuisine/models/chef.dart';
import '../../cuisine/models/cuisines.dart';
import '../../cuisine/services/chef_gig_services.dart';
import '../models/offer.dart';
import '../services/send_offer_services.dart';

class SendOfferScreen extends StatefulWidget {
  final String chefId;
  final DateTime selectedDate;
  final Chef chef;
  final bool isFromMessage;

  const SendOfferScreen({
    super.key,
    required this.chefId,
    required this.selectedDate,
    required this.chef,
    this.isFromMessage = false,
  });

  @override
  State<SendOfferScreen> createState() => _SendOfferScreenState();
}

class _SendOfferScreenState extends State<SendOfferScreen> {
  TimeOfDay? selectedTime;
  String? userId;
  List<Cuisine> chefCuisines = [];
  String? selectedCuisineId; // Only one selection
  int numberOfPersons = 1;
  final TextEditingController commentsController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChefCuisines();
  }

  Future<void> fetchChefCuisines() async {
    final cuisines =
        await ChefGigServices().getChefCuisine(context, widget.chefId);
    setState(() {
      chefCuisines = cuisines;
      isLoading = false;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      confirmText: "Confirm",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: primaryColor,
              error: Colors.red,
            ),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? primaryColor
                      : Colors.white),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.white
                      : primaryColor),
              hourMinuteTextStyle: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              hourMinuteColor:
                  WidgetStateColor.resolveWith((states) => Colors.white),
              hourMinuteTextColor:
                  WidgetStateColor.resolveWith((states) => primaryColor),
              dialHandColor: primaryColor,
              dialBackgroundColor: secondryColor.withOpacity(0.2),
              entryModeIconColor: primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  return null;
                }),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                minimumSize: WidgetStateProperty.all(Size(80, 40)),
                shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              ),
            ),
          ),
          child: SingleChildScrollView(child: child!),
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _selectCuisine(String cuisineId) {
    setState(() {
      selectedCuisineId = cuisineId;
    });
  }

  void _sendOffer(BuildContext context) async {
    // final user = Provider.of<UserProvider>(context).user;
    if (selectedTime == null || selectedCuisineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select time and a cuisine.')),
      );
      return;
    }
    showSnackBar(context, 'Sending offer...');
    final selectedCuisine =
        chefCuisines.firstWhere((c) => c.id == selectedCuisineId);
    final offer = Offer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chefId: widget.chefId,
      userId: userId!,
      date: widget.selectedDate,
      time: selectedTime!.format(context),
      selectedCuisines: [selectedCuisine.name],
      numberOfPersons: numberOfPersons,
      comments: commentsController.text,
    );
    print('Offer to return: \\${offer.toJson()}');
    // Call the bookChef service
    final success = await SendOfferServices().bookChef(
      context: context,
      chefId: widget.chefId,
      date: DateFormat('yyyy-MM-dd').format(widget.selectedDate),
      time: selectedTime!.format(context),
      selectedCuisines: [selectedCuisine.name],
      numberOfPersons: numberOfPersons,
      price: selectedCuisine.price * numberOfPersons,
      comments: commentsController.text,
    );

    if (success) {
      Navigator.pop(context, offer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    userId = user.id;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: screen_height * 0.065,
                    ),
                    // Date & Time Row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.isFromMessage) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            chef: widget.chef,
                                            currentUserId: user.id,
                                          )));
                            }
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: primaryColor,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: screen_width * 0.05,
                        ),
                        Text(
                          "Send Offer",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screen_height * 0.02,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            child: ListTile(
                              leading: Icon(Icons.calendar_today,
                                  color: Colors.white),
                              title: Text('Date',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                DateFormat(
                                  'MMMM d, y',
                                ).format(widget.selectedDate),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Card(
                            color: secondryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            child: ListTile(
                              leading:
                                  Icon(Icons.access_time, color: primaryColor),
                              title: Text('Time',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                selectedTime == null
                                    ? 'Select time'
                                    : selectedTime!.format(context),
                                style: GoogleFonts.poppins(
                                  color: primaryColor,
                                ),
                              ),
                              onTap: () => _selectTime(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Cuisine Selection Horizontal
                    Text('Select Cuisine',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: chefCuisines.isEmpty
                          ? Center(
                              child: Text(
                                "There are no cuisines",
                                style: GoogleFonts.poppins(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: chefCuisines.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                final cuisine = chefCuisines[index];
                                final selected =
                                    selectedCuisineId == cuisine.id;
                                final cardWidth = selected ? 175.0 : 160.0;
                                final cardHeight = selected ? 220.0 : 200.0;
                                return GestureDetector(
                                  onTap: () => _selectCuisine(cuisine.id),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    width: cardWidth,
                                    height: cardHeight,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? secondryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: selected
                                            ? primaryColor
                                            : Colors.grey.shade300,
                                        width: selected ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            cuisine.imageUrl,
                                            width: cardWidth,
                                            height: cardHeight,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              width: cardWidth,
                                              height: cardHeight,
                                              color: Colors.grey.shade200,
                                              child: Icon(Icons.restaurant,
                                                  color: primaryColor,
                                                  size: 40),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          height: cardHeight * 0.3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: secondryColor
                                                  .withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                cuisine.name,
                                                style: GoogleFonts.poppins(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 5),
                    // Number of Persons
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Number of Persons',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 32),
                          IconButton(
                            icon: Icon(Icons.remove, color: primaryColor),
                            onPressed: numberOfPersons > 1
                                ? () {
                                    setState(() {
                                      numberOfPersons--;
                                    });
                                  }
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: secondryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              numberOfPersons.toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: primaryColor),
                            onPressed: () {
                              setState(() {
                                numberOfPersons++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // Comments
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Additional Comments',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: commentsController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter any special requests or comments...',
                              hintStyle: GoogleFonts.poppins(),
                              filled: false,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: secondryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Total Amount
                    if (selectedCuisineId != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Total: ',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            Text(
                              (() {
                                final cuisine = chefCuisines.firstWhere(
                                    (c) => c.id == selectedCuisineId);
                                final total = cuisine.price * numberOfPersons;
                                return '\$${total.toStringAsFixed(2)}';
                              })(),
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),
                    // Send Offer Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _sendOffer(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Send Offer',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    commentsController.dispose();
    super.dispose();
  }
}

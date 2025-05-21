import 'package:flutter/material.dart';
import 'package:only_shef/pages/verifications/screens/document_capture_screen.dart';

class ChooseVerificationDocumentScreen extends StatefulWidget {
  const ChooseVerificationDocumentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChooseVerificationDocumentScreenState createState() =>
      _ChooseVerificationDocumentScreenState();
}

class _ChooseVerificationDocumentScreenState
    extends State<ChooseVerificationDocumentScreen> {
  String selectedCountry = 'Pakistan';
  final List<String> countries = ['Pakistan', 'India', 'USA', 'UK'];
  String selectedDocument = 'CNIC'; // Track selected document

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF4EE), // Light beige background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  // Handle back navigation
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 10),
              Text(
                'Choose your Verification\ndocument',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Select your Preferred Verification Document',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              // Country Dropdown
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCountry,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: countries.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(Icons.flag,
                                color: Color(0xFF1B3B22)), // Green icon
                            SizedBox(width: 10),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCountry = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              // CNIC Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDocument == 'CNIC'
                        ? Color(0xFF1B3B22) // Dark green if selected
                        : Colors.white,
                    side: BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedDocument = 'CNIC';
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.credit_card,
                            color: selectedDocument == 'CNIC'
                                ? Colors.white
                                : Colors.black),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'CNIC Card',
                        style: TextStyle(
                          color: selectedDocument == 'CNIC'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Passport Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDocument == 'Passport'
                        ? Color(0xFF1B3B22) // Dark green if selected
                        : Colors.white,
                    side: BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedDocument = 'Passport';
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.card_travel,
                            color: selectedDocument == 'Passport'
                                ? Colors.white
                                : Colors.black),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Passport',
                        style: TextStyle(
                          color: selectedDocument == 'Passport'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              // Scan Documents Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1B3B22), // Dark green button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DocumentCaptureScreen()));
                      // Handle Scan Documents button press
                      // print('Selected Document: $selectedDocument');
                    },
                    child: Text(
                      'Scan Documents',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
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

import 'package:flutter/material.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:only_shef/provider/user_provider.dart';
import 'dart:io';
import 'dart:convert';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  _ProfilePictureScreenState createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_image == null) {
      // Skip to chef home if no image is selected
      Navigator.pushNamed(context, '/chef-home');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final chefId = Provider.of<UserProvider>(context, listen: false).user.id;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.7:2004/api/chef/upload-profile-picture'),
      );

      request.fields['chefId'] = chefId;
      request.files.add(
        await http.MultipartFile.fromPath(
          'profilePicture',
          _image!.path,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        // Update user provider with new profile picture
        Provider.of<UserProvider>(context, listen: false)
            .updateProfilePicture(jsonResponse['data']['profilePicture']);

        // Navigate to chef home
        Navigator.pushNamed(context, '/chef-home');
      } else {
        throw Exception(
            jsonResponse['message'] ?? 'Failed to upload profile picture');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading profile picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profile Picture'),
        backgroundColor: Color(0xFF1E451B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Your Profile Picture',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This step is optional. You can add a profile picture later.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF707070),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(
                          color: Color(0xFF1E451B),
                          width: 2,
                        ),
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _image == null
                          ? Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.grey[400],
                            )
                          : null,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Upload a professional photo of yourself',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF707070),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isUploading
                              ? null
                              : () => _pickImage(ImageSource.camera),
                          icon: Icon(Icons.camera_alt),
                          label: Text('Take Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1E451B),
                            side: BorderSide(color: Color(0xFF1E451B)),
                            minimumSize: Size(150, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _isUploading
                              ? null
                              : () => _pickImage(ImageSource.gallery),
                          icon: Icon(Icons.photo_library),
                          label: Text('Choose Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1E451B),
                            side: BorderSide(color: Color(0xFF1E451B)),
                            minimumSize: Size(150, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : () => Navigator.pushNamed(context, '/chef-home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Color(0xFF333333),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Skip for Now',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (_image != null) ...[
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _uploadProfilePicture,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E451B),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: _isUploading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

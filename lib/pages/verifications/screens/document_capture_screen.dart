import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class DocumentCaptureScreen extends StatefulWidget {
  const DocumentCaptureScreen({super.key});

  @override
  State<DocumentCaptureScreen> createState() => _DocumentCaptureScreenState();
}

class _DocumentCaptureScreenState extends State<DocumentCaptureScreen> {
  final Map<String, File?> uploadedFiles = {
    'Government ID': null,
    'Food Safety Certificate': null,
    'Business License': null,
  };

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String documentType) async {
    try {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        uploadedFiles[documentType] = File(image.path);
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? photo = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (photo != null) {
                      setState(() {
                        uploadedFiles[documentType] = File(photo.path);
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDF7F2),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E451B),
        title: Text(
          'Upload Documents',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please upload clear photos of your documents',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Color(0xFF707070),
              ),
            ),
            SizedBox(height: 24),
            ...uploadedFiles.entries.map((entry) => _buildDocumentUploadCard(
                  title: entry.key,
                  file: entry.value,
                  onTap: () => _pickImage(entry.key),
                )),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: uploadedFiles.values.any((file) => file != null)
                  ? () {
                      Navigator.pushNamed(context, '/document-verify');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E451B),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue to Verification',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUploadCard({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 8),
              if (file != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    file,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap to change document',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color(0xFF707070),
                  ),
                ),
              ] else
                Row(
                  children: [
                    Icon(Icons.upload_file, color: Color(0xFF1E451B)),
                    SizedBox(width: 8),
                    Text(
                      'Tap to upload document',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

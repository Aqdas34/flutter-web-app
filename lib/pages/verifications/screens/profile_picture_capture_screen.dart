import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePictureCaptureScreen extends StatefulWidget {
  const ProfilePictureCaptureScreen({super.key});

  @override
  _ProfilePictureCaptureScreenState createState() =>
      _ProfilePictureCaptureScreenState();
}

class _ProfilePictureCaptureScreenState
    extends State<ProfilePictureCaptureScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _cameras = await availableCameras();
      _cameraController =
          CameraController(_cameras![1], ResolutionPreset.high);

      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } else {
      // Handle permission denied
      print('Camera permission denied');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController!.takePicture();
      print('Profile picture captured: ${image.path}');
      // You can navigate to another screen or process the image here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF4EE), // Light beige background
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview
            _isCameraInitialized && _cameraController != null
                ? CameraPreview(_cameraController!)
                : Center(child: CircularProgressIndicator()),

            // Circular Frame for profile picture
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                        style: BorderStyle.solid,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Capture button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _captureImage,
                    child: Text(
                      'Capture',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

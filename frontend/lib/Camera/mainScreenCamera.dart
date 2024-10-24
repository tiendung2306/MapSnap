import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart'; // For file path manipulation
import 'confirmScreen.dart';

class MainScreenCamera extends StatefulWidget {
  const MainScreenCamera({Key? key}) : super(key: key);

  @override
  State<MainScreenCamera> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreenCamera> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  int direction = 0;

  @override
  void initState() {
    super.initState();
    // Ẩn thanh StatusBar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    startCamera(direction);
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {}); //To refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenMin;
    if (screenWidth < screenHeight) {
      screenMin = screenWidth;
    } else {
      screenMin = screenHeight;
    }

    if (cameraController.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: screenHeight,
              width: screenWidth,
              color: Colors.black,
            ),

            Container(
              width: screenWidth,
              height: screenHeight * 4 / 5,
              child: CameraPreview(cameraController),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  direction = direction == 0 ? 1 : 0;
                  startCamera(direction);
                });
              },
              child: button(Icons.flip_camera_ios_outlined, Alignment.bottomLeft,
                  (screenHeight / 5) * 1 / 4, screenHeight * 3 / 40, screenWidth / 14),
            ),

            GestureDetector(
              onTap: () {
                cameraController.takePicture().then((XFile? file) {
                  if (mounted) {
                    if (file != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmScreen(imagePath: file.path), // Điều hướng tới màn hình xác nhận
                        ),
                      );
                    }
                  }
                });
              },
              child: button(Icons.camera_alt_outlined, Alignment.bottomCenter,
                  (screenHeight / 5) * 3 / 5, screenHeight / 25, 0),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: button(Icons.close, Alignment.topLeft, screenMin / 20,
                  screenWidth / 50, screenWidth / 50),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget button(IconData icon, Alignment alignment, double size, double margin1, double margin2) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.only(
          left: margin2,
          bottom: margin1,
          top: margin1,
          right: margin2,
        ),
        height: size,
        width: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black54,
            size: (size * 2) / 3,
          ),
        ),
      ),
    );
  }
}

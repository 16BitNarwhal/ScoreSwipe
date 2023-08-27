import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  int number = 0;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[1],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }

      cameraController.startImageStream((CameraImage availableImage) {
        // cameraController.stopImageStream();
        setState(() {
          number++;
        });
      });

      setState(() {
        number++;
      }); //To refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.stopImageStream();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            CameraPreview(cameraController),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

// import 'dart:async';
// import 'dart:io';
// import 'package:edge_detection/edge_detection.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:logger/logger.dart';

// class TestingScreen extends StatefulWidget {
//   const TestingScreen({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<TestingScreen> {
//   String? _imagePath;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> getImageFromCamera() async {
//     bool isCameraGranted = await Permission.camera.request().isGranted;
//     if (!isCameraGranted) {
//       isCameraGranted =
//           await Permission.camera.request() == PermissionStatus.granted;
//     }

//     if (!isCameraGranted) {
//       // Have not permission to camera
//       return;
//     }

//     // Generate filepath for saving
//     String imagePath =
//         join((await getApplicationSupportDirectory()).path, "temp.jpeg");

//     bool success = false;

//     try {
//       //Make sure to await the call to detectEdge.
//       success = await EdgeDetection.detectEdge(
//         imagePath,
//         canUseGallery: true,
//         androidScanTitle: 'Scanning', // use custom localizations for android
//         androidCropTitle: 'Crop',
//         androidCropBlackWhiteTitle: 'Black White',
//         androidCropReset: 'Reset',
//       );
//       Logger().i("success: $success");
//     } catch (e) {
//       Logger().e(e);
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       if (success) {
//         _imagePath = imagePath;
//       }
//     });
//   }

//   Future<void> getImageFromGallery() async {
//     // Generate filepath for saving
//     String imagePath =
//         join((await getApplicationSupportDirectory()).path, "temp.jpeg");

//     bool success = false;
//     try {
//       //Make sure to await the call to detectEdgeFromGallery.
//       success = await EdgeDetection.detectEdgeFromGallery(
//         imagePath,
//         androidCropTitle: 'Crop', // use custom localizations for android
//         androidCropBlackWhiteTitle: 'Black White',
//         androidCropReset: 'Reset',
//       );
//       Logger().i("success: $success");
//     } catch (e) {
//       Logger().e(e);
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       if (success) {
//         _imagePath = imagePath;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: ElevatedButton(
//                   onPressed: getImageFromCamera,
//                   child: const Text('Scan'),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: getImageFromGallery,
//                   child: const Text('Upload'),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text('Cropped image path:'),
//               Padding(
//                 padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
//                 child: Text(
//                   _imagePath.toString(),
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ),
//               Visibility(
//                 visible: _imagePath != null,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.file(
//                     File(_imagePath ?? ''),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

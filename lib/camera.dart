import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<CameraDescription> cameras;
  late CameraController _cameraController;
  late PdfViewerController _pdfController;

  String _fileText = "";
  bool turningPage = false;

  final faceDetector = FaceDetector(options: FaceDetectorOptions());

  void startCamera() async {
    cameras = await availableCameras();

    _cameraController = CameraController(
      cameras[1],
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }

      _cameraController.startImageStream((CameraImage availableImage) async {
        InputImage? inputImage = inputImageFromCameraImage(availableImage);
        if (inputImage == null) return;

        final List<Face> faces = await faceDetector.processImage(inputImage);
        if (faces.isEmpty) return;

        // set face to face with largest bounding box area
        Face face = faces.reduce((curr, next) =>
            curr.boundingBox.width * curr.boundingBox.height >
                    next.boundingBox.width * next.boundingBox.height
                ? curr
                : next);

        if (face.headEulerAngleZ == null) return;
        final double rotZ =
            face.headEulerAngleZ!; // Head is tilted sideways rotZ degrees

        if (rotZ > 15) {
          if (!turningPage) {
            _pdfController.nextPage();
            turningPage = true;
            setState(() {});
          }
        } else if (rotZ < -15) {
          if (!turningPage) {
            _pdfController.previousPage();
            turningPage = true;
            setState(() {});
          }
        } else if (rotZ.abs() < 10 && turningPage) {
          turningPage = false; // or use a timer/delay?
        }
      });

      setState(() {}); //To refresh widget
    }).catchError((e) {
      // print(e);
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result != null && result.files.single.path != null) {
      // PlatformFile file = result.files.first;

      File _file = File(result.files.single.path!);

      startCamera();
      _pdfController = PdfViewerController();

      setState(() {
        _fileText = _file.path;
      });
    } else {
      // User canceled the picker
    }
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = cameras[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_cameraController.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.stopImageStream();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_fileText == "") return true;
        _fileText = "";
        _cameraController.stopImageStream();
        _cameraController.dispose();
        _pdfController.dispose();
        setState(() {});
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('PDF Player'),
          actions: [
            _fileText != ""
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Return to Home',
                    onPressed: () {
                      _fileText = "";
                      _cameraController.stopImageStream();
                      _cameraController.dispose();
                      _pdfController.dispose();
                      setState(() {});
                    },
                  )
                : Container(),
          ],
        ),
        body: Center(
          child: _fileText == "" // TODO: proper page navigation
              ? ElevatedButton(
                  onPressed: _pickFile, child: const Text('Pick File'))
              : SfPdfViewer.file(File(_fileText), controller: _pdfController),
        ),
      ),
    );
  }
}

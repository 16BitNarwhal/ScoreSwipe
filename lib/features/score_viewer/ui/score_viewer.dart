import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:score_swipe/common/data/local_score_repository.dart';
import 'package:score_swipe/common/models/score_model.dart';
import 'package:score_swipe/features/score_browser/bloc/score_browser_bloc.dart';
import 'package:score_swipe/features/score_viewer/ui/score_config.dart';
import 'package:score_swipe/features/configscreen/configscreen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:logger/logger.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreen();
}

class _PdfScreen extends State<PdfScreen> {
  late List<CameraDescription> cameras;
  late CameraController _cameraController;
  late PdfViewerController _pdfController;

  bool turningPage = false;

  final faceDetector = FaceDetector(options: FaceDetectorOptions());

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    startCamera();
    Config.loadPrefs();
  }

  void startCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[1],
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }

      _cameraController.startImageStream((CameraImage availableImage) async {
        if (Config.swipeAction == SwipeAction.none) return;

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
        final double rot;

        // select axis based on swipe action type
        if (Config.swipeAction == SwipeAction.turn) {
          rot = face.headEulerAngleY!;
        } else {
          rot = face.headEulerAngleZ!;
        }

        final double threshold = (100 - Config.sensitivity) / 100 * 40;

        if (rot > threshold) {
          if (!turningPage) {
            (Config.invertDirection)
                ? _pdfController.previousPage()
                : _pdfController.nextPage();
            turningPage = true;
            setState(() {});
          }
        } else if (rot < -threshold) {
          if (!turningPage) {
            (Config.invertDirection)
                ? _pdfController.nextPage()
                : _pdfController.previousPage();
            turningPage = true;
            setState(() {});
          }
        } else if (rot.abs() < threshold * 0.6 && turningPage) {
          turningPage = false;
        }
      });

      setState(() {});
    }).catchError((e) {
      Logger().e(e);
    });
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
    _pdfController.dispose();
    super.dispose();
  }

  void pushConfigScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScoreConfig(),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    ScoreModel score = arguments['score'];
    score.lastOpened = DateTime.now();
    LocalScoreRepository.updateScore(score);
    BlocProvider.of<ScoreBrowserBloc>(context).add(EditScore(score));

    return Scaffold(
      appBar: AppBar(
        title: Text(score.scoreName),
        actions: [
          IconButton(
            onPressed: () => pushConfigScreen(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: SfPdfViewer.file(score.pdfFile, controller: _pdfController),
      ),
    );
  }
}

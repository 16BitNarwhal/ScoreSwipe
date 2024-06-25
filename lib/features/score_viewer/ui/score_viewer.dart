import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:score_swipe/common/data/local_score_repository.dart';
import 'package:score_swipe/common/models/score_model.dart';
import 'package:score_swipe/features/score_browser/bloc/score_browser_bloc.dart';
import 'package:score_swipe/features/score_viewer/ui/page_alert_dialog.dart';
import 'package:score_swipe/features/score_viewer/ui/score_config.dart';
import 'package:score_swipe/features/configscreen/configscreen.dart';
import 'package:pdfx/pdfx.dart';
import 'package:logger/logger.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreen();
}

class _PdfScreen extends State<PdfScreen> {
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  late PdfController _pdfController;

  bool _turningPage = false;
  double previousEulerAngle = 0;
  DateTime previousTime = DateTime.now();

  final _faceDetector = FaceDetector(options: FaceDetectorOptions());

  @override
  void initState() {
    super.initState();
    startCamera();
    Config.loadPrefs();
  }

  @override
  void didChangeDependencies() {
    ScoreModel score = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)["score"];
    _pdfController = PdfController(
        document: PdfDocument.openData(
      score.pdfFile.readAsBytesSync(),
    ));
    super.didChangeDependencies();
  }

  @override
  void didChangeDependencies() {
    ScoreModel score = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)["score"];
    _pdfController = PdfController(
        document: PdfDocument.openData(
      score.pdfFile.readAsBytesSync(),
    ));
    super.didChangeDependencies();
  }

  void nextPage() {
    if (_pdfController.page == _pdfController.pagesCount) {
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return const PageAlertDialog(
            message: "You're on the last page",
          );
        },
      );
      return;
    }
    _pdfController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void previousPage() {
    if (_pdfController.page == 1) {
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return const PageAlertDialog(
            message: "You're on the first page",
          );
        },
      );
      return;
    }
    _pdfController.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void startCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[1],
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

        final List<Face> faces = await __faceDetector.processImage(inputImage);
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

        double angularSpeed = (rot - previousEulerAngle) /
            DateTime.now().difference(previousTime).inMilliseconds;
        angularSpeed = angularSpeed.abs();

        double angularSpeed = (rot - previousEulerAngle) /
            DateTime.now().difference(previousTime).inMilliseconds;
        angularSpeed = angularSpeed.abs();

        double angularSpeed = (rot - previousEulerAngle) /
            DateTime.now().difference(previousTime).inMilliseconds;
        angularSpeed = angularSpeed.abs();
        if (rot > threshold) {
          if (!__turningPage && angularSpeed > 0.01 && angularSpeed > 0.01) {
            (Config.invertDirection) ? previousPage() : nextPage();
            __turningPage = true;
            setState(() {});
          }
        } else if (rot < -threshold) {
          if (!__turningPage && angularSpeed > 0.01 && angularSpeed > 0.01) {
            (Config.invertDirection) ? nextPage() : previousPage();
            __turningPage = true;
            setState(() {});
          }
        } else if (rot.abs() < threshold * 0.6 && __turningPage) {
          __turningPage = false;
        }
        previousEulerAngle = rot;
        previousTime = DateTime.now();
        previousEulerAngle = rot;
        previousTime = DateTime.now();
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
    final camera = __cameras[1];
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
        child: _pdfController == null
            ? const Center(child: CircularProgressIndicator())
            : PdfView(
                builders: PdfViewBuilders<DefaultBuilderOptions>(
                  options: const DefaultBuilderOptions(),
                  // make document loader red
                  documentLoaderBuilder: (_) => const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                  pageLoaderBuilder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  errorBuilder: (_, error) =>
                      Center(child: Text(error.toString())),
                ),
                controller: _pdfController,
              ),
      ),
    );
  }
}

class PageAlertDialog extends StatefulWidget {
  final String message;

  const PageAlertDialog({Key? key, required this.message}) : super(key: key);

  @override
  State<PageAlertDialog> createState() => _PageAlertDialogState();
}

class _PageAlertDialogState extends State<PageAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnimation = Tween(begin: 1.0, end: 1.5).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pop(); // auto close when fade out complete
        }
      });
    _controller.forward(); // start the fade out
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 24.0,
        title: const Icon(Icons.info_outline, size: 28, color: Colors.blue),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.message,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        child: PdfView(
          builders: PdfViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            // make document loader red
            documentLoaderBuilder: (_) => const Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
            pageLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
            errorBuilder: (_, error) => Center(child: Text(error.toString())),
          ),
          controller: _pdfController,
        ),
      ),
    );
  }
}

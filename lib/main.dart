// import 'package:flutter/material.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'features/score_viewer/ui/score_viewer.dart';
// import 'features/score_browser/ui/score_browser_screen.dart';
// import 'features/configscreen/configscreen.dart';
// import 'features/score_creator/ui/score_creator_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'features/score_browser/bloc/score_browser_bloc.dart';
// import 'features/showcase/showcase_bloc.dart';

// import 'package:logger/logger.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   final String title = 'Score Swipe';

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<ScoreBrowserBloc>(
//           create: (context) => ScoreBrowserBloc(),
//         ),
//         BlocProvider<ShowcaseBloc>(
//           create: (context) => ShowcaseBloc(),
//         ),
//       ],
//       child: MaterialApp(
//         title: title,
//         theme: ThemeData(
//           colorScheme: const ColorScheme(
//             brightness: Brightness.light,
//             primary: Color(0xFFDAF1FA),
//             onPrimary: Color(0xFF17426A),
//             secondary: Color(0xFF72BEE8),
//             onSecondary: Color(0xFFFFFFFF),
//             error: Color(0xFFF8CBCC),
//             onError: Color(0xFF000000),
//             background: Color(0xFFFFFFFF),
//             onBackground: Color(0xFF17426A),
//             surface: Color(0xFFF2F6F9),
//             onSurface: Color(0xFF0F2438),
//           ),
//           useMaterial3: true,
//           fontFamily: 'Inter',
//         ),
//         initialRoute: '/mainscreen',
//         routes: {
//           '/mainscreen': (context) => ShowCaseWidget(
//                 builder: Builder(builder: (_) => const Navigation()),
//                 autoPlay: false,
//               ),
//           '/pdfscreen': (context) => const PdfScreen(),
//         },
//       ),
//     );
//   }
// }

// class Navigation extends StatefulWidget {
//   const Navigation({Key? key}) : super(key: key);

//   @override
//   State<Navigation> createState() => _NavigationState();
// }

// class _NavigationState extends State<Navigation> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const ScoreBrowserScreen(),
//     const ScoreCreatorScreen(),
//     const ConfigScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     Config.loadPrefs(
//       callback: () => {
//         if (!Config.finishedShowcase)
//           {
//             Config.finishedShowcase = true,
//             Config.prefs!.setBool('finishedShowcase', true),
//             WidgetsBinding.instance.addPostFrameCallback(
//               (_) => ShowCaseWidget.of(context).startShowCase(
//                 List.generate(
//                   context.read<ShowcaseBloc>().keys.length,
//                   (index) => context.read<ShowcaseBloc>().keys[index],
//                 ),
//               ),
//             )
//           }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Theme.of(context).colorScheme.secondary,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Showcase(
//               key: context.read<ShowcaseBloc>().keys[2],
//               description: 'Let\'s create a score!',
//               child: const Icon(Icons.add_circle_outline_sharp),
//             ),
//             label: 'Create',
//           ),
//           BottomNavigationBarItem(
//             icon: Showcase(
//                 key: context.read<ShowcaseBloc>().keys[6],
//                 description: 'Configure how you want to swipe your scores here',
//                 child: const Icon(Icons.settings)),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        // appBar: AppBar(title: const Text('Drawing App')),
        body: DrawingScreen(),
      ),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  DrawingMode mode = DrawingMode.draw;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                RenderBox object = context.findRenderObject() as RenderBox;
                Offset localPosition =
                    object.globalToLocal(details.localPosition);
                // Offset localPosition = details.localPosition;
                points.add(DrawingPoint(
                  offset: localPosition,
                  paint: Paint()
                    ..strokeCap = StrokeCap.round
                    ..isAntiAlias = true
                    ..color = selectedColor
                        .withOpacity(mode == DrawingMode.erase ? 0 : 1)
                    ..strokeWidth = strokeWidth,
                ));
              });
            },
            onPanUpdate: (details) {
              setState(() {
                RenderBox object = context.findRenderObject() as RenderBox;
                Offset localPosition =
                    object.globalToLocal(details.localPosition);
                points.add(DrawingPoint(
                  offset: localPosition,
                  paint: Paint()
                    ..strokeCap = StrokeCap.round
                    ..isAntiAlias = true
                    ..color = selectedColor
                        .withOpacity(mode == DrawingMode.erase ? 0 : 1)
                    ..strokeWidth = strokeWidth,
                ));
              });
            },
            onPanEnd: (details) {
              points.add(null);
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(points: points),
            ),
          ),
        ),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.color_lens),
                onPressed: () {
                  _pickColor();
                },
              ),
              IconButton(
                icon: const Icon(Icons.brush),
                onPressed: () {
                  _selectStrokeWidth();
                },
              ),
              IconButton(
                icon: const Icon(Icons.layers_clear),
                onPressed: () {
                  setState(() {
                    points.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _pickColor() async {
    // Implement color picking logic
    // For example, use a package like 'flutter_colorpicker' to let the user pick a color
  }

  void _selectStrokeWidth() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        double selectedStrokeWidth = strokeWidth;
        return AlertDialog(
          title: const Text('Select Stroke Width'),
          content: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Slider(
                value: selectedStrokeWidth,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (double value) {
                  setState(() {
                    selectedStrokeWidth = value;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  strokeWidth = selectedStrokeWidth;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

enum DrawingMode { draw, erase }

class DrawingPoint {
  Paint paint;
  Offset offset;

  DrawingPoint({required this.offset, required this.paint});
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.points});
  final List<DrawingPoint?> points;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i]!.offset, points[i + 1]!.offset, points[i]!.paint);
      } else if (points[i] != null && points[i + 1] == null) {
        // draw for single tap
        canvas.drawPoints(
            ui.PointMode.points, [points[i]!.offset], points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

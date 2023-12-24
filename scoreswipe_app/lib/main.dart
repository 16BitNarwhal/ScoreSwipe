import 'package:flutter/material.dart';
import 'features/score_viewer/ui/score_viewer.dart';
import 'features/score_browser/ui/score_browser_screen.dart';
import 'features/score_viewer/ui/configscreen.dart';
import 'features/score_creator/ui/score_creator_screen.dart';
import 'titlescreen.dart';

import 'experiment.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/score_browser/bloc/score_browser_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'Score Swipe';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScoreBrowserBloc>(
          create: (context) => ScoreBrowserBloc(),
        ),
      ],
      child: MaterialApp(
          title: title,
          theme: ThemeData(
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xFFDAF1FA),
              onPrimary: Color(0xFF17426A),
              secondary: Color(0xFF72BEE8),
              onSecondary: Color(0xFFFFFFFF),
              error: Color(0xFFFB8188),
              onError: Color(0xFF000000),
              background: Color(0xFFFFFFFF),
              onBackground: Color(0xFF17426A),
              surface: Color(0xFFF2F6F9),
              onSurface: Color(0xFF0F2438),
            ),
            useMaterial3: true,
            fontFamily: 'Inter',
          ),
          initialRoute: '/mainscreen',
          routes: {
            // '/experiment': (context) =>
            //     const TestingScreen(), // TODO: DONT PUSH TO PROD
            '/mainscreen': (context) => const ScoreBrowserScreen(),
            // '/titlescreen': (context) => TitleScreen(title: title),
            '/pdfscreen': (context) => const PdfScreen(),
            '/createscreen': (context) => const ScoreCreatorScreen(),
            '/configscreen': (context) => const ConfigScreen(),
          }),
    );
  }
}

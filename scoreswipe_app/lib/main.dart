import 'package:flutter/material.dart';
import 'pdfscreen.dart';
import 'mainscreen.dart';
import 'configscreen.dart';
import 'titlescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'Score Swipe';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: title,
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF87B7FF),
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color(0xFF76C6D1),
            onSecondary: Color(0xFFFFFFFF),
            error: Color(0xFFFB8188),
            onError: Color(0xFFFFFFFF),
            background: Color(0xFFFFFFFF),
            onBackground: Color(0xFF000000),
            surface: Color(0xFF87B7FF),
            onSurface: Color(0xFFFFFFFF),
          ),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        initialRoute: '/mainscreen',
        routes: {
          '/mainscreen': (context) => const MainScreen(),
          // '/titlescreen': (context) => TitleScreen(title: title),
          '/pdfscreen': (context) => const PdfScreen(),
          '/configscreen': (context) => const ConfigScreen(),
        });
  }
}

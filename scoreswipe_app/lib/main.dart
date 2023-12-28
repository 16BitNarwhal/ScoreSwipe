import 'package:flutter/material.dart';
import 'features/score_viewer/ui/score_viewer.dart';
import 'features/score_browser/ui/score_browser_screen.dart';
import 'features/score_viewer/ui/configscreen.dart';
import 'features/score_creator/ui/score_creator_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/score_browser/bloc/score_browser_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            error: Color(0xFFF8CBCC),
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
          '/mainscreen': (context) => const Navigation(),
          '/pdfscreen': (context) => const PdfScreen(),
        },
      ),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ScoreBrowserScreen(),
    const ScoreCreatorScreen(),
    const ConfigScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_sharp),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

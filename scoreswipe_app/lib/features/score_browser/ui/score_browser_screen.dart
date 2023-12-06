import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../filemanager.dart';
import '../../../scoredata.dart';

import '../bloc/score_browser_bloc.dart';

part 'add_score_button.dart';
part 'edit_score_form.dart';
part 'edit_score_button.dart';
part 'favorite_button.dart';
part 'score_list.dart';
part 'score_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double tabHeight = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        tabHeight = MediaQuery.of(context).size.height * 0.75;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
        child: Stack(
          children: [
            const AppBarView(),
            MusicSheetsView(tabHeight: tabHeight),
          ],
        ),
      ),
      floatingActionButton: const ActionsButton(),
    );
  }
}

class AppBarView extends StatelessWidget {
  final int tabHeight;
  const AppBarView({super.key, this.tabHeight = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      height: MediaQuery.of(context).size.height - tabHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Some',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          height: 0.3),
                    ),
                    Text(
                      'Music',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Handle search icon tap
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: () {
                        // Handle account icon tap
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

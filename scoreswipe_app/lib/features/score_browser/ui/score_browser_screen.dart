import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../../filemanager.dart'; // TODO: this is a temporary fix
import 'dart:io';

import '../models/score_model.dart';
import '../bloc/score_browser_bloc.dart';

import 'package:logger/logger.dart';

part 'add_score_button.dart';
part 'edit_score_form.dart';
part 'edit_score_button.dart';
part 'favorite_button.dart';
part 'score_list.dart';
part 'score_card.dart';

class ScoreBrowserScreen extends StatefulWidget {
  const ScoreBrowserScreen({Key? key}) : super(key: key);

  @override
  State<ScoreBrowserScreen> createState() => _ScoreBrowserScreenState();
}

class _ScoreBrowserScreenState extends State<ScoreBrowserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: const SafeArea(
        child: Stack(
          children: [
            AppBarView(),
            MusicSheetsView(),
          ],
        ),
      ),
      floatingActionButton: const ActionsButton(),
    );
  }
}

class AppBarView extends StatelessWidget {
  const AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      height: MediaQuery.of(context).size.height,
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

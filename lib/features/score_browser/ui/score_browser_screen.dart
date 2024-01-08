import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:score_swipe/common/models/score_model.dart';
import 'package:score_swipe/features/score_browser/bloc/score_browser_bloc.dart';

import 'package:logger/logger.dart';

part 'edit_score_form.dart';
part 'score_card_button.dart';
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const SafeArea(
        child: Column(
          children: [
            AppBarView(),
            Expanded(child: MusicSheetsView()),
          ],
        ),
      ),
    );
  }
}

class AppBarView extends StatefulWidget {
  const AppBarView({Key? key}) : super(key: key);

  @override
  State<AppBarView> createState() => _AppBarViewState();
}

class _AppBarViewState extends State<AppBarView> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Make Some ',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          height: 0.3),
                    ),
                    const Text(
                      'Music',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.help_outline,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      iconSize: 24,
                      onPressed: () {
                        ShowCaseWidget.of(context).startShowCase(
                          List.generate(
                            context.read<ShowcaseBloc>().keys.length,
                            (index) => context.read<ShowcaseBloc>().keys[index],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (query) {
                            BlocProvider.of<ScoreBrowserBloc>(context)
                                .add(SearchScores(query));
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

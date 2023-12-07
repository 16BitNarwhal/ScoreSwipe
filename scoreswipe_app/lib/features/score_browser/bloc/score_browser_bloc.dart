import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:io';

import 'package:pdfplayer/features/score_browser/models/score_model.dart';
import '../data/local_score_repository.dart';

part 'score_browser_event.dart';
part 'score_browser_state.dart';

class ScoreBrowserBloc extends Bloc<ScoreBrowserEvent, ScoreBrowserState> {
  ScoreBrowserBloc() : super(ScoreBrowserLoading()) {
    on<LoadScores>((event, emit) async {
      LocalScoreRepository.listAllScores().then((scores) {
        emit(ScoreBrowserLoaded(scores: scores));
      }).catchError((error) {
        print('ScrowBrowser on<LoadScores> : $error');
      });
    });
    on<AddScore>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        LocalScoreRepository.saveScore(event.score).then((_) {
          final state = this.state as ScoreBrowserLoaded;
          emit(
            ScoreBrowserLoaded(
              scores: List<ScoreModel>.from(state.scores)..add(event.score),
            ),
          );
        }).catchError((error) {
          print('ScrowBrowser on<AddScore> : $error');
        });
      }
    });
    on<AddScoreFromFilePicker>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        LocalScoreRepository.addScoresFromFilePicker().then((scores) {
          final state = this.state as ScoreBrowserLoaded;
          emit(
            ScoreBrowserLoaded(
              scores: List<ScoreModel>.from(state.scores)..addAll(scores),
            ),
          );
        }).catchError((error) {
          print('ScrowBrowser on<AddScoreFromFilePicker> : $error');
        });
      }
    });
    on<RemoveScore>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        LocalScoreRepository.deleteScore(event.score).then((_) {
          final state = this.state as ScoreBrowserLoaded;
          emit(
            ScoreBrowserLoaded(
              scores: List<ScoreModel>.from(state.scores)..remove(event.score),
            ),
          );
        }).catchError((error) {
          print('ScrowBrowser on<RemoveScore> : $error');
        });
      }
    });
  }
}

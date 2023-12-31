import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:io';

import 'package:score_swipe/common/data/local_score_repository.dart';
import 'package:score_swipe/common/models/score_model.dart';

import 'package:logger/logger.dart';

part 'score_browser_event.dart';
part 'score_browser_state.dart';

class ScoreBrowserBloc extends Bloc<ScoreBrowserEvent, ScoreBrowserState> {
  ScoreBrowserBloc() : super(ScoreBrowserLoading()) {
    on<LoadScores>((event, emit) async {
      try {
        List<ScoreModel> scores = await LocalScoreRepository.getAllScores();
        emit(ScoreBrowserLoaded(scores: scores));
        Logger().i('Finished loading ${scores.length} scores');
      } catch (error) {
        Logger().e('on<LoadScores> : $error');
      }
    });
    on<SearchScores>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        try {
          List<ScoreModel> scores = await LocalScoreRepository.getAllScores();
          scores = scores
              .where((score) => score.scoreName
                  .toLowerCase()
                  .contains(event.query.toLowerCase()))
              .toList();

          emit(ScoreBrowserLoaded(scores: scores));
          Logger().i('Finished searching ${scores.length} scores');
        } catch (error) {
          Logger().e('on<SearchScores> : $error');
        }
      }
    });
    on<AddScore>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        try {
          ScoreModel score = await LocalScoreRepository.insertScoreFromImages(
              event.images,
              scoreName: event.scoreName);

          emit(ScoreBrowserLoaded(scores: state.scores + [score]));

          Logger().i('Added score ${score.scoreName}');
        } catch (error) {
          Logger().e('on<AddScore> : $error');
        }
      }
    });
    on<DeleteScore>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        try {
          await LocalScoreRepository.deleteScore(event.score.id);

          emit(ScoreBrowserLoaded(
              scores: state.scores
                  .where((score) => score.id != event.score.id)
                  .toList()));

          Logger().i('Deleted score $event.id');
        } catch (error) {
          Logger().e('on<DeleteScore> : $error');
        }
      }
    });
    on<ToggleFavorite>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        try {
          event.score.isFavorite = !event.score.isFavorite;
          await LocalScoreRepository.updateScore(event.score);

          emit(ScoreBrowserLoaded(
              scores: state.scores
                  .map((score) =>
                      score.id == event.score.id ? event.score : score)
                  .toList()));

          Logger().i('Toggled favorite for score ${event.score.id}');
        } catch (error) {
          Logger().e('on<ToggleFavorite> : $error');
        }
      }
    });
    on<EditScore>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        try {
          await LocalScoreRepository.updateScore(event.newScore);

          emit(ScoreBrowserLoaded(
              scores: state.scores
                  .map((score) =>
                      score.id == event.newScore.id ? event.newScore : score)
                  .toList()));
        } catch (error) {
          Logger().e('on<EditScore> : $error');
        }
      }
    });
    on<SortScores>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        try {
          emit(ScoreBrowserLoaded(scores: state.scores, sortBy: event.sortBy));
        } catch (error) {
          Logger().e('on<SortScores> : $error');
        }
      }
    });
    on<ReverseScores>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        try {
          emit(ScoreBrowserLoaded(
              scores: state.scores, reverse: !state.reverse));
        } catch (error) {
          Logger().e('on<ReverseScores> : $error');
        }
      }
    });
  }

  @override
  void onChange(Change<ScoreBrowserState> change) {
    Logger().i('onChange: $change');
    super.onChange(change);
  }

  @override
  void onEvent(ScoreBrowserEvent event) {
    Logger().i('onEvent: $event');
    super.onEvent(event);
  }

  @override
  void onTransition(
      Transition<ScoreBrowserEvent, ScoreBrowserState> transition) {
    Logger().i('onTransition: $transition');
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    Logger().e('onError: $error');
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    Logger().i('Closing ScoreBrowserBloc');
    LocalScoreRepository.close();
    return super.close();
  }
}

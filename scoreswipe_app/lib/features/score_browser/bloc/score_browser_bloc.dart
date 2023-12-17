import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:logger/logger.dart';

import 'package:pdfplayer/features/score_browser/models/score_model.dart';
import 'package:pdfplayer/features/score_browser/data/local_score_datasource.dart';

part 'score_browser_event.dart';
part 'score_browser_state.dart';

class ScoreBrowserBloc extends Bloc<ScoreBrowserEvent, ScoreBrowserState> {
  ScoreBrowserBloc() : super(const ScoreBrowserLoading()) {
    on<LoadScores>((event, emit) async {
      try {
        await LocalScoreDataSource.openDatabase();
        List<ScoreModel> scores = await LocalScoreDataSource.getAllScores();
        emit(ScoreBrowserLoaded(scores: scores));
        Logger().i('Finished loading ${scores.length} scores');
      } catch (error) {
        Logger().e('on<LoadScores> : $error');
      }
      // TODO: move close database to when widget is disposed
    });
    on<AddScore>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        try {
          await LocalScoreDataSource.insertScore(event.score);

          emit(ScoreBrowserLoaded(scores: state.scores + [event.score]));

          Logger().i('Added score ${event.score.scoreName}');
        } catch (error) {
          Logger().e('on<AddScore> : $error');
        }
      }
    });
    on<DeleteScore>((event, emit) async {
      Logger().wtf('Deleting score ${event.score.id}');
      Logger().wtf(state);
      if (state is ScoreBrowserLoaded) {
        try {
          await LocalScoreDataSource.deleteScore(event.score.id);

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
          await LocalScoreDataSource.updateScore(event.score);

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
          if (event.scoreName != null) event.score.scoreName = event.scoreName!;

          event.score.lastOpened = DateTime.now();

          await LocalScoreDataSource.updateScore(event.score);

          List<ScoreModel> scores = state.scores
              .where((score) => score.id == event.score.id)
              .toList();
          Logger().wtf(scores);

          emit(ScoreBrowserLoaded(
              scores: state.scores
                  .map((score) =>
                      score.id == event.score.id ? event.score : score)
                  .toList()));

          Logger().wtf('Edited score ${event.score.scoreName}');
        } catch (error) {
          Logger().e('on<EditScore> : $error');
        }
      }
    });
    // on<AddScoreFromFilePicker>((event, emit) async {
    //   if (state is ScoreBrowserLoaded) {
    //     try {
    //       FilePickerResult? result = await FilePicker
    //           .platform // FilePicker not working in the BLoC
    //           .pickFiles(
    //               type: FileType.custom,
    //               allowedExtensions: ['pdf'],
    //               allowMultiple: true);
    //       Logger().wtf(result);
    //       if (result == null || result.files.isEmpty) {
    //         Logger().i('No files selected');
    //         return;
    //       }

    //       List<ScoreModel> scores = [];
    //       List<Future<void>> futures = [];
    //       for (PlatformFile file in result.files) {
    //         final score = ScoreModel.fromPdfFile(File(file.path!));
    //         futures.add(
    //             score.createThumbnailImage()); // TODO: move to a separate class
    //         scores.add(score);
    //       }
    //       await Future.wait(futures);
    //       futures = [];
    //       for (ScoreModel score in scores) {
    //         futures.add(LocalScoreDataSource.insertScore(score));
    //       }
    //       await Future.wait(futures);
    //       emit(const ScoreBrowserLoading());
    //     } catch (error) {
    //       Logger().e('on<AddScoreFromFilePicker> : $error');
    //     }
    //   }
    // });
  }

  // TODO: change to a single BlocObserver
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
    return super.close();
  }
}

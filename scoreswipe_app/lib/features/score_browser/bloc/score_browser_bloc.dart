import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:pdfplayer/features/score_browser/models/score_model.dart';
import '../data/score_browser_repository.dart';

part 'score_browser_event.dart';
part 'score_browser_state.dart';

class ScoreBrowserBloc extends Bloc<ScoreBrowserEvent, ScoreBrowserState> {
  ScoreBrowserBloc() : super(ScoreBrowserLoading()) {
    on<LoadScores>((event, emit) async {
      LocalScoreRepository().listAllScores().then((scores) {
        emit(ScoreBrowserLoaded(scores: scores));
      });
    });
    on<AddScore>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        final state = this.state as ScoreBrowserLoaded;
        LocalScoreRepository().saveScore(event.score);
        emit(
          ScoreBrowserLoaded(
            scores: List<ScoreModel>.from(state.scores)..add(event.score),
          ),
        );
      }
    });
    on<RemoveScore>((event, emit) async {
      if (state is ScoreBrowserLoaded) {
        final state = this.state as ScoreBrowserLoaded;
        LocalScoreRepository().deleteScore(event.score);
        emit(
          ScoreBrowserLoaded(
            scores: List<ScoreModel>.from(state.scores)..remove(event.score),
          ),
        );
      }
    });
  }
}

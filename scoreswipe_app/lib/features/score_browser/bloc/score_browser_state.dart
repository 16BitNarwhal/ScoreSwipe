part of 'score_browser_bloc.dart';

@immutable
sealed class ScoreBrowserState {
  final List<ScoreModel> scores;

  const ScoreBrowserState({this.scores = const []});
}

final class ScoreBrowserLoading extends ScoreBrowserState {
  const ScoreBrowserLoading();
}

final class ScoreBrowserLoaded extends ScoreBrowserState {
  const ScoreBrowserLoaded({required super.scores});
}

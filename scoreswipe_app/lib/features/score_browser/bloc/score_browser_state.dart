part of 'score_browser_bloc.dart';

@immutable
sealed class ScoreBrowserState {
  final List<ScoreModel> scores;
  final String query;

  const ScoreBrowserState({this.scores = const [], this.query = ""});
}

final class ScoreBrowserLoading extends ScoreBrowserState {
  const ScoreBrowserLoading();
}

final class ScoreBrowserLoaded extends ScoreBrowserState {
  const ScoreBrowserLoaded({required super.scores});
}

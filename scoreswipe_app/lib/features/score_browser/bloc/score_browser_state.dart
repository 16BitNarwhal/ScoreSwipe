part of 'score_browser_bloc.dart';

@immutable
sealed class ScoreBrowserState extends Equatable {
  final List<ScoreModel> scores;

  const ScoreBrowserState({this.scores = const []});

  @override
  List<Object> get props => [];
}

final class ScoreBrowserLoading extends ScoreBrowserState {
  const ScoreBrowserLoading();

  @override
  List<Object> get props => [];
}

final class ScoreBrowserLoaded extends ScoreBrowserState {
  const ScoreBrowserLoaded({required super.scores});

  @override
  List<Object> get props => [scores];
}

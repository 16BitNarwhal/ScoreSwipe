part of 'score_browser_bloc.dart';

@immutable
sealed class ScoreBrowserState extends Equatable {
  const ScoreBrowserState();

  @override
  List<Object> get props => [];
}

final class ScoreBrowserLoading extends ScoreBrowserState {}

final class ScoreBrowserLoaded extends ScoreBrowserState {
  final List<ScoreModel> scores;

  const ScoreBrowserLoaded({required this.scores});

  @override
  List<Object> get props => [scores];
}

final class ScoreBrowserError extends ScoreBrowserState {
  final String message;

  const ScoreBrowserError({required this.message});

  @override
  List<Object> get props => [message];
}

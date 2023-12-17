part of 'score_browser_bloc.dart';

@immutable
sealed class ScoreBrowserEvent extends Equatable {
  const ScoreBrowserEvent();

  @override
  List<Object> get props => [];
}

final class LoadScores extends ScoreBrowserEvent {}

final class AddScore extends ScoreBrowserEvent {
  final ScoreModel score;

  const AddScore(this.score);

  @override
  List<Object> get props => [score];
}

final class AddScoreFromFilePicker extends ScoreBrowserEvent {}

final class DeleteScore extends ScoreBrowserEvent {
  final ScoreModel score;

  const DeleteScore(this.score);

  @override
  List<Object> get props => [score];
}

final class ToggleFavorite extends ScoreBrowserEvent {
  final ScoreModel score;

  const ToggleFavorite(this.score);

  @override
  List<Object> get props => [score];
}

final class EditScore extends ScoreBrowserEvent {
  final ScoreModel score;
  final String? scoreName;

  const EditScore(this.score, {this.scoreName});

  @override
  List<Object> get props => [score];
}

part of 'score_browser_bloc.dart';

@immutable
sealed class ScoreBrowserEvent extends Equatable {
  const ScoreBrowserEvent();

  @override
  List<Object> get props => [];
}

final class LoadScores extends ScoreBrowserEvent {}

final class SearchScores extends ScoreBrowserEvent {
  final String query;

  const SearchScores(this.query);

  @override
  List<Object> get props => [query];
}

final class AddScore extends ScoreBrowserEvent {
  final List<File> images;
  final String scoreName;

  const AddScore(this.images, this.scoreName);

  @override
  List<Object> get props => [images, scoreName];
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
  final ScoreModel newScore;

  const EditScore(this.newScore);

  @override
  List<Object> get props => [newScore];
}

final class SortScores extends ScoreBrowserEvent {
  final SortBy sortBy;

  const SortScores(this.sortBy);

  @override
  List<Object> get props => [sortBy];
}

final class ReverseScores extends ScoreBrowserEvent {
  const ReverseScores();

  @override
  List<Object> get props => [];
}

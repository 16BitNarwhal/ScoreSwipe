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
  final String sortBy;
  final String sortOrder;

  const SearchScores(this.query, this.sortBy, this.sortOrder);

  @override
  List<Object> get props => [query, sortBy, sortOrder];
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

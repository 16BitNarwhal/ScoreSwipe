part of 'score_browser_bloc.dart';

enum SortBy {
  name,
  lastOpened,
  uploaded,
}

sealed class ScoreBrowserState {
  List<ScoreModel> scores;
  final SortBy sortBy;
  final bool reverse;

  ScoreBrowserState(
      {this.scores = const [],
      this.sortBy = SortBy.lastOpened,
      this.reverse = false});
}

final class ScoreBrowserLoading extends ScoreBrowserState {
  ScoreBrowserLoading();
}

final class ScoreBrowserLoaded extends ScoreBrowserState {
  ScoreBrowserLoaded(
      {required List<ScoreModel> scores, super.sortBy, super.reverse}) {
    switch (sortBy) {
      case SortBy.name:
        scores.sort((a, b) => a.scoreName.compareTo(b.scoreName));
        break;
      case SortBy.lastOpened:
        scores.sort((b, a) => a.lastOpened.compareTo(b.lastOpened));
        break;
      case SortBy.uploaded:
        scores.sort((b, a) => a.uploaded.compareTo(b.uploaded));
        break;
    }
    if (reverse) {
      scores = scores.reversed.toList();
    }
    super.scores = scores;
  }
}

part of 'score_browser_bloc.dart';

enum SortBy {
  name,
  nameReverse,
  lastOpened,
  lastOpenedReverse,
  uploaded,
  uploadedReverse
}

sealed class ScoreBrowserState {
  List<ScoreModel> scores;
  final SortBy sortBy;

  ScoreBrowserState({this.scores = const [], this.sortBy = SortBy.lastOpened});
}

final class ScoreBrowserLoading extends ScoreBrowserState {
  ScoreBrowserLoading();
}

final class ScoreBrowserLoaded extends ScoreBrowserState {
  ScoreBrowserLoaded({required List<ScoreModel> scores, super.sortBy}) {
    switch (super.sortBy) {
      case SortBy.name:
        scores.sort((a, b) => a.scoreName.compareTo(b.scoreName));
        break;
      case SortBy.nameReverse:
        scores.sort((a, b) => b.scoreName.compareTo(a.scoreName));
        break;
      case SortBy.lastOpened:
        scores.sort((b, a) => a.lastOpened.compareTo(b.lastOpened));
        break;
      case SortBy.lastOpenedReverse:
        scores.sort((b, a) => b.lastOpened.compareTo(a.lastOpened));
        break;
      case SortBy.uploaded:
        scores.sort((b, a) => a.uploaded.compareTo(b.uploaded));
        break;
      case SortBy.uploadedReverse:
        scores.sort((b, a) => b.uploaded.compareTo(a.uploaded));
        break;
    }
    super.scores = scores;
  }
}

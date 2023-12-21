part of 'score_creator_bloc.dart';

@immutable
sealed class ScoreCreatorEvent extends Equatable {
  const ScoreCreatorEvent();

  @override
  List<Object> get props => [];
}

final class ChangePage extends ScoreCreatorEvent {
  final int page;

  const ChangePage(this.page);
}

final class AddImage extends ScoreCreatorEvent {}

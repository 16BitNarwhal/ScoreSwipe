part of 'score_creator_bloc.dart';

@immutable
sealed class ScoreCreatorState {
  final List<Image> images;
  final int page;

  get numPages => images.length;

  const ScoreCreatorState({this.images = const [], this.page = 0});
}

final class ScoreCreator extends ScoreCreatorState {
  const ScoreCreator({super.images, super.page});

  ScoreCreator copyWith({List<Image>? images, int? page}) {
    return ScoreCreator(images: images ?? this.images, page: page ?? this.page);
  }
}

final class ScoreCreatorWaitingForImage extends ScoreCreatorState {}

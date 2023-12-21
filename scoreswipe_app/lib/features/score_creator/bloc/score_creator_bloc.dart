import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:image/image.dart';
import 'package:pdf/pdf.dart';
import 'package:equatable/equatable.dart';

part 'score_creator_event.dart';
part 'score_creator_state.dart';

class ScoreCreatorBloc extends Bloc<ScoreCreatorEvent, ScoreCreatorState> {
  ScoreCreatorBloc() : super(const ScoreCreator()) {
    on<ScoreCreatorEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ChangePage>((event, emit) {
      if (state is ScoreCreator) {
        emit((state as ScoreCreator).copyWith(page: event.page));
      }
    });
    on<AddImage>((event, emit) {
      if (state is ScoreCreator) {
        emit(ScoreCreatorWaitingForImage());

        // implement image getting logic

        // Image image;

        // emit((state as ScoreCreator)
        //     .copyWith(images: (state as ScoreCreator).images + [image]));
      }
    });
  }
}

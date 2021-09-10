import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

part 'subtitle_event.dart';
part 'subtitle_state.dart';

class SubtitleBloc extends Bloc<SubtitleEvent, SubtitleState> {
  final BetterPlayerController controller;
  final SubtitleRepository subtitleRepository;
  final SubtitleController subtitleController;

  late Subtitles subtitles;

  SubtitleBloc({
    required this.controller,
    required this.subtitleRepository,
    required this.subtitleController,
  }) : super(SubtitleInitial()) {
    subtitleController.attach(this);
    on<LoadSubtitle>((event, emit) => loadSubtitle(emit: emit));
    on<InitSubtitles>((event, emit) => initSubtitles(emit: emit));
    on<UpdateLoadedSubtitle>(
      (event, emit) => emit(LoadedSubtitle(event.subtitle)),
    );
    on<CompletedShowingSubtitles>(
      (event, emit) => emit(CompletedSubtitle()),
    );
  }

  Future<void> initSubtitles({
    required Emitter<SubtitleState> emit,
  }) async {
    emit(SubtitleInitializing());
    subtitles = await subtitleRepository.getSubtitles();
    emit(SubtitleInitialized());
  }

  Future<void> loadSubtitle({
    required Emitter<SubtitleState> emit,
  }) async {
    emit(LoadingSubtitle());
    final videoPlayerController = controller.videoPlayerController;

    videoPlayerController?.addListener(
      () {
        final videoPlayerPosition = videoPlayerController.value.position;
        final subtitleItem = subtitles.subtitles.singleWhere(
          (subtitle) =>
              videoPlayerPosition.inMilliseconds > subtitle.startTime.inMilliseconds &&
              videoPlayerPosition.inMilliseconds < subtitle.endTime.inMilliseconds,
          orElse: () => const Subtitle(startTime: Duration.zero, endTime: Duration.zero, text: ''),
        );

        add(UpdateLoadedSubtitle(subtitle: subtitleItem));
      },
    );
  }

  @override
  Future<void> close() {
    subtitleController.detach();

    return super.close();
  }
}

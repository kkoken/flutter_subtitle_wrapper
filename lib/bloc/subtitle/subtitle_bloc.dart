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
    controller.videoPlayerController?.addListener(_listener);
  }

  @override
  Future<void> close() {
    subtitleController.detach();
    controller.videoPlayerController?.removeListener(_listener);

    return super.close();
  }

  void _listener() {
    final videoPlayerController = controller.videoPlayerController;

    final videoPlayerPosition = videoPlayerController?.value.position;
    final subtitleItem = subtitles.subtitles.singleWhere(
      (subtitle) =>
          (videoPlayerPosition?.inMilliseconds ?? 0) > subtitle.startTime.inMilliseconds &&
          (videoPlayerPosition?.inMilliseconds ?? 0) < subtitle.endTime.inMilliseconds,
      orElse: () => const Subtitle(
        endTime: Duration.zero,
        startTime: Duration.zero,
        text: '',
      ),
    );

    add(UpdateLoadedSubtitle(subtitle: subtitleItem));
  }
}

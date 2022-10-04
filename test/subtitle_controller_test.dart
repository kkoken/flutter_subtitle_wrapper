import 'package:better_player/better_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';

class MockVideoPlayerController extends Mock implements BetterPlayerController {}

void main() {
  final _subtitleController = SubtitleController(
    subtitleUrl: 'https://pastebin.com/raw/ZWWAL7fK',
    subtitleDecoder: SubtitleDecoder.utf8,
  );

  group(
    'Subtitle controller',
    () {
      test(
        'attach',
        () async {
          _subtitleController.attach(
            SubtitleBloc(
              subtitleController: _subtitleController,
              subtitleRepository: SubtitleDataRepository(
                subtitleController: _subtitleController,
              ),
              controller: MockVideoPlayerController(),
            ),
          );
        },
      );
      test('detach', () async {
        _subtitleController.detach();
      });

      test('update subtitle url', () async {
        _subtitleController.attach(
          SubtitleBloc(
            subtitleController: _subtitleController,
            subtitleRepository: SubtitleDataRepository(
              subtitleController: _subtitleController,
            ),
            controller: MockVideoPlayerController(),
          ),
        );
        _subtitleController.updateSubtitleUrl(
          url: 'https://pastebin.com/raw/ZWWAL7fK',
        );
      });

      test('update subtitle content', () async {
        _subtitleController.attach(
          SubtitleBloc(
            subtitleController: _subtitleController,
            subtitleRepository: SubtitleDataRepository(
              subtitleController: _subtitleController,
            ),
            controller: MockVideoPlayerController(),
          ),
        );
        _subtitleController.updateSubtitleContent(
          content: '',
        );
      });

      test(
        'update subtitle content without attach',
        () {
          expect(
            () {
              _subtitleController.detach();
              _subtitleController.updateSubtitleContent(
                content: '',
              );
            },
            throwsException,
          );
        },
      );

      test('update subtitle url without attach', () {
        expect(
          () {
            _subtitleController.detach();
            _subtitleController.updateSubtitleUrl(
              url: 'https://pastebin.com/raw/ZWWAL7fK',
            );
          },
          throwsException,
        );
      });
    },
  );
}

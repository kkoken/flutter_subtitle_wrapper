import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

// ignore: prefer-match-file-name, this has a different name because of the deprecation.
class SubTitleWrapper extends SubtitleWrapper {
  @Deprecated("Renamed to SubtitleWrapper")
  const SubTitleWrapper({
    Key? key,
    required Widget videoChild,
    required SubtitleController subtitleController,
    required BetterPlayerController videoPlayerController,
    SubtitleStyle subtitleStyle = const SubtitleStyle(),
    Color? backgroundColor,
  }) : super(
          key: key,
          videoChild: videoChild,
          subtitleController: subtitleController,
          videoPlayerController: videoPlayerController,
          subtitleStyle: subtitleStyle,
          backgroundColor: backgroundColor,
        );
}

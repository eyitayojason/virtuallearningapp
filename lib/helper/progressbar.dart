// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:virtuallearningapp/main.dart';

// class PageManager {
//   final progressNotifier = ValueNotifier<ProgressBarState>(
//     ProgressBarState(
//       current: Duration.zero,
//       buffered: Duration.zero,
//       total: Duration.zero,
//     ),
//   );
//   final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
//   AudioPlayer _audioPlayer;
//   PageManager() {
//     _init();
//   }
//   void _init() async {
//     _audioPlayer = AudioPlayer();
//     await _audioPlayer.setUrl(recordingURL);
//     _audioPlayer.playerStateStream.listen((playerState) {
//       final isPlaying = playerState.playing;
//       final processingState = playerState.processingState;
//       if (processingState == ProcessingState.loading ||
//           processingState == ProcessingState.buffering) {
//         buttonNotifier.value = ButtonState.loading;
//       } else if (!isPlaying) {
//         buttonNotifier.value = ButtonState.paused;
//       } else {
//         buttonNotifier.value = ButtonState.playing;
//       }
//     });
//   }

//   void play() {
//     _audioPlayer.play();
//   }

//   void pause() {
//     _audioPlayer.pause();
//   }

//   void dispose() {
//     _audioPlayer.dispose();
//   }
// }

// class ProgressBarState {
//   ProgressBarState({
//     @required this.current,
//     @required this.buffered,
//     @required this.total,
//   });
//   final Duration current;
//   final Duration buffered;
//   final Duration total;
// }

// enum ButtonState { paused, playing, loading }

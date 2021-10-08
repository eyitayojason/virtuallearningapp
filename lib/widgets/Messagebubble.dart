import 'dart:async';
import 'package:audio_wave/audio_wave.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:better_player/better_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:virtuallearningapp/services%20and%20providers/auth.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    this.sender,
    this.text,
    this.timestamp,
    this.audioname,
    this.picture,
    this.index,
    this.video,
    this.voiceNote,
    this.isMe,
    this.isPressed = false,
  });
  final timestamp;
  final String audioname;
  final String sender;
  final String text;
  final String picture;
  final int index;
  final String video;
  final String voiceNote;
  final bool isMe;
  final bool isPressed;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  Duration duration;
  Duration position;
  AudioPlayer audioPlayer;
  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';
  bool isMuted = false;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play(String url) async {
    await audioPlayer.play(url);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.sender,
            style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          widget.picture == null
              ? Container()
              : ExtendedImage.network(
                  widget.picture,
                  fit: BoxFit.scaleDown,
                  height: 400,
                  cache: true,
                  handleLoadingProgress: true,
                ),
          widget.voiceNote == null
              ? Container()
              : Card(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/mp3.png",
                          color: Colors.orange,
                          fit: BoxFit.cover,
                          height: 50,
                        ),
                        IconButton(
                          onPressed:
                              isPlaying ? null : () => play(widget.voiceNote),
                          iconSize: 40.0,
                          icon: Icon(Icons.play_arrow),
                          color: Colors.cyan,
                        ),
                        IconButton(
                          onPressed:
                              isPlaying || isPaused ? () => stop() : null,
                          iconSize: 40.0,
                          icon: Icon(Icons.stop),
                          color: Colors.cyan,
                        ),
                        isPlaying
                            ? buildAudiowaveBar()
                            : Flexible(
                                child: Text(
                                  widget.audioname.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
          widget.video == null
              ? Container()
              : BetterPlayer.network(
                  widget.video,
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                    aspectRatio: 10 / 5,
                    autoDispose: true,
                  ),
                ),
          widget.text == null
              ? Container()
              : Material(
                  borderRadius: widget.isMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                  elevation: 4,
                  color: widget.isMe ? Colors.lightBlueAccent : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          "${widget.text}",
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  widget.isMe ? Colors.white : Colors.black87),
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildAudiowaveBar() {
    return Flexible(
      child: AudioWave(
        height: 32,
        width: 88,
        spacing: 2.5,
        bars: [
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
        ],
      ),
    );
  }
}

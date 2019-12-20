import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerController _videoPlayerController;
  VideoPlayerWidget(this._videoPlayerController) : super();

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isPlayed = false;
  bool _isPaused = true;
  bool _tempPauseDisplay = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
          aspectRatio: widget._videoPlayerController.value.aspectRatio,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                VideoPlayer(widget._videoPlayerController),
                Align(
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    child: InkWell(
                      child: videoController(),
                      onTap: () {
                        setState(() {
                          if (!widget._videoPlayerController.value.isPlaying &&
                              !_isPlayed) {
                            _isPlayed = true;
                            _isPaused = false;
                            widget._videoPlayerController.play();
                          } else if (widget
                                  ._videoPlayerController.value.isPlaying &&
                              !_isPaused) {
                            widget._videoPlayerController.pause();
                            _isPaused = true;
                          } else if (_isPaused) {
                            _isPaused = false;
                            widget._videoPlayerController.play();
                          }
                        });
                      },
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                Align(
                  child: VideoProgressIndicator(
                    widget._videoPlayerController,
                    allowScrubbing: true,
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
            onTap: () {
              if (_isPlayed && widget._videoPlayerController.value.isPlaying) {
                setState(() {
                  _tempPauseDisplay = true;
                });
                Timer(Duration(seconds: 2), () {
                  setState(() {
                    _tempPauseDisplay = false;
                  });
                });
              }
            },
          )),
    );
  }

  Widget videoController() {
    if (!_isPlayed || _isPaused) {
      return Icon(
        Icons.play_arrow,
        size: 80.0,
        color: Colors.white,
      );
    } else if (_tempPauseDisplay) {
      return Icon(
        Icons.pause,
        size: 80.0,
        color: Colors.white,
      );
    } else {
      return Container(
        child: null,
      );
    }
  }
}

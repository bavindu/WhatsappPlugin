import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerController _videoPlayerController;
  VideoPlayerWidget(this._videoPlayerController) : super();

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
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
                child: VideoProgressIndicator(
                  widget._videoPlayerController,
                  allowScrubbing: true,
                ),
                alignment: Alignment.bottomCenter,
              ),
              Align(
                child: Builder(builder: (context){
                  if (!widget._videoPlayerController.value.isPlaying) {
                    return Icon(
                      Icons.play_arrow,
                      size: 80.0,
                      color: Colors.white,
                    );
                  } else if(widget._videoPlayerController.value.isPlaying) {
                    return Icon(
                      Icons.pause,
                      size: 80.0,
                      color: Colors.white,
                    );
                  } else {
                    return Container(child: null,);
                  }
                }),
                alignment: Alignment.center,
              )
            ],
          ),
          onTap: () {
            if (!widget._videoPlayerController.value.isPlaying) {
              widget._videoPlayerController.play();
            } else {
              widget._videoPlayerController.pause();
            }
            setState(() {});
          },
        ),
      ),
    );
  }
}

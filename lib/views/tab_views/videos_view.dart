import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/widgets/video_grid_item.dart';

import '../video_player_preview.dart';

class VideosView extends StatefulWidget {
  @override
  _VideosViewState createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && context != null) {
      print('resumed');
      Provider.of<VideosViewModel>(context, listen: false).getVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideosViewModel>(
      builder: (BuildContext context, VideosViewModel videosViewModel,
              Widget child) =>
          FutureBuilder(
              future: videosViewModel.getVideos(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return Container(
                        child: videosViewModel.videosList.length > 0
                            ? Scrollbar(
                                child: GridView.builder(
                                  itemCount: videosViewModel.videosList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GridTile(
                                      child: GestureDetector(
                                        child: Card(
                                          color: Colors.white70,
                                          elevation: 3.0,
                                          child: Container(
                                            child: videosViewModel
                                                    .videosList[index]
                                                    .isSelected
                                                ? Stack(
                                                    fit: StackFit.expand,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: VideoGridItem(
                                                              videosViewModel
                                                                  .videosList[
                                                                      index]
                                                                  .videoFile),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 80.0,
                                                      )
                                                    ],
                                                  )
                                                : VideoGridItem(videosViewModel
                                                    .videosList[index]
                                                    .videoFile),
                                            padding: EdgeInsets.all(5.0),
                                          ),
                                        ),
                                        onTap: () {
                                          if (videosViewModel.selectingMode ==
                                              true) {
                                            videosViewModel.tapOnVideo(index);
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoPlayerPreview(
                                                            index,
                                                            videosViewModel
                                                                .videosList)));
                                          }
                                        },
                                        onLongPress: () {
                                          videosViewModel.longPressed(index);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FractionallySizedBox(
                                        child: Container(
                                          child: Image.asset(
                                              'assets/images/no_data.png'),
                                        ),
                                        widthFactor: 0.5,
                                      ),
                                      Text(
                                        'No Status Found',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      Flexible(
                                          child: FractionallySizedBox(
                                        heightFactor: 0.1,
                                      ))
                                    ],
                                  ),
                                ),
                              ));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
    );
  }
}

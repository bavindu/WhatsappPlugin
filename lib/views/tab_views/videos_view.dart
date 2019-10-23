import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';

class VideosView extends StatefulWidget {
  @override
  _VideosViewState createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VideosViewModel>(
        builder: (BuildContext context, VideosViewModel videosViewModel,
                Widget child) =>
            Container(
              child: GridView.count(crossAxisCount: 2, children: List.generate(videosViewModel.videosList.length, (index){
                return GridTile(child: Image.file(videosViewModel.videosList[index].videoFile));
              }),),
            ));
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/views/video_cutter.view.dart';

class VideoCutterView extends StatefulWidget {
  @override
  _VideoCutterViewState createState() => _VideoCutterViewState();
}

class _VideoCutterViewState extends State<VideoCutterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          AppLocalizations.of(context).localizedValues['video_cutter'],
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: _getVideos,
                iconSize: 150.0,
              ),
            ),
            Container(
              child: Text(
                AppLocalizations.of(context).localizedValues['pick_video'],
                style: TextStyle(fontSize: 30.0),
              ),
            )
          ],
        ),
      )),
    );
  }

  void _getVideos() async {
    File pickedVideo = await FilePicker.getFile(type: FileType.video);
    print('Picked file path '+pickedVideo.path);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VideoCutter(pickedVideo)));
  }
}

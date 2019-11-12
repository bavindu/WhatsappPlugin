import 'dart:io';

import 'package:flutter/material.dart';


class StatusVideo {
  File _videoFile;
  bool _isSelected= false;
  Image _image;


  StatusVideo(videoFile){
    this._videoFile = videoFile;
  }

  set isSelected(bool value) {
    _isSelected = value;
  }

  set image(Image value) {
    _image = value;
  }

  File get videoFile => _videoFile;
  bool get isSelected => _isSelected;
  Image get image => _image;


}
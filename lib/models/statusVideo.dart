import 'dart:io';

import 'package:flutter/material.dart';


class StatusVideo {
  File _videoFile;
  bool _isSelected= false;


  StatusVideo(videoFile){
    this._videoFile = videoFile;
  }

  set isSelected(bool value) {
    _isSelected = value;
  }


  File get videoFile => _videoFile;
  bool get isSelected => _isSelected;



}
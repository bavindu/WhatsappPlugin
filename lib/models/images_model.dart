import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/images_view_states.dart';


class ImagesViewModel with ChangeNotifier {
  List<Image> _imgList = List();
  ImagesViewState _imageViewState = ImagesViewState.Idle;

  ImagesViewState get imageViewState => _imageViewState;
  List<Image> get imgList => _imgList;

  ImagesViewModel(){
    getImages();
  }

  void getImages() {
    _imageViewState = ImagesViewState.Busy;
    if (_imgList.length > 0) {
      _imgList.clear();
    }
    Directory dir = new Directory("storage/emulated/0/WhatsApp/Media/.Statuses");
    dir.list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      if (entity.path.endsWith("jpg")) {
        File img = entity as File;
        Image image = Image.file(img, fit: BoxFit.cover,);
        _imgList.add(image);
      }

    },
        onDone: (){
          _imageViewState = ImagesViewState.Idle;
          notifyListeners();
        }
    );

  }
  void tapOnImage() {
    print("tapped");
  }
  void longPressed(){
    print("long pressed");
  }
}
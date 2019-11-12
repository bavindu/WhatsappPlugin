import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class AndroidBridge {
  static const platform = const MethodChannel('android');

  static Future<Uint8List> getVideoThumbnail(File video) async {
    try {
      var thumbnail =await platform.invokeListMethod('getThumbnail',video.path);
      print("Got thumbnail");
      return thumbnail;
    } on PlatformException catch(e) {
      print ("failed to get thumnail ${e.message}");
    }

  }
}
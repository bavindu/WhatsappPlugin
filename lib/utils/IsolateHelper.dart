import 'dart:isolate';

import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:thumbnails/thumbnails.dart';

class IsolateHelper {
  FlutterIsolate _isolate;
  ReceivePort _receivePort;

  void start() async {
    _receivePort = ReceivePort();
    // _isolate = await FlutterIsolate.spawn(, _receivePort.sendPort);
  }

  static void isolateHandler() {

  }


  _getVideoThumbnail(String videoPath) async {
    String thumb = await Thumbnails.getThumbnail(
      videoFile: videoPath,
      imageType: ThumbFormat.PNG,
      quality: 10,
    );
    return thumb;
  }
}

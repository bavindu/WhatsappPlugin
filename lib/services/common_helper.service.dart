import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

import 'android_bridge.service.dart';


class CommonHelperService {

  AndroidBridge androidBridge = locator<AndroidBridge>();
  static List<Color> colorList = [
    Color(0xffEE0754),
    Color(0xffEE07C4),
    Color(0xff0737EE),
    Color(0xff07C2EE),
    Color(0xff0DFBC0),
    Color(0xffF9691D)
  ];


  Color getAvatarColor(int index) {
    if (index < colorList.length) {
      return colorList[index];
    } else {
      while (index >= colorList.length) {
        index = index - colorList.length;
      }
    }
    return colorList[index];
  }

  void saveFile(String rootPath, File file, BuildContext context) {
    String appDir = rootPath+APP_DIR;
    String filePath = file.path;
    String fileName = filePath.split('/').last;
    String savePath = appDir + '/' + fileName;
    try {
      File copiedFile = file.copySync(savePath);
      showSnakBar(context, 'Saved Successfully');
      androidBridge.mediaScan(copiedFile.path);
    } catch (error) {
      if (error is FileSystemException) {
        new Directory(appDir).createSync();
        file.copySync(savePath);
      }
    }
  }

  String setDisplayDate(DateTime date) {
    DateTime now = new DateTime.now();
    String displayDate;
    if (DateTime(now.year, now.month, now.day) == DateTime(date.year, date.month, date.day)) {
      var minute = date.minute.toString();
      var hour = date.hour.toString();
      if (minute.length == 1) {
        minute = '0' + minute;
      }
      if (hour.length == 1) {
        hour = '0' + hour;
      }
      displayDate = hour + '.' + minute;
    } else if (DateTime(now.year, now.month, now.day-1) == DateTime(date.year, date.month, date.day)) {
      displayDate = 'YesterDay';
    } else {
      displayDate = date.day.toString() + '/'  + date.month.toString() + '/' + date.year.toString();
    }
    return displayDate;
  }

  void showSnakBar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackbar);
  }

}

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class AppInitializer {
  String _rootPath;
  bool permissionGranted;
  AndroidBridge androidBridge = locator<AndroidBridge>();

  String get rootPath => _rootPath;

  Future initialize () async {
    var appDirectoryList = await getExternalStorageDirectories();
    String appPath = appDirectoryList[0].path;
    print('appPath '+appPath );
    if (appPath.contains('Android')) {
      int index = appPath.indexOf('Android');
      _rootPath = appPath.substring(0,index);
      print ('storage path' + _rootPath);
    }
  }

  Future<bool> checkPermission() async {
    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    bool hasNotificationAccess = await androidBridge.checkNotificationAccess();
    if (permissionStatus == PermissionStatus.granted && hasNotificationAccess) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkStoragePermission() async {
    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future requestStoragePermission() async{
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  Future requestNotificationAccess() async{
    androidBridge.getNotificationAccess();
  }
}

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/constants/permission-status.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class AppInitializer {
  String _rootPath;
  bool permissionGranted;
  AndroidBridge androidBridge = locator<AndroidBridge>();
  SharedPreferences sharedPreferences;
  String _wpStatusPath;
  bool _autoSaveStatus;
  bool _isWhatsAppInstalled;

  bool get isWhatsAppInstalled => _isWhatsAppInstalled;

  set autoSaveStatus(bool value) {
    _autoSaveStatus = value;
    sharedPreferences.setBool('autoSaveStatus', value);
  }

  bool get autoSaveStatus => _autoSaveStatus;

  String get wpStatusPath => _wpStatusPath;

  String get rootPath => _rootPath;

  Future initialize () async {
    sharedPreferences = await SharedPreferences.getInstance();
    _isWhatsAppInstalled = await androidBridge.checkWhatsappInstalled();
    _wpStatusPath = sharedPreferences.getString('wpStatusPath');
    _rootPath = sharedPreferences.getString('rootPath');
    if (_isWhatsAppInstalled) {
      if (_wpStatusPath == null || _rootPath == null) {
        var appDirectoryList = await getExternalStorageDirectories();
        String appPath = appDirectoryList[0].path;
        if (appPath.contains('Android')) {
          int index = appPath.indexOf('Android');
          _rootPath = appPath.substring(0,index);
          _wpStatusPath = _rootPath + 'WhatsApp/Media/.Statuses';
          sharedPreferences.setString('wpStatusPath', _wpStatusPath);
          sharedPreferences.setString('rootPath', _rootPath);
        }
      }
      var autoSaveStatus = sharedPreferences.getBool('autoSaveStatus');
      if (autoSaveStatus == null) {
        _autoSaveStatus = false;
        sharedPreferences.setBool('autoSaveStatus', false);
      } else {
        _autoSaveStatus = autoSaveStatus;
      }
    }
  }

  Future<AppPermissionStatus> checkPermission() async {
    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    bool hasNotificationAccess = await checkNotificationAccess();
    if (permissionStatus == PermissionStatus.granted && hasNotificationAccess) {
      return AppPermissionStatus.Granted;
    } else if(hasNotificationAccess && permissionStatus == PermissionStatus.denied) {
      return AppPermissionStatus.NoStorageAccess;
    } else if (!hasNotificationAccess && permissionStatus == PermissionStatus.granted)  {
      return AppPermissionStatus.NoNotificationAccess;
    } else {
      return AppPermissionStatus.NoPermission;
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

  Future<bool> checkNotificationAccess() async {
    bool hasNotificationAccess = await androidBridge.checkNotificationAccess();
    return hasNotificationAccess;
  }

  Future requestStoragePermission() async{
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  Future requestNotificationAccess() async{
    androidBridge.getNotificationAccess();
  }
}

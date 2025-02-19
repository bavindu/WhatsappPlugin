import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/permission-status.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/views/main_view.dart';
import 'package:whatsapp_plugin/views/onboardnotificationaccess.view.dart';
import 'package:whatsapp_plugin/views/onborad.view.dart';
import 'package:whatsapp_plugin/views/permission_error.view.dart';

class MainOnBoard extends StatefulWidget {
  @override
  _MainOnBoardState createState() => _MainOnBoardState();
}

class _MainOnBoardState extends State<MainOnBoard> {
  AppInitializer appInitializer = locator<AppInitializer>();
  Future<AppPermissionStatus> _appPermissionStatus;

  @override
  void initState() {
    _appPermissionStatus = appInitializer.checkPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _appPermissionStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == AppPermissionStatus.Granted) {
            return MainView();
          } else if (snapshot.data == AppPermissionStatus.NoStorageAccess){
            return OnboardView();
          } else if(snapshot.data == AppPermissionStatus.NoNotificationAccess) {
            return OnboradNotificationAccessView();
          }
          else {
            return OnboardView();
          }
        } else {
          return PermissionErrorView();
        }
      },
    );
  }
}

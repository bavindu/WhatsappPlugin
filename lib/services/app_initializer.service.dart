import 'package:permission_handler/permission_handler.dart';

class AppInitializerService {

  Future<bool> checkPermission() async {
    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}
import 'package:get_it/get_it.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/common_helper.service.dart';
import 'snackbar.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(SnackBarService());
  locator.registerSingleton(AndroidBridge());
  locator.registerSingleton(CommonHelperService());
  locator.registerSingleton(AppInitializer());
}
import 'package:get_it/get_it.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'app_initializer.service.dart';
import 'snackbar.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(AppInitializerService());
  locator.registerSingleton(SnackBarService());
  locator.registerSingleton(AndroidBridge());
}
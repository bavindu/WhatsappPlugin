import 'package:get_it/get_it.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/common_helper.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingletonAsync<AndroidBridge>(() async {
    final androidBridge = AndroidBridge();
    return androidBridge;
  });
  locator.registerSingleton(CommonHelperService());
  locator.registerSingletonAsync<AppInitializer>(() async {
    final appInitializer = AppInitializer();
    return appInitializer;
  },dependsOn: [AndroidBridge]);
}
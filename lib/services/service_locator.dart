import 'package:get_it/get_it.dart';
import 'app_initializer.service.dart';
import 'snackbar.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(AppInitializerService());
  locator.registerSingleton(SnackBarService());
}
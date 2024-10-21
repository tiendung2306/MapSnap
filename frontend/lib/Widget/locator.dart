import "package:get_it/get_it.dart";

import 'package:mapsnap_fe/Screen/camera.dart';

final locator = GetIt.instance;


void setupLocator() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
}
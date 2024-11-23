import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'APIService.dart';

Future<void> initializeService() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterBackgroundService().configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
  );
}


Future<bool> onIosBackground(ServiceInstance service) async {
  //Someshit i dont know yet
  return true;
}

void onStart (ServiceInstance service) async {
  // Kiểm tra quyền truy cập vị trí
  bool serviceEnabled;
  LocationPermission permission;

  // Kiểm tra xem dịch vụ vị trí có được bật không
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print("Location services are disabled. Please enable location services.");
    return; // Nếu dịch vụ vị trí bị tắt, không tiếp tục
  }

  // Kiểm tra quyền truy cập vị trí
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Nếu quyền bị từ chối, yêu cầu quyền
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Nếu quyền bị từ chối hoàn toàn
      print("Location permission denied. Please allow location access.");
      return;
    }
  }

  // Nếu quyền đã được cấp, bắt đầu lấy vị trí định kỳ
  Timer.periodic(Duration(seconds: 5), (timer) async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high, // Độ chính xác cao
      ),
    );
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Chuyển đổi thời gian hiện tại thành Epoch (số giây từ 1970-01-01)
    int epochTime = now.millisecondsSinceEpoch ~/ 1000;

    final  _apiService = ApiService();
    await _apiService.CreatePositon('6727e9974c3cc8291c2305db', position.latitude, position.longitude, epochTime, 'undefine');
  });
}


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'APIService.dart';
import 'dart:io';

Future<void> initializeService() async {
  await Future.delayed(Duration(seconds: 3)); // Thời gian hiển thị màn hình

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

Future<bool> locationRequest(BuildContext context) async {
  // Kiểm tra dịch vụ vị trí có bật không
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dịch vụ vị trí bị tắt"),
          content: Text(
              "Vui lòng bật dịch vụ vị trí trên thiết bị của bạn để tiếp tục sử dụng ứng dụng."),
          actions: [
            TextButton(
              onPressed: () {
                exit(0);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    return false;
  }

  // Kiểm tra quyền vị trí
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Yêu cầu cấp quyền
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Nếu quyền bị từ chối
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Quyền vị trí bị từ chối"),
            content: Text(
                "Vui lòng cấp quyền truy cập vị trí để tiếp tục sử dụng ứng dụng."),
            actions: [
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Trường hợp quyền bị từ chối vĩnh viễn
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quyền vị trí bị từ chối vĩnh viễn"),
          content: Text(
              "Quyền vị trí bị từ chối vĩnh viễn. Vui lòng vào cài đặt của thiết bị để cấp quyền."),
          actions: [
            TextButton(
              onPressed: () {
                exit(0);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    return false;
  }

  return true;
}


void onStart (ServiceInstance service) async {


  // Nếu quyền đã được cấp, bắt đầu lấy vị trí định kỳ
  Timer.periodic(Duration(seconds: 5), (timer) async {
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

    print('vpa');

    // Position position = await Geolocator.getCurrentPosition(
    //   locationSettings: LocationSettings(
    //     accuracy: LocationAccuracy.high, // Độ chính xác cao
    //   ),
    // );
    // // Lấy thời gian hiện tại
    // DateTime now = DateTime.now();
    //
    // // Chuyển đổi thời gian hiện tại thành Epoch (số giây từ 1970-01-01)
    // int epochTime = now.millisecondsSinceEpoch ~/ 1000;
    //
    // final  _apiService = ApiService();
    // await _apiService.CreatePositon('6727e9974c3cc8291c2305db', position.latitude, position.longitude, epochTime, 'undefine');
  });
}


import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../Model/Picture.dart';
import '../Model/Token_2.dart';
import '../Model/User_2.dart';
import '../main.dart';
import 'UpdateUser.dart';

// Class để quản lý các biến dùng chung
class AccountModel extends ChangeNotifier {

  // ================ Phần cho user =================================
  User? _user;
  late Token _token;
  bool isFetchedImage = false;

  String get avatar => _user?.avatar ?? ".....";
  String get phoneNumber => _user?.numberPhone ?? "??????";
  String get token_access => _token.token_access;
  String get token_refresh => _token.token_refresh;
  DateTime get token_refresh_expires => _token.token_access_expires;
  String get idUser => _user?.idUser ?? 'Chua co id';
  String get username => _user?.username ?? 'Chưa có tên người dùng';
  String get email => _user?.email ?? 'Chưa có email';
  String get address => _user?.address ?? 'Thêm địa chỉ';
  String get role => _user?.role ?? '.....';


  // Setter để cập nhật `User`
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners(); // Thông báo thay đổi
  }

  void setToken(Token newToken) {
    _token = newToken;
    notifyListeners(); // Thông báo thay đổi
  }


  //================== Quản lý ảnh theo ngày =====================


  Map<String, List<Picture>> _groupedImages = {};
  Map<String, List<Picture>> get groupedImages => _groupedImages;


  // Hàm lưu ảnh theo ngày
  void addImageDay(Picture image,String dayString) {
    if (groupedImages.containsKey(dayString)) {
      groupedImages[dayString]!.insert(0,image);
    } else {
      groupedImages[dayString] = [image];
    }
    notifyListeners();
  }

  // Hàm lưu ảnh theo ngày
  void removeImageDay(Picture image,int dayIndex,String dayString) {
    if (dayIndex < groupedImages.length) {
      groupedImages[dayString]!.remove(image);
      // Nếu ngày đó không còn ảnh nào, xóa cả ngày (tuỳ chọn)
      if (groupedImages[dayString]!.isEmpty) {
        groupedImages.remove(dayString);
      }
      notifyListeners(); // Cập nhật giao diện
    }
  }

  void setFetchedImage(bool value) {
    isFetchedImage = value;
    notifyListeners();
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../Model/Token_2.dart';
import '../Model/User_2.dart';
import '../main.dart';
import 'UpdateUser.dart';

// Class để quản lý các biến dùng chung
class AccountModel extends ChangeNotifier {

  // ================ Phần cho user =================================
  User? _user;
  late Token _token;

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

  //====================== Phần cho image ===================================


  List<List<String>> _imageManager= [
    ["assets/Image/1.jpg",
    "assets/Image/2.jpg",
    "assets/Image/3.jpg",
    "assets/Image/4.jpg",
    "assets/Image/5.jpg",
    "assets/Image/6.jpg",],
  ];


  List<List<String>> get imageManager => _imageManager;


  // Hàm xóa một ảnh từ danh sách của một ngày cụ thể
  void removeImageDay(String imagePath, int dayIndex) {
    if (dayIndex < imageManager.length) {
      imageManager[dayIndex].remove(imagePath);
      // Nếu ngày đó không còn ảnh nào, xóa cả ngày (tuỳ chọn)
      if (imageManager[dayIndex].isEmpty) {
        imageManager.removeAt(dayIndex);
      }
      notifyListeners(); // Cập nhật giao diện
    }
  }

  // Hàm thêm ngày mới
  void addImageManager(List<String> images) {
    imageManager.add(images);
    notifyListeners();
  }

  // Hàm thêm ảnh vào ngày hiện tại (ngày cuối cùng)
  void addImageDay(String imagePath) {
    if (imageManager.isNotEmpty) {
      imageManager.last.add(imagePath);
      notifyListeners();
    }
  }

}

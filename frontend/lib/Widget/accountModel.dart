import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Class để quản lý các biến dùng chung
class AccountModel extends ChangeNotifier {

  User? _user;
  late Token _token;

  String get token_access => _token.token_access;
  String get idUser => _user?.idUser ?? 'Chua co id';
  String get username => _user?.username ?? 'Chưa có tên người dùng';
  String get email => _user?.email ?? 'Chưa có email';
  String get password => _user?.password ?? 'Chưa có mật khẩu';
  String get address => _user?.address ?? 'Thêm địa chỉ';
  String get role => _user?.role ?? '.....';

  XFile? _image;

  XFile? get image => _image;


  void updateImage(XFile newImage) {
    _image = newImage;
    notifyListeners(); // Thông báo cho tất cả các widget đang nghe
  }

  // Setter để cập nhật `User`
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners(); // Thông báo thay đổi
  }

  void setToken(Token newToken) {
    _token = newToken;
    notifyListeners(); // Thông báo thay đổi
  }
}

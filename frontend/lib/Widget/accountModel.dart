import 'package:flutter/material.dart';

// Class để quản lý các biến dùng chung
class AccountModel extends ChangeNotifier {
  String _username = 'Top1thachdau';
  String _email = 'top1@gmail.com';
  String _password = 'top1buffban';

  String get username => _username;
  String get email => _email;
  String get password => _password;

  void updateUsername(String newUsername) {
    _username = newUsername;
    notifyListeners(); // Thông báo cho tất cả các widget đang nghe
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
  void updatePassword(String newPassword) {
    _password = newPassword;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class AccountModel extends ChangeNotifier {
  String _username = 'Top1thachdau';
  String _email = 'top1@gmail.com';

  String get username => _username;
  String get email => _email;

  void updateUsername(String newUsername) {
    _username = newUsername;
    notifyListeners(); // Thông báo cho tất cả các widget đang nghe
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
}

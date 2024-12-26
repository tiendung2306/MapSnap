import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mapsnap_fe/Model/Posts.dart';

Future<void> LogOut(String refreshToken) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/auth/logout');
  final Map<String, dynamic> loadData = {
    "refreshToken": refreshToken,
  };

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(loadData),
  );

  if (response.statusCode == 204) {
      print("Đăng xuất thành công");
  } else {
    // Xử lý lỗi từ API
    print(response.statusCode);
  }
}
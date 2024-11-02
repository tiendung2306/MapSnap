import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String idUser;
  String username;
  String email;
  String role;
  String address;

  User({required this.username, required this.email,required this.role,required this.address,required this.idUser});

  factory User.fromJson(Map<String, dynamic> json) {
    print('JSON received: $json\n');
    return User(
      username: json['user']['username'] ?? 'NoUsername',
      email: json['user']['email'] ?? 'NoEmail',
      role: json['user']['role'] ?? 'NoRole',
      address: json['user']['address'] ?? 'NoAddress',
      idUser: json['user']['id'] ?? 'NoID',
    );
  }
}

Future<User?> fetchData(String userId,String token) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/users/$userId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token', // Thêm token vào header
    },
  );

  if (response.statusCode == 200) {
    try {
      var data = jsonDecode(response.body) as Map;
      return User(
        username: data['username'] ?? 'NoUsername',
        email: data['email'] ?? 'NoEmail',
        role: data['role'] ?? 'NoRole',
        address: data['address'] ?? 'NoAddress',
        idUser: data['id'] ?? 'NoID',
      );
    } catch (e) {
      print('Dữ liệu nhận về không phải là JSON: $e');
    }
  } else {
    print('Lỗi: ${response.statusCode}, nội dung: ${response.body}');
  }
}

Future<void> updateUser(String userId, String newName, String newEmail,String newAddress,String token) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/users/$userId');

  // Dữ liệu cần cập nhật
  final Map<String, dynamic> updatedData = {
    'username': newName,
    'email': newEmail,
    'address': newAddress,
  };

  // Gửi yêu cầu PATCH
  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Thêm token nếu cần
    },
    body: jsonEncode(updatedData),
  );
  // Kiểm tra trạng thái phản hồi
  if (response.statusCode == 200) {
    print('Cập nhật thành công: ${response.body}');
  } else {
    print('Cập nhật thất bại: ${response.statusCode}');
  }
}

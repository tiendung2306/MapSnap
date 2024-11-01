import 'package:http/http.dart' as http;
import 'dart:convert';

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

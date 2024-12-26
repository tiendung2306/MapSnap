import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnap_fe/Model/Token_2.dart';
import 'dart:typed_data'; // Để xử lý dữ liệu nhị phân
import 'dart:io'; // Để sử dụng File
import 'package:mime/mime.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../Model/User_2.dart';
import 'accountModel.dart';



// Gọi API để lấy thông tin User
Future<User?> fetchData(String userId, String token) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/users/$userId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token', // Thêm token vào header
    },
  );
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return User.fromJson(data);
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return null;
}



// Gọi API để update thông tin của User lên database
Future<void> updateUser(String userId, String newName, String newEmail,String newAddress,String newPhoneNumber,String newAvatar,String token) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/users/$userId');
  // Dữ liệu cần cập nhật
  final Map<String, dynamic> updatedData = {
    'username': newName,
    'email': newEmail,
    'address': newAddress,
    'phoneNumber': newPhoneNumber,
    'avatar': newAvatar,
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
    print('Cập nhật thành công:');
  } else {
    print('Cập nhật thất bại:');
  }
}


//=============================================================================
// Lớp để đại diện cho phản hồi từ API
class Avatar {
  String message;
  String userAvatar;

  Avatar({required this.message, required this.userAvatar});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      message: json['message'] ?? 'NoMessage',
      userAvatar: json['avatar'] ?? 'heheheheheh',
    );
  }
}

// Gọi API để gửi ảnh lên server
Future<Avatar?> uploadAvatar(String token, String userId, XFile image) async {
  if (image == null) {
    print('Không có ảnh nào được chọn!');
    return null;
  }

  final File imgFile = File(image.path);

  // Địa chỉ API
  final String url = 'http://10.0.2.2:3000/v1/users/avatar/$userId';

  // Tạo yêu cầu `MultipartRequest`
  final request = http.MultipartRequest('POST', Uri.parse(url))
    ..headers['Authorization'] = 'Bearer $token';

  // Xác định loại MIME của file và thêm vào yêu cầu
  final mimeTypeData = lookupMimeType(imgFile.path)!.split('/');
  final multipartFile = await http.MultipartFile.fromPath(
    'avatar', // Tên trường trong yêu cầu API
    imgFile.path,
    contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
  );

  // Thêm file ảnh vào yêu cầu `multipart`
  request.files.add(multipartFile);

  // Gửi yêu cầu
  final response = await request.send();

  // Xử lý phản hồi
  if (response.statusCode == 200) {
    final responseData = await response.stream.bytesToString();
    final data = jsonDecode(responseData);
    print('Ảnh đại diện đã được tải lên thành công!');
    print(data);
    return Avatar.fromJson(data);
  } else {
    print('Lỗi: ${response.statusCode}');
  }
}


import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/LocationCategory.dart';



Future<LocationCategory?> upLoadLocationCategory(CreateLocationCategory createLocationCategory, String userId) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/locationCategory/$userId/create-category');
  final Map<String, dynamic> loadData = {
    'name': createLocationCategory.name,
    'title': createLocationCategory.title,
    'createdAt': createLocationCategory.createdAt,
    'status': createLocationCategory.status,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Định dạng JSON
      },
      body: jsonEncode(loadData), // Chuyển đổi loadData sang chuỗi JSON
    );

    if (response.statusCode == 201) {
      // Xử lý thành công
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);
      return LocationCategory.fromJson(data['result']);
    } else {
      // Xử lý lỗi từ API
      print(response.statusCode);
    }
  } catch (e) {
    // Xử lý lỗi khác
    print('Error: $e');
  }
  return null;
}


// Hàm gọi API lấy thông tin LocationCategory
Future<List<LocationCategory>> getInfoLocationCategory(String userId) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/locationCategory/$userId/get-category');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    List<dynamic> data = json['result'];
    print(data);
    List<LocationCategory> locationCategory = data.map((json) => LocationCategory.fromJson(json)).toList();
    return locationCategory;
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return [];
}


// Hàm gọi API lấy thông tin LocationCategory theo id
Future<LocationCategory?> getLocationCategoryId(String Id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/locationCategory/$Id');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body)  as Map<String, dynamic>;
    print(data);
    return LocationCategory.fromJson(data);
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return null;
}



// Gọi API để update thông tin của LocationCategory
Future<void> updateLocationCategory(CreateLocationCategory createLocationCategory,String id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/locationCategory/$id');
  // Dữ liệu cần cập nhật
  final Map<String, dynamic> updatedData = {
    'name': createLocationCategory.name,
    'title': createLocationCategory.title,
    'createdAt': createLocationCategory.createdAt,
    'status': createLocationCategory.status,
  };
  // Gửi yêu cầu PATCH
  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
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



// Gọi API để xóa thành phố
Future<void> RemoveLocationCategory(String id ) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/locationCategory/$id');
  final response = await http.delete(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    print("Xóa thành công");
  } else {
    print('Lỗi: ${response.statusCode}');
  }
}
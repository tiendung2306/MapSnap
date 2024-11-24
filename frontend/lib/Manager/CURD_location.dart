import 'package:http/http.dart' as http;
import 'package:mapsnap_fe/Model/City.dart';
import 'dart:convert';

import 'package:mapsnap_fe/Model/Location.dart';



// API để gọi tải ảnh lên Database
Future<Location?> upLoadLocation(CreateLocation createLocation, String userId) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/location/$userId/create-location');
  final Map<String, dynamic> loadData = {
    'name': createLocation.name,
    'cityId': createLocation.cityId,
    'categoryId': createLocation.categoryId,
    'role': createLocation.role,
    'title': createLocation.title,
    'visitedTime': createLocation.visitedTime,
    'longitude': createLocation.longitude,
    'latitude': createLocation.latitude,
    'createdAt': createLocation.createdAt,
    'status': createLocation.status,
    'updatedByUser': createLocation.updatedByUser,
    'isAutomaticAdded': createLocation.isAutomaticAdded,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Định dạng JSON
      },
      body: jsonEncode(loadData), // Chuyển đổi payload sang chuỗi JSON
    );

    if (response.statusCode == 201) {
      // Xử lý thành công
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);
      return Location.fromJson(data);
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


// Hàm gọi API lấy hết thông tin location
Future<List<Location>> getInfoLocation(String userId) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/location/$userId/get-location');
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
    List<Location> locations = data.map((json) => Location.fromJson(json)).toList();
    return locations;
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return [];
}


// Hàm gọi API lấy thông tin location theo id
Future<Location?> getLocationId(String Id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/location/$Id');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body)  as Map<String, dynamic>;
    print(data);
    return Location.fromJson(data);
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return null;
}



// Gọi API để update thông tin của City
Future<void> updateLocation(CreateLocation createLocation,String id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/city/$id');
  // Dữ liệu cần cập nhật
  final Map<String, dynamic> updatedData = {
    'name': createLocation.name,
    'cityId': createLocation.cityId,
    'categoryId': createLocation.categoryId,
    'role': createLocation.role,
    'title': createLocation.title,
    'visitedTime': createLocation.visitedTime,
    'longitude': createLocation.longitude,
    'latitude': createLocation.latitude,
    'createdAt': createLocation.createdAt,
    'status': createLocation.status,
    'updatedByUser': createLocation.updatedByUser,
    'isAutomaticAdded': createLocation.isAutomaticAdded,
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
Future<void> RemoveLocation(String id ) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/location/$id');

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
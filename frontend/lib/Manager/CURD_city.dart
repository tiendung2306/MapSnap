import 'package:http/http.dart' as http;
import 'package:mapsnap_fe/Model/City.dart';
import 'dart:convert';



// API để gọi tải thành phố lên Database
Future<City?> upLoadCity(CreateCity createCity, String userId) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/city/$userId/create-city');
  final Map<String, dynamic> loadData = {
    'name': createCity.name,
    'visitedTime': createCity.visitedTime,
    'createdAt': createCity.createdAt,
    'status': createCity.status,
    'updatedByUser': createCity.updatedByUser,
    'isAutomaticAdded': createCity.isAutomaticAdded,
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
      return City.fromJson(data['result']);
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


// Hàm gọi API lấy thông tin thành phố
Future<List<City>> getInfoCity(String userId,String check, String nameCity) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/city/$userId/get-cities');
  Map<String, dynamic> loadData = {};
  if(check == "searchText") {
    loadData = {
      'searchText': nameCity,
    };
  }
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(loadData),
  );
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    List<dynamic> data = json['result'];
    List<City> cities = data.map((json) => City.fromJson(json)).toList();
    return cities;
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return [];
}

// Hàm gọi API lấy thông tin thành phố theo id
Future<City?> getCityId(String Id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/city/$Id');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return City.fromJson(data);
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return null;
}



// Gọi API để update thông tin của City
Future<void> updateCity(CreateCity createCity,String id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/city/$id');
  // Dữ liệu cần cập nhật
  final Map<String, dynamic> updatedData = {
    'name': createCity.name,
    'visitedTime': createCity.visitedTime,
    'createdAt': createCity.createdAt,
    'status': createCity.status,
    'updatedByUser': createCity.updatedByUser,
    'isAutomaticAdded': createCity.isAutomaticAdded,
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
Future<void> RemoveCity(String id ) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/city/$id');

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
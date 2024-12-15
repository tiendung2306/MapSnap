import 'package:http/http.dart' as http;
import 'package:mapsnap_fe/Model/City.dart';
import 'dart:convert';

import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/forwardGeocoding.dart';


Future<Location?> upLoadLocation(CreateLocation createLocation, String userId) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/location/$userId/create-location');
  final Map<String, dynamic> loadData = {
    'cityId': createLocation.cityId,
    'categoryId': createLocation.categoryId,
    'title': createLocation.title,
    'visitedTime': createLocation.visitedTime,
    'longitude': createLocation.longitude,
    'latitude': createLocation.latitude,
    'createdAt': createLocation.createdAt,
    'status': createLocation.status,
    'updatedByUser': createLocation.updatedByUser,
    'isAutomaticAdded': createLocation.isAutomaticAdded,
    'address': createLocation.address,
    'country': createLocation.country,
    'district': createLocation.district,
    'homeNumber': createLocation.homeNumber,
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



Future<List<Location>> getInfoLocation(String userId, String body, String check) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/location/$userId/get-location');
  late Map<String, dynamic> updatedData;
  if(check == 'city') {
    updatedData = {
      'cityId': body,
    };
  }

  if(check == 'category') {
    updatedData = {
      'categoryId': body,
    };
  }

  if(check == 'sortField') {
    updatedData = {
      "sortField": body,
    };
  }
  if(check == "searchText") {
    updatedData = {
      "searchText": body,
    };
  }
  if(check == '') {
    updatedData = {};
  }

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(updatedData),
  );
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    List<dynamic> data = json['result'];
    List<Location> locations = data.map((json) => Location.fromJson(json)).toList();
    return locations;
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return [];
}



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
    return Location.fromJson(data['result']);
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return null;
}


Future<void> updateLocation(CreateLocation createLocation,String id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/city/$id');
  // Dữ liệu cần cập nhật
  final Map<String, dynamic> updatedData = {
    'cityId': createLocation.cityId,
    'categoryId': createLocation.categoryId,
    'title': createLocation.title,
    'visitedTime': createLocation.visitedTime,
    'longitude': createLocation.longitude,
    'latitude': createLocation.latitude,
    // 'createdAt': createLocation.createdAt,
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


Future<InfoVisit?> AutoLocation(double lat, double lng) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/location/reverse-geocoding?lat=$lat&lng=$lng');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json', // Định dạng JSON
      },
    );

    if (response.statusCode == 200) {
      // Xử lý thành công
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);
      return InfoVisit.fromJson(data);
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



Future<ForwardGeocoding?> GetLatIngbyAddress(String address) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/goong/forward-geocoding?address=$address');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json', // Định dạng JSON
      },
    );

    if (response.statusCode == 200) {
      // Xử lý thành công
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // print(data);
      return ForwardGeocoding.fromJson(data);
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
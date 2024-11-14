import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:mapsnap_fe/Model/Picture.dart';

import 'package:mime/mime.dart';


// API để gọi tải ảnh lên Database
Future<List<Picture>?> upLoadImage(CreatePicture createPicture) async {
  if (createPicture.link == null) {
    print('Không có ảnh nào được chọn!');
    return null;
  }
  final File imgFile = File(createPicture.link);

  // Địa chỉ API
  final String url = 'http://10.0.2.2:3000/v1/pictures';

  // Tạo yêu cầu `MultipartRequest`
  final request = http.MultipartRequest('POST', Uri.parse(url));

  // Xác định loại MIME của file và thêm vào yêu cầu
  final mimeTypeData = lookupMimeType(imgFile.path)!.split('/');
  final multipartFile = await http.MultipartFile.fromPath(
    'picture',
    imgFile.path,
    contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
  );

  // Thêm file ảnh vào yêu cầu `multipart`
  request.files.add(multipartFile);
  request.fields['user_id'] = createPicture.user_id;
  request.fields['location_id'] = createPicture.location_id;
  request.fields['visit_id'] = createPicture.visit_id;
  request.fields['journey_id'] = createPicture.journey_id;
  request.fields['createdAt'] = createPicture.createdAt.millisecondsSinceEpoch.toString();

  // Gửi yêu cầu
  final response = await request.send();

  // Xử lý phản hồi
  if (response.statusCode == 200) {
    final responseData = await response.stream.bytesToString();
    List<dynamic> data = jsonDecode(responseData);
    List<Picture> pictures = data.map((json) => Picture.fromJson(json)).toList();
    return pictures;
  } else {
    print('Lỗi: ${response.statusCode} ');
  }
}



// Gọi API để lấy thông tin tất cả ảnh theo .....
Future<List<Picture>> getInfoImages(String parameters, String check) async {
  Uri? url;

  // Xác định URL dựa trên giá trị của `check`
  switch (check) {
    case 'user_id':
      url = Uri.parse('http://10.0.2.2:3000/v1/pictures?user_id=$parameters');
      break;
    case 'created_at':
      url = Uri.parse('http://10.0.2.2:3000/v1/pictures?created_at=$parameters');
      break;
    case 'journey_id':
      url = Uri.parse('http://10.0.2.2:3000/v1/pictures?journey_id=$parameters');
      break;
    case 'visit_id':
      url = Uri.parse('http://10.0.2.2:3000/v1/pictures?visit_id=$parameters');
      break;
    default:
      print('Tham số không hợp lệ');
      return [];
  }

  try {
    if (url != null) {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Giải mã JSON và ánh xạ vào danh sách Picture
        List<dynamic> data = jsonDecode(response.body);
        List<Picture> pictures = data.map((json) => Picture.fromJson(json)).toList();
        return pictures;
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Lỗi khi gọi API: $e');
  }
  return [];
}



// Gọi API để lấy thông tin ảnh theo ID
Future<Picture?> getImage_ID(String id ) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/pictures/$id');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print(data);
    return Picture.fromJson(data);
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return null;
}



// Gọi API để xóa ảnh
Future<void> RemoveImage(String id ) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/pictures/$id');

  final response = await http.delete(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 204) {
    print("Xóa thành công");
  } else {
    print('Lỗi: ${response.statusCode}');
  }
}
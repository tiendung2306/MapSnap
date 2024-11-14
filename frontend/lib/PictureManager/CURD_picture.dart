import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:mapsnap_fe/Model/Picture.dart';

import 'package:mime/mime.dart';


// API để gọi tải ảnh lên Database
Future<void> upLoadImage(CreatePicture createPicture) async {
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
  request.fields['createdAt'] = createPicture.created_at.to();

  // Gửi yêu cầu
  final response = await request.send();

  // Xử lý phản hồi
  if (response.statusCode == 200) {
    final responseData = await response.stream.bytesToString();
    final data = jsonDecode(responseData);
    print('Ảnh đã được tải lên thành công!');
    print(data);
  } else {
    print('Lỗi: ${response.statusCode} ');
  }
}



// Gọi API để lấy thông tin tất cả ảnh theo .....
Future<Picture?> getInfoImage(String Parameters,String check) async {
  Uri? url;
  if(check == 'user_id') {
    url = Uri.parse('http://10.0.2.2:3000/v1/pictures?user_id=$Parameters');
  }

  if(check == 'created_at') {
    url = Uri.parse('http://10.0.2.2:3000/v1/pictures?created_at=$Parameters');
  }

  if(check == 'journey_id') {
    url = Uri.parse('http://10.0.2.2:3000/v1/pictures?journey_id=$Parameters');
  }

  if(check == 'visit_id') {
    url = Uri.parse('http://10.0.2.2:3000/v1/pictures?visit_id=$Parameters');
  }

  try {
    // Kiểm tra nếu `url` hợp lệ trước khi gửi request
    if (url != null) {
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
    }
  } catch (e) {
    print('Lỗi khi gọi API: $e');
  }
  return null;
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
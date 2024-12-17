import 'package:http/http.dart' as http;
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/PagePost.dart';
import 'dart:convert';

import 'package:mapsnap_fe/Model/Posts.dart';



Future<Posts?> upLoadPost(CreatePost createPost) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/posts');
  final Map<String, dynamic> loadData = {
    'userId': createPost.userId,
    'content': createPost.content,
    'media': createPost.media,
    'createdAt': createPost.createdAt,
    'updatedAt': createPost.updatedAt,
    'commentsCount': createPost.commentsCount,
    'likesCount': createPost.likesCount,
    "journeyId": createPost.journeyId,
    'address': createPost.address,
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
      return Posts.fromJson(data);
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


Future<List<Posts>> getInfoPosts(String parameters, String check) async {
  Uri? url;
  // Xác định URL dựa trên giá trị của check
  switch (check) {
    case 'userId':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?userId=$parameters&sortBy=-createdAt');
      break;
    case 'likesCount':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?likesCount=$parameters&sortBy=-createdAt');
      break;
    case 'commentsCount':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?commentsCount=$parameters&sortBy=-createdAt');
      break;
    case 'limit':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?limit=$parameters&sortBy=-createdAt');
      break;
    case 'page':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?page=$parameters&sortBy=-createdAt');
      break;
    case 'sortBy':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?sortBy=$parameters');
      break;
    case '':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts&sortBy=-createdAt');
      break;
    default:
      print('Tham số không hợp lệ');
      return [];
  }

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> data = json['results'];
      List<Posts> posts = data.map((json) => Posts.fromJson(json)).toList();
      return posts;
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  } catch (e) {
    print('Lỗi khi gọi API: $e');
  }
  return [];
}


Future<PagePost?> getInfoPosts2(String parameters, String check) async {
  Uri? url;
  // Xác định URL dựa trên giá trị của check
  switch (check) {
    case 'userId':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?userId=$parameters&sortBy=-createdAt');
      break;
    case 'likesCount':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?likesCount=$parameters&sortBy=-createdAt');
      break;
    case 'commentsCount':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?commentsCount=$parameters&sortBy=-createdAt');
      break;
    case 'limit':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?limit=$parameters&sortBy=-createdAt');
      break;
    case 'page':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?page=$parameters&sortBy=-createdAt');
      break;
    case 'sortBy':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts?sortBy=$parameters');
      break;
    case '':
      url = Uri.parse('http://10.0.2.2:3000/v1/posts');
      break;
    default:
      print('Tham số không hợp lệ');
      return null;
  }

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return PagePost.fromJson(data);
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  } catch (e) {
    print('Lỗi khi gọi API: $e');
  }
  return null;
}



Future<Posts?> getPostId(String Id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/posts/$Id');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    print(data);
    return Posts.fromJson(data);
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return null;
}



Future<void> updatePost(CreatePost createPost,String id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/posts/$id');
  // Dữ liệu cần cập nhật
  final Map<String, dynamic> updatedData = {
    'userId': createPost.userId,
    'content': createPost.content,
    'media': createPost.media,
    'createdAt': createPost.createdAt,
    'updatedAt': createPost.updatedAt,
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



Future<void> RemovePost(String id ) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/posts/$id');

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





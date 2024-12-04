import 'package:http/http.dart' as http;
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Like.dart';
import 'dart:convert';

import 'package:mapsnap_fe/Model/Posts.dart';


Future<Like?> AddLike(addLike addLike) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/likes');
  final Map<String, dynamic> loadData = {
    'postId': addLike.postId,
    'userId': addLike.postId,
    'createdAt': addLike.createdAt,

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
      return Like.fromJson(data);
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


Future<List<Like>> getLikePost(String postId) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/likes/$postId');

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> data = json['likes'];
      print(data);
      List<Like> likes = data.map((json) => Like.fromJson(json)).toList();
      return likes;
    } else {
      print('Lỗi: ${response.statusCode}');
    }
  } catch (e) {
    print('Lỗi khi gọi API: $e');
  }
  return [];
}




Future<void> RemoveLike(String id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/like/$id');

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
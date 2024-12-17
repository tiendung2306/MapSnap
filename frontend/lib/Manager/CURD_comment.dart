import 'package:http/http.dart' as http;
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Comment.dart';
import 'package:mapsnap_fe/Model/Like.dart';
import 'dart:convert';

import 'package:mapsnap_fe/Model/Posts.dart';


Future<Comment?> AddComment(addComment addComment) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/posts/comments');
  final Map<String, dynamic> loadData = {
    'postId': addComment.postId,
    'userId': addComment.userId,
    'createdAt': addComment.createdAt,
    'content': addComment.content,
    'updatedAt': addComment.updatedAt,
  };

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
    return Comment.fromJson(data);
  } else {
    // Xử lý lỗi từ API
    print(response.statusCode);
  }
  return null;
}


Future<Comment?> updateComment(addComment addComment, String id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/posts/comments/$id');
  // Dữ liệu cần cập nhật
  final Map<String, dynamic> updatedData = {
    'postId': addComment.postId,
    'userId': addComment.userId,
    'content': addComment.content,
    'updatedAt': addComment.updatedAt,
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
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Comment.fromJson(data);
  } else {
    print('Cập nhật thất bại:');
  }
  return null;
}



Future<List<Comment>> getCommentPost(String postId) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/posts/comments/post/$postId');

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        List<Comment> comments =
        data.map((json) => Comment.fromJson(json)).toList();
        return comments;
      } else {
        print("Dữ liệu không hợp lệ: $data");
        return [];
      }
    } else {
      throw Exception('Failed to load comments. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Lỗi khi gọi API: $error');
    return [];
  }
}



Future<void> RemoveComments(String id) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/posts/comments/$id');

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
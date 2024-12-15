import 'package:mapsnap_fe/Model/Posts.dart';

class PagePost {
  List<Posts> results;
  int page;
  int limit;
  int totalPages;
  int totalResults;

  PagePost({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory PagePost.fromJson(Map<String, dynamic> json) {
    // Ánh xạ danh sách 'results' từ JSON sang danh sách Posts
    List<Posts> resultsList = (json['results'] as List)
        .map((item) => Posts.fromJson(item as Map<String, dynamic>))
        .toList();

    return PagePost(
      results: resultsList,
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalResults: json['totalResults'],
    );
  }
}

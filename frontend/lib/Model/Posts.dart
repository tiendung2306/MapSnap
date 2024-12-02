class Posts {
  String userId;
  String content;
  List<Map<String,String>> media;
  int createdAt;
  int updatedAt;
  int commentsCount;
  int likesCount;
  String id;

  Posts({
    required this.userId,
    required this.content,
    required this.media ,
    required this.createdAt,
    required this.updatedAt,
    required this.commentsCount,
    required this.likesCount,
    required this.id,
  });

  factory Posts.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> mediaList = (json['media'] as List)
        .map((item) => Map<String, String>.from(item))
        .toList();
    return Posts(
      userId: json['userId'],
      content: json['content'],
      media: mediaList,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      commentsCount: json['commentsCount'],
      likesCount: json['likesCount'],
      id: json['_id'],
    );
  }
}


class CreatePost {
  String userId;
  String content;
  List<Map<String,String>> media;
  int createdAt;
  int updatedAt;
  int commentsCount;
  int likesCount;

  CreatePost({
    required this.userId,
    required this.content,
    required this.media ,
    required this.createdAt,
    required this.updatedAt,
    required this.commentsCount,
    required this.likesCount,
  });
}
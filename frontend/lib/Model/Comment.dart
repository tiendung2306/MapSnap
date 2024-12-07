class Comment {
  String postId;
  String userId;
  String content;
  int createdAt;
  int updatedAt;
  String id;


  Comment({
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.id,

  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['postId'],
      userId: json['userId'],
      id: json['_id'],
      createdAt: json['createdAt'],
      content: json['content'],
      updatedAt: json['updatedAt'],

    );
  }
}


class addComment {
  String postId;
  String userId;
  String content;
  int createdAt;
  int updatedAt;

  addComment({
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,

  });
}
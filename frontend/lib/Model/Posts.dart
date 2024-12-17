class Posts {
  String userId;
  String content;
  List<Map<String,String>> media;
  int createdAt;
  int updatedAt;
  int commentsCount;
  int likesCount;
  String id;
  String journeyId;
  String address;

  Posts({
    required this.userId,
    required this.content,
    required this.media ,
    required this.createdAt,
    required this.updatedAt,
    required this.commentsCount,
    required this.likesCount,
    required this.id,
    required this.journeyId,
    required this.address,
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
      journeyId: json['journeyId'],
      address: json['address'],
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
  String journeyId;
  String address;

  CreatePost({
    required this.userId,
    required this.content,
    required this.media ,
    required this.createdAt,
    required this.updatedAt,
    required this.commentsCount,
    required this.likesCount,
    required this.journeyId,
    required this.address,
  });
}
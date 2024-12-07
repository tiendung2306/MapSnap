class Like {
  String postId;
  String userId;
  String id;
  int createdAt;


  Like({
    required this.postId,
    required this.userId,
    required this.id ,
    required this.createdAt,

  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      postId: json['postId'],
      userId: json['userId'],
      id: json['_id'],
      createdAt: json['createdAt'],

    );
  }
}


class addLike {
  String postId;
  String userId;
  int createdAt;

  addLike({
    required this.postId,
    required this.userId,
    required this.createdAt,
  });
}
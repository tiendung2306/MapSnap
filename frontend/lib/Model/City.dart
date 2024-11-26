class City {
  String name;
  int visitedTime;
  // int createdAt;
  String status;
  bool updatedByUser;
  bool isAutomaticAdded;
  String userId;
  String id;

  City({
    required this.name,
    required this.visitedTime,
    // required this.createdAt,
    required this.status,
    required this.updatedByUser,
    required this.isAutomaticAdded,
    required this.userId,
    required this.id,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        name: json['name'],
        visitedTime: json['visitedTime'],
        // createdAt: json['createdAt'],
        status: json['status'],
        updatedByUser: json['updatedByUser'],
        isAutomaticAdded: json['isAutomaticAdded'],
        userId: json['userId'],
        id: json['id']
    );
  }
}

class CreateCity {
  String name;
  int visitedTime;
  int createdAt;
  String status;
  bool updatedByUser;
  bool isAutomaticAdded;

  CreateCity({
    required this.name,
    required this.visitedTime,
    required this.createdAt,
    required this.status,
    required this.updatedByUser,
    required this.isAutomaticAdded,
  });

  factory CreateCity.fromJson(Map<String, dynamic> json) {
    return CreateCity(
      name: json['name'],
      visitedTime: json['visitedTime'],
      createdAt: json['createdAt'],
      status: json['status'],
      updatedByUser: json['updatedByUser'],
      isAutomaticAdded: json['isAutomaticAdded'],
    );
  }
}
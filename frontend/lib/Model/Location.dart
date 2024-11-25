class Location {
  String name;
  String cityId;
  String categoryId;
  String title;
  int visitedTime;
  int longitude;
  int latitude;
  // int createdAt;
  String status;
  bool updatedByUser;
  bool isAutomaticAdded;
  List<dynamic> pictures;
  String userId;
  String id;

  Location({
    required this.name,
    required this.cityId,
    required this.categoryId,
    required this.title ,
    required this.visitedTime,
    required this.longitude,
    required this.latitude,
    // required this.createdAt,
    required this.status,
    required this.updatedByUser,
    required this.isAutomaticAdded,
    required this.pictures,
    required this.userId,
    required this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      cityId: json['cityId'],
      categoryId: json['categoryId'],
      title: json['title'],
      visitedTime: json['visitedTime'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      // createdAt: json['createdAt'],
      status: json['status'],
      updatedByUser: json['updatedByUser'],
      isAutomaticAdded: json['isAutomaticAdded'],
      pictures: json['pictures'],
      userId: json['userId'],
      id: json['id'],
    );
  }
}


class CreateLocation {
  String name;
  String cityId;
  String categoryId;
  String title;
  int visitedTime;
  int longitude;
  int latitude;
  int createdAt;
  String status;
  bool updatedByUser;
  bool isAutomaticAdded;

  CreateLocation({
    required this.name,
    required this.cityId,
    required this.categoryId,
    required this.title ,
    required this.visitedTime,
    required this.longitude,
    required this.latitude,
    required this.createdAt,
    required this.status,
    required this.updatedByUser,
    required this.isAutomaticAdded,

  });

  factory CreateLocation.fromJson(Map<String, dynamic> json) {
    return CreateLocation(
      name: json['name'],
      cityId: json['cityId'],
      categoryId: json['categoryId'],
      title: json['title'],
      visitedTime: json['visitedTime'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      createdAt: json['createdAt'],
      status: json['status'],
      updatedByUser: json['updatedByUser'],
      isAutomaticAdded: json['isAutomaticAdded'],
    );
  }
}
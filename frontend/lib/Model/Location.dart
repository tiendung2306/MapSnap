class Location {
  String cityId;
  String categoryId;
  String title;
  int visitedTime;
  double longitude;
  double latitude;
  // int createdAt;
  String status;
  bool updatedByUser;
  bool isAutomaticAdded;
  List<dynamic> pictures;
  String userId;
  String id;
  String address;
  String country;
  String district;

  Location({
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
    required this.address,
    required this.country,
    required this.district,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
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
      address: json['address'],
      country: json['country'],
      district: json['district'],
    );
  }
}


class CreateLocation {
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
  String address;
  String country;
  String district;


  CreateLocation({
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
    required this.address,
    required this.country,
    required this.district,

  });

  factory CreateLocation.fromJson(Map<String, dynamic> json) {
    return CreateLocation(
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
      address: json['address'],
      country: json['country'],
      district: json['district'],
    );
  }
}
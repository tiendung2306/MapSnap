class LocationCategory{
  String name;
  String title;
  int createAt;
  String status;
  String userId;
  String id;
  LocationCategory({
    required this.name,
    required this.title,
    required this.createAt,
    required this.status,
    required this.userId,
    required this.id,
  });

  factory LocationCategory.fromJson(Map<String,dynamic> json) {
    return LocationCategory(
      name: json['name'],
      title: json['title'],
      createAt: json['createdAt'],
      status: json['status'],
      userId: json['userId'],
      id: json['id'],
    );
  }
}


class CreateLocationCategory{
  String name;
  String title;
  int createdAt;
  String status;

  CreateLocationCategory({
    required this.name,
    required this.title,
    required this.createdAt,
    required this.status,
  });

  factory CreateLocationCategory.fromJson(Map<String,dynamic> json) {
    return CreateLocationCategory(
      name: json['name'],
      title: json['title'],
      createdAt: json['createdAt'],
      status: json['status'],
    );
  }
}
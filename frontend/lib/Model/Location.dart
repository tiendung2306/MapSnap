class Location {
  final String locationName;
  final String role;
  final int visitedTime;
  final double longitude;
  final double latitude;
  final String title;
  final int createdAt;
  final String status;
  final String updatedByUser;
  final bool isAutomaticAdded;
  final List<String> pictures;

  // Constructor
  Location({
    required this.locationName,
    required this.role,
    required this.visitedTime,
    required this.longitude,
    required this.latitude,
    required this.title,
    required this.createdAt,
    required this.status,
    required this.updatedByUser,
    required this.isAutomaticAdded,
    this.pictures = const [],
  });

  // Factory method for creating a Location object from JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationName: json['locationName'],
      role: json['role'],
      visitedTime: json['visitedTime'] ,
      longitude: json['longitude'],
      latitude: json['latitude'],
      title: json['title'],
      createdAt: json['createdAt'],
      status: json['status'],
      updatedByUser: json['updatedByUser'],
      isAutomaticAdded: json['isAutomaticAdded'],
      pictures: List<String>.from(json['pictures'] ?? []),
    );
  }

  // Method for converting a Location object to JSON
  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'role': role,
      'visitedTime': visitedTime,
      'longitude': longitude,
      'latitude': latitude,
      'title': title,
      'createdAt': createdAt,
      'status': status,
      'updatedByUser': updatedByUser,
      'isAutomaticAdded': isAutomaticAdded,
      'pictures': pictures,
    };
  }
}
class Visit {
  final String userId;
  final String journeyId;
  final String locationId;
  final int visitedTime;
  final String title;
  final int startedAt;
  final int endedAt;
  final int updatedAt;
  final String status;
  final bool updatedByUser;
  final bool isAutomaticAdded;
  final List<String> pictures;

  // Constructor
  Visit({
    required this.userId,
    required this.journeyId,
    required this.locationId,
    required this.visitedTime,
    required this.title,
    required this.startedAt,
    required this.endedAt,
    required this.updatedAt,
    required this.status,
    required this.updatedByUser,
    required this.isAutomaticAdded,
    required this.pictures,
  });

  // Factory method for creating a Visit object from JSON
  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      userId: json['userId'],
      journeyId: json['journeyId'],
      locationId: json['locationId'],
      visitedTime: json['visitedTime'],
      title: json['title'],
      startedAt: json['startedAt'],
      endedAt: json['endedAt'],
      updatedAt: json['updatedAt'],
      status: json['status'],
      updatedByUser: json['updatedByUser'],
      isAutomaticAdded: json['isAutomaticAdded'],
      pictures: List<String>.from(json['pictures'] ?? []),
    );
  }

  // Method for converting a Visit object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'journeyId': journeyId,
      'locationId': locationId,
      'visitedTime': visitedTime,
      'title': title,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'updatedAt': updatedAt,
      'status': status,
      'updatedByUser': updatedByUser,
      'isAutomaticAdded': isAutomaticAdded,
      'pictures': pictures,
    };
  }
}

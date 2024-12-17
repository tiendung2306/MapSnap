class Visit {
  final String userId;
  final String journeyId;
  final String locationId;
  final String title;
  final int startedAt;
  final int endedAt;
  final int updatedAt;
  final String status;
  final bool updatedByUser;
  final bool isAutomaticAdded;
  final List<String> pictures;
  final String id;
  // Constructor
  Visit({
    required this.userId,
    required this.journeyId,
    required this.locationId,
    required this.title,
    required this.startedAt,
    required this.endedAt,
    required this.updatedAt,
    required this.status,
    required this.updatedByUser,
    required this.isAutomaticAdded,
    required this.pictures,
    required this.id,
  });

  // Factory method for creating a Visit object from JSON
  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      userId: json['userId'],
      journeyId: json['journeyId'],
      locationId: json['locationId'],
      title: json['title'],
      startedAt: json['startedAt'],
      endedAt: json['endedAt'],
      updatedAt: 1731072409,
      status: json['status'],
      updatedByUser: json['updatedByUser'],
      isAutomaticAdded: json['isAutomaticAdded'],
      pictures: List<String>.from(json['pictures'] ?? []),
      id: json['id'],
    );
  }

  // Method for converting a Visit object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'journeyId': journeyId,
      'locationId': locationId,
      'title': title,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'updatedAt': updatedAt,
      'status': status,
      'updatedByUser': updatedByUser,
      'isAutomaticAdded': isAutomaticAdded,
      'pictures': pictures,
      'id': id,
    };
  }
}

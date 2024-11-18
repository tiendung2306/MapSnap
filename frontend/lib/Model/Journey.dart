class Journey {
  final String userId;
  final List<String> visitIds;
  final String title;
  final int startedAt;
  final int endedAt;
  final int updatedAt;
  final String status;
  final bool updatedByUser;
  final bool isAutomaticAdded;

  Journey({
    required this.userId,
    required this.visitIds,
    required this.title,
    required this.startedAt,
    required this.endedAt,
    required this.updatedAt,
    required this.status,
    required this.updatedByUser,
    required this.isAutomaticAdded,
  });

  // Phương thức để chuyển từ JSON sang đối tượng Journey
  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      userId: json['userId'],
      visitIds: List<String>.from(json['visitIds']),
      title: json['title'],
      startedAt: json['startedAt'],
      endedAt: json['endedAt'],
      updatedAt: json['updatedAt'],
      status: json['status'],
      updatedByUser: json['updatedByUser'],
      isAutomaticAdded: json['isAutomaticAdded'],
    );
  }

  // Phương thức để chuyển từ đối tượng Journey sang JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'visitIds': visitIds,
      'title': title,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'updatedAt': updatedAt,
      'status': status,
      'updatedByUser': updatedByUser,
      'isAutomaticAdded': isAutomaticAdded,
    };
  }
}
